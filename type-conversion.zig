const std = @import("std");
const assert = std.debug.assert;

fn cvrtPtrToOptionalPtrArray(comptime T: type) type {
  const info = @typeInfo(T).Pointer;
  return if (info.is_const) ?[*]const info.child else ?[*]info.child;
}

pub fn ptr(p: var) cvrtPtrToOptionalPtrArray(@typeOf(p)) {
  return @ptrCast(cvrtPtrToOptionalPtrArray(@typeOf(p)), p);
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
