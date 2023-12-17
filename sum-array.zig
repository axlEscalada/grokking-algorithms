const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    var arr = [_]u8{ 2, 4, 8, 2 };
    const sum = sumArray(&arr);
    print("Sum: {}\n", .{sum});
    const max = findMax(&arr);
    print("Max: {}\n", .{max});
}

fn sumArray(arr: []u8) u32 {
    if (arr.len == 1) return arr[0];
    return arr[arr.len - 1] + sumArray(arr[0 .. arr.len - 1]);
}

fn findMax(arr: []u8) u8 {
    if (arr.len == 1) return arr[0];
    const max = findMax(arr[0 .. arr.len - 1]);
    if (arr[arr.len - 1] <= max) {
        return max;
    } else return arr[arr.len - 1];
}
