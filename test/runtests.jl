using ManualMemory
using ManualMemory: MemoryBuffer, load, store!, LazyPreserve, preserve, PseudoPtr, Reference
using SparseArrays
using LinearAlgebra
using Test

@testset "ManualMemory.jl" begin
  @test ManualMemory.buffer(sparse([1; 2; 3], [1; 2; 3], [1; 2; 3])) ==
    ManualMemory.buffer(sparsevec([1, 2, 0, 0, 3, 0])) ==
    ManualMemory.buffer(Diagonal([1,2,3]))

  @test_throws AssertionError MemoryBuffer{4,String}(undef)
  m = MemoryBuffer{4,Float64}(undef);
  store!(pointer(m), 1.23)
  @test load(pointer(m)) == 1.23
  str = "Hello world!"
  GC.@preserve str begin
    store!(Base.unsafe_convert(Ptr{String}, m), str)
    @test load(Base.unsafe_convert(Ptr{String}, m)) === str
  end

  x = [0 0; 0 0];
  preserve(store!, LazyPreserve(x), 1)
  @test x[1] === 1
  p = PseudoPtr(x, 1)
  @test load(p) === 1
  p += 1
  store!(p, 2)
  @test load(p) === 2
  p = 1 + p
  store!(p, 3)
  @test load(p) === 3

  x = Reference{Int}()
  y = Reference(1)
  GC.@preserve x y begin
    store!(pointer(x), 1)
    @test load(pointer(x)) === 1 === load(pointer(y))
  end
end

using ThreadingUtilities
include(joinpath(pkgdir(ThreadingUtilities), "test", "runtests.jl"))

