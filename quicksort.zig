const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;

pub fn main() void {
    var general_purpose = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = general_purpose.deinit();
    const allocator = general_purpose.allocator();
    var arena_allocator = std.heap.ArenaAllocator.init(allocator);
    const alloc = arena_allocator.allocator();
    defer arena_allocator.deinit();
    var arr = [_]u8{ 10, 5, 2, 3 };

    const sorted_arr = quickSort(alloc, &arr);
    print("Sorted: {any}\n", .{sorted_arr});
}

fn quickSort(allocator: Allocator, arr: []u8) []u8 {
    print("Arr: {any}\n", .{arr});
    var left = std.ArrayList(u8).init(allocator);
    var right = std.ArrayList(u8).init(allocator);
    var result = std.ArrayList(u8).init(allocator);

    if (arr.len == 0) return arr;
    const pivot = arr[0];

    for (arr) |a| {
        if (a < pivot) {
            left.append(a) catch @panic("error while appending");
        } else if (a > pivot) {
            right.append(a) catch @panic("error while appending");
        }
    }
    // print("LEFT {any}\n RIGHT {any} \n", .{ left.items, right.items });
    result.appendSlice(quickSort(allocator, left.items)) catch @panic("erro while appending");
    result.append(pivot) catch @panic("erro while appending");
    result.appendSlice(quickSort(allocator, right.items)) catch @panic("erro while appending");
    return result.items;
}
