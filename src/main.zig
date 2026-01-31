const std = @import("std");

pub fn main(init: std.process.Init) !void {
    _ = init;
}

test "placeholder test" {
    try std.testing.expect(true);
}
