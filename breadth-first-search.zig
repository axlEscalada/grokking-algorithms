const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const TailQueue = std.TailQueue([]const u8);

pub fn main() !void {
    var general_purpose = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = general_purpose.deinit();
    var arena_allocator = std.heap.ArenaAllocator.init(general_purpose.allocator());
    const allocator = arena_allocator.allocator();
    defer arena_allocator.deinit();
    var hashmap = std.StringHashMap([][]const u8).init(allocator);
    var neighboors = [_][]const u8{ "alice", "bob", "claire" };
    var bob_n = [_][]const u8{ "anuj", "peggy" };
    var alice_n = [_][]const u8{"peggy"};
    var claire_n = [_][]const u8{ "thom", "jonny" };
    var anuj_n = [_][]const u8{};
    var peggy_n = [_][]const u8{};
    var thom_n = [_][]const u8{};
    var jonny_n = [_][]const u8{};
    try hashmap.put("you", &neighboors);
    try hashmap.put("bob", &bob_n);
    try hashmap.put("alice", &alice_n);
    try hashmap.put("claire", &claire_n);
    try hashmap.put("anuj", &anuj_n);
    try hashmap.put("peggy", &peggy_n);
    try hashmap.put("thom", &thom_n);
    try hashmap.put("jonny", &jonny_n);
    // try hashmap.put("y", .{ "alice", "bob", "clair" });
    const result = search(allocator, hashmap);
    print("RESULT: {}\n", .{result});
}

fn search(allocator: Allocator, map: std.StringHashMap([][]const u8)) bool {
    const first = map.get("you") orelse return false;
    var queue = TailQueue{};
    appendNodes(allocator, &queue, first);
    while (queue.popFirst()) |tail| {
        if (personIsSeller(tail.data)) {
            print("SELLER: {s}\n", .{tail.data});
            return true;
        } else {
            print("NOT SELLER: {s}\n", .{tail.data});
            const data = map.get(tail.data);
            if (data) |d| {
                appendNodes(allocator, &queue, d);
            }
        }
    }
    return false;
}

fn personIsSeller(name: []const u8) bool {
    return name[name.len - 1] == 'm';
}

fn appendNodes(allocator: Allocator, queue: *std.TailQueue([]const u8), list: [][]const u8) void {
    for (list) |person| {
        const node = allocator.create(TailQueue.Node) catch @panic("error while creating node");
        node.*.data = person;
        queue.append(node);
    }
}
