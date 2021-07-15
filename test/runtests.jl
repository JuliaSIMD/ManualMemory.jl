using ManualMemory
using ManualMemory: MemoryBuffer, load, store!, preserve
using Test

@testset "ManualMemory.jl" begin
  @test_throws AssertionError MemoryBuffer{4,String}(undef)

  m = ManualMemory.MemoryBuffer{4,Float64}(undef)
  d = ManualMemory.DynamicBuffer{Float64}(undef, 4)
  b = ManualMemory.ImmutableBuffer((1.23, 2.0, 3.0, 4.0))

  @test eltype(m) <: Float64
  @test eltype(d) <: Float64
  @test eltype(b) <: Float64
  store!(pointer(m), 1.23)
  store!(pointer(d), 1.23)
  @test load(pointer(m)) == 1.23
  @test load(pointer(d)) == 1.23
  @test load(pointer(b)) == 1.23
  @test length(m) === 4
  @test length(d) === 4
  @test length(b) === 4
  str = "Hello world!"
  GC.@preserve str begin
    store!(Base.unsafe_convert(Ptr{String}, m), str)
    @test load(Base.unsafe_convert(Ptr{String}, m)) === str
  end
  GC.@preserve str begin
    store!(Base.unsafe_convert(Ptr{String}, d), str)
    @test load(Base.unsafe_convert(Ptr{String}, d)) === str
  end

  x = [0 0; 0 0];
  preserve(store!, ManualMemory.LazyPreserve(x), 1)
  @test x[1] === 1
  p = ManualMemory.PseudoPtr(x, 1)
  @test load(p) === 1
  p += 1
  store!(p, 2)
  @test load(p) === 2
  p = 1 + p
  store!(p, 3)
  @test load(p) === 3
end

using ThreadingUtilities
include(joinpath(pkgdir(ThreadingUtilities), "test", "runtests.jl"))

