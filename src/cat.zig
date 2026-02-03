const std = @import("std");

const Io = std.Io;
const process = std.process;

const version = "0.0.1";

const Options = struct {
    number_lines: bool = false,
    show_ends: bool = false,
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.gpa;

    var options = Options{};
    var iterator = init.minimal.args.iterate();

    while (iterator.next()) |v| {
        if (std.mem.eql(u8, v, "-n") or std.mem.eql(u8, v, "--number")) {
            options.number_lines = true;
        } else if (std.mem.eql(u8, v, "-E") or std.mem.eql(u8, v, "--show-ends")) {
            options.show_ends = true;
        }
    }

    const cwd = Io.Dir.cwd();
    const stat = try cwd.statFile(io, "test/foo.c", .{});

    const buff = try allocator.alloc(u8, stat.size);
    defer allocator.free(buff);

    const content = try cwd.readFile(io, "test/foo.c", buff);

    std.debug.print("content: {s}\nsize: {any}\n", .{ content, stat.size });
    std.debug.print("{}, {}\n", .{ options.number_lines, options.show_ends });
    _, _ = .{ io, allocator };
}
