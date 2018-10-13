# Type conversion

In Andrew Kelly's [tetris](https://github.com/andrewrk/tetris) game
he created `fn ptr` has some code duplication:
```
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
    p.?[0] = 123;
}

fn c(p: ?[*]const u64) u64 {
    return p.?[0] * 2;
}

test "ptr" {
    var v: u64 = 321;
    z(ptr(&v)); 
    assert(v == 123);
    assert(c(ptr(&v)) == (123 * 2));
}
```
But, of course, works fine:
```
$ zig test --test-filter ptr type-conversion.zig 
Test 1/1 ptr...OK
All tests passed.
```

I tried to remove the duplicate code by adding `fn PtrT`:
```
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
    z(PtrT(&v)); // error: unable to evalue const expression
    assert(v == 123);
    assert(c(ptr(&v)) == (123 * 2));
}
```
But then I get a compile error: 
```
$ zig test --test-filter PtrT type-conversion.zig 
/home/wink/prgs/ziglang/zig-type-conversion/type-conversion.zig:43:13: error: unable to evaluate constant expression
    z(PtrT(&v)); // error: unable to evalue const expression
            ^
```

So obviously I didn't do it correctly, is there a way to remove the duplicate code?
