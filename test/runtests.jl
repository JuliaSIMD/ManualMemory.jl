using ManualMemory: MemoryBuffer, load, store!
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
end

using ThreadingUtilities
include(joinpath(pkgdir(ThreadingUtilities), "test", "runtests.jl"))

