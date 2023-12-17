const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    const f = fact(3);
    print("RS: {}\n", .{f});
}

fn fact(x: u8) u8 {
    if (x == 1) return 1;
    return x * fact(x - 1);
}
