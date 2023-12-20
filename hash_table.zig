const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var general_purpose = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = general_purpose.deinit();
    var arena_allocator = std.heap.ArenaAllocator.init(general_purpose.allocator());
    const allocator = arena_allocator.allocator();
    defer arena_allocator.deinit();
    var hashmap = std.StringHashMap(u32).init(allocator);
    try hashmap.put("jenny", 8675309);
    try hashmap.put("emergency", 911);

    print("{?}\n", .{hashmap.get("jenny")});
}

//A good rule of thumb is, resize when your load factor is greater than 0.7.
