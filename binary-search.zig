const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    var arr = [8]u8{ 1, 24, 31, 40, 60, 98, 99, 140 };
    const result = binarySearch(&arr, 99);
    std.debug.print("RESULT: {?}", .{result});
}

fn binarySearch(arr: []u8, item: u8) ?usize {
    var low: usize = 0;
    var high = arr.len - 1;

    while (low <= high) {
        const mid = (low + high) / 2;

        std.debug.print("run {}\n", .{mid});
        const guess = arr[mid];
        if (guess == item) return mid;
        if (guess > item) {
            high = mid - 1;
        } else {
            low = mid + 1;
        }
    }

    return null;
}
