using ManualMemory: MemoryBuffer, load, store!, LazyPreserve, preserve, PseudoPtr
using Test

@testset "ManualMemory.jl" begin

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
end

using ThreadingUtilities
include(joinpath(pkgdir(ThreadingUtilities), "test", "runtests.jl"))

