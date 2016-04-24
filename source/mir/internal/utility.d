module mir.internal.utility;

import std.traits;
import std.meta;

import mir.ndslice.slice;

package(mir):

template Iota(size_t i, size_t j)
{
    static assert(i <= j, "Iota: i should be less than or equal to j");
    static if (i == j)
        alias Iota = AliasSeq!();
    else
        alias Iota = AliasSeq!(i, Iota!(i + 1, j));
}

enum isSimpleSlice(S) = is(S : Slice!(N1, T1[]), size_t N1,T1) || is(S : Slice!(N2, T2*), size_t N2,T2);


auto toDense(R)(Slice!(1, R) x)
{
    assert(x.stride == 1);
    auto ptr = x.ptr;
    static if (isPointer!R)
    {
        return ptr[0 .. x.length];
    }
    else
    {
        return ptr.range[ptr.shift .. x.length + ptr.shift];
    }
}

alias ConstData(S : Slice!(N, T*), size_t N, T) = Slice!(N, const(T)*);
alias ConstData(S : Slice!(N, T[]), size_t N, T) = Slice!(N, const(T)[]);
alias ConstData(S : T[], T) = const(T)[];

enum isVector(V) = is(V : T1[], T1) || is(V : Slice!(1, T2*), T2);
enum isMatrix(M) = is(M : Slice!(2, T*), T);
