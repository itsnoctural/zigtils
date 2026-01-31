const std = @import("std");

const Io = std.Io;
const process = std.process;

const version = "0.0.1";

const Options = struct {
    number_lines: bool,
    show_ends: bool,
};

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.gpa;
    const args = parseArguments(init.minimal.args);

    _ = io;
    _ = allocator;
    _ = args;
}

fn parseArguments(args: process.Args) void {}
