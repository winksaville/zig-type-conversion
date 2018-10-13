const std = @import("std");
const assert = std.debug.assert;

pub fn ptr(p: var) t: {
        const T = @typeOf(p);
        const info = @typeInfo(@typeOf(p)).Pointer;
        break :t if (info.is_const) ?[*]const info.child else ?[*]info.child;
} {
    const ReturnType = t: {
        const T = @typeOf(p);
        const info = @typeInfo(@typeOf(p)).Pointer;
        break :t if (info.is_const) ?[*]const info.child else ?[*]info.child;
    };
    return @ptrCast(ReturnType, p);
}

fn z(p: ?[*]u64) void {
    p.?.* = 123;
}

fn c(p: ?[*]const u64) u64 {
    return p.?[0] * 2; // p.?.* not allowed, compiler required array index syntax
}

test "ptr" {
    var v: u64 = 321;
    z(ptr(&v)); 
    assert(v == 123);
    assert(c(ptr(&v)) == (123 * 2));
}

pub fn PtrT(p: var) type {
    const ReturnType = t: {
        const T = @typeOf(p);
        const info = @typeInfo(@typeOf(p)).Pointer;
        break :t if (info.is_const) ?[*]const info.child else ?[*]info.child;
    };
    return @ptrCast(ReturnType, p);
}

test "PtrT" {
    var v: u64 = 321;
    z(PtrT(&v)); // error: unable to evaluate const expression
    assert(v == 123);
    assert(c(ptr(&v)) == (123 * 2));
}
