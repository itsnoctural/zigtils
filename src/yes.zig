const std = @import("std");

const BUFFER_SIZE = 8192;
const help_command =
    \\Usage: yes [STRING]...
    \\  or: yes OPTION
    \\Repeatedly output a line with all specified STRING(s), or 'y'.
    \\
    \\      --help        display this help and exit
    \\      --version     output version information and exit
    \\
;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.gpa;

    var buff: [1024]u8 = undefined;
    var writer = std.Io.File.stdout().writer(io, &buff);

    const stdout = &writer.interface;

    var operands: std.ArrayList(u8) = .empty;
    defer operands.deinit(allocator);

    try operands.ensureTotalCapacity(allocator, BUFFER_SIZE);

    var iterator = init.minimal.args.iterate();
    _ = iterator.skip();

    while (iterator.next()) |v| {
        if (std.mem.eql(u8, v, "--help")) {
            try stdout.writeAll(help_command);
            return try stdout.flush();
        } else if (std.mem.eql(u8, v, "--version")) { // todo: move to shared file
            try stdout.writeAll("yes (zigtils) 0.0.0\n");
            return try stdout.flush();
        } else {
            try operands.appendSlice(allocator, v);
            try operands.appendSlice(allocator, " ");
        }
    }

    if (operands.items.len == 0) { // todo: better way for defaults?
        try operands.appendSlice(allocator, "y");
    }

    try operands.append(allocator, '\n');

    const operands_copy = operands.items;
    const operands_len = operands.items.len;

    while (operands.items.len + operands_len <= operands.capacity) {
        try operands.appendSlice(allocator, operands_copy);
    }

    while (true) {
        _ = std.os.linux.write(1, operands.items.ptr, BUFFER_SIZE); // todo: unify
    }
}
