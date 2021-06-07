module ManualMemory

mutable struct MemoryBuffer{N,T}
  data::NTuple{N,T}
  @inline function MemoryBuffer{N,T}(::UndefInitializer) where {N,T}
    @assert Base.allocatedinline(T)
    new{N,T}()
  end
end
@inline Base.unsafe_convert(::Type{Ptr{T}}, m::MemoryBuffer) where {T} = Ptr{T}(pointer_from_objref(m))
@inline Base.pointer(m::MemoryBuffer{N,T}) where {N,T} = Ptr{T}(pointer_from_objref(m))

@generated function load(p::Ptr{T}) where {T}
  if Base.allocatedinline(T)
    Expr(:block, Expr(:meta,:inline), :(unsafe_load(p)))
  else
    Expr(:block, Expr(:meta,:inline), :(ccall(:jl_value_ptr, Ref{$T}, (Ptr{Cvoid},), unsafe_load(Base.unsafe_convert(Ptr{Ptr{Cvoid}}, p)))))
  end
end
@generated function store!(p::Ptr{T}, v::T) where {T}
  if Base.allocatedinline(T)
    Expr(:block, Expr(:meta,:inline), :(unsafe_store!(p, v); return nothing))
  else
    Expr(:block, Expr(:meta,:inline), :(unsafe_store!(Base.unsafe_convert(Ptr{Ptr{Cvoid}}, p), Base.pointer_from_objref(v)); return nothing))
  end
end
@generated offsetsize(::Type{T}) where {T} = Base.allocatedinline(T) ? sizeof(T) : sizeof(Int)

@inline store!(p::Ptr{T}, v) where {T} = store!(p, convert(T, v))
@inline preserve_buffer(x) = x
@inline preserve_buffer(A::AbstractArray) = _preserve_buffer(A, parent(A))
@inline _preserve_buffer(a::A, p::P) where {A,P<:AbstractArray} = _preserve_buffer(p, parent(p))
@inline _preserve_buffer(a::A, p::A) where {A<:AbstractArray} = a
@inline _preserve_buffer(a::A, p::P) where {A,P} = p

end
