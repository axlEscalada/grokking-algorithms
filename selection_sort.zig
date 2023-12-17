const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn main() !void {
    var general_alloc = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = general_alloc.allocator();
    var arr = [_]u8{ 50, 10, 4, 12, 24, 1 };
    var sorted_arr = selectionSort(allocator, &arr);
    std.debug.print("Sorted: {any}\n", .{sorted_arr});
}

//Using allocator in runtime to store in the stack
fn selectionSort(allocator: Allocator, arr: []u8) ![]u8 {
    var list = std.ArrayList(u8).initCapacity(allocator, arr.len) catch @panic("err while init list");
    defer list.deinit();
    try list.appendSlice(arr);
    var new_list = std.ArrayList(u8).initCapacity(allocator, arr.len) catch @panic("err while init list");
    defer new_list.deinit();
    for (arr) |_| {
        var slice = list.items;
        var small = findSmallest(slice);
        std.debug.print("index: {} len: {}\n", .{ small, list.items.len });
        var item = list.orderedRemove(small);
        new_list.append(item) catch @panic("error while appending item to list");
    }
    return new_list.toOwnedSlice();
}

fn findSmallest(arr: []u8) usize {
    var smallest = arr[0];
    var smallest_index: usize = 0;
    for (arr, 0..) |a, i| {
        if (a < smallest) {
            smallest = a;
            smallest_index = i;
        }
    }
    return smallest_index;
}
