const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const TailQueue = std.TailQueue([]const u8);

pub fn main() !void {
    var general_purpose = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = general_purpose.deinit();
    var arena_allocator = std.heap.ArenaAllocator.init(general_purpose.allocator());
    defer arena_allocator.deinit();
    const allocator = arena_allocator.allocator();
    var graph = std.StringHashMap(std.StringHashMap(f64)).init(allocator);
    var start = std.StringHashMap(f64).init(allocator);
    var a = std.StringHashMap(f64).init(allocator);
    var b = std.StringHashMap(f64).init(allocator);
    const fin = std.StringHashMap(f64).init(allocator);

    try start.put("a", 6);
    try start.put("b", 2);
    try a.put("fin", 1);
    try b.put("a", 3);
    try b.put("fin", 5);
    try graph.put("start", start);
    try graph.put("a", a);
    try graph.put("b", b);
    try graph.put("fin", fin);

    var costs = std.StringHashMap(f64).init(allocator);
    var parents = std.StringHashMap([]const u8).init(allocator);
    const max = std.math.floatExponentMax(f64);
    try costs.put("a", 6);
    try costs.put("b", 2);
    try costs.put("fin", max);
    try parents.put("a", "start");
    try parents.put("b", "start");

    var processed = std.BufSet.init(allocator);

    var lowest_node = findLowestCostNode(processed, costs);
    while (lowest_node) |node| {
        const cost = costs.get(node).?;
        var neighbors = graph.get(node).?;
        var it = neighbors.keyIterator();
        while (it.next()) |n| {
            const new_cost = cost + neighbors.get(n.*).?;
            const node_cost = costs.get(n.*);
            if (node_cost != null and node_cost.? > new_cost) {
                try costs.put(n.*, new_cost);
                try parents.put(n.*, node);
            }
        }
        try processed.insert(node);
        lowest_node = findLowestCostNode(processed, costs);
    }
    // var start = graph.get("start").?;
    // var it = start.keyIterator();
    // while (it.next()) |s| {
    //     print("{s}\n", .{s.*});
    // }
    // print("{}\n", .{graph.get("start").?.get("a").?});
    // print("{}\n", .{graph.get("start").?.get("b").?});
}

fn findLowestCostNode(processed: std.BufSet, costs: std.StringHashMap(f64)) ?[]const u8 {
    var lowest_cost = std.math.floatMax(f64);
    var lowest_cost_node: ?[]const u8 = null;
    var it = costs.iterator();
    while (it.next()) |node| {
        const cost = node.value_ptr.*;
        if (cost < lowest_cost and !processed.contains(node.key_ptr.*)) {
            lowest_cost = cost;
            lowest_cost_node = node.key_ptr.*;
        }
    }
    return lowest_cost_node;
}
