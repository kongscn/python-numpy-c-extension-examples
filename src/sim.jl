# Naive Julia lang implementation

type World
    threads::Int
    N::Int
    m::Vector{Float64}
    r::Matrix{Float64}
    v::Matrix{Float64}
    F::Matrix{Float64}
    s::Matrix{Float64}
    s3::Vector{Float64}
    dt::Float64
    function World(N::Int, threads::Int=1, m_min::Float64=1.0, m_max::Float64=30.0, r_max::Float64=50.0, v_max::Float64=4.0, dt::Float64=1e-3)
        m = rand(N) * (m_max-m_min)/2 + (m_max-m_min)/2
        r = rand(N,2) * r_max
        v = rand(N,2) * v_max
        F = zeros(r)
        s = zeros(r)
        s3 = zeros(m)
        new(threads, N, m, r, v, F, s, s3, dt)
    end
end

function compute_F(w::World)
    for i in 1:w.N
        for j in i+1:w.N
            sx = w.r[j,1] - w.r[i,2]
            sy = w.r[j,1] - w.r[i,2]
 
            s3 = sqrt(sx * sx + sy * sy)
            s3 *= s3 * s3
 
            tmp = w.m[i] * w.m[j] / s3
            Fx = tmp * sx
            Fy = tmp * sy
 
            w.F[i,1] += Fx
            w.F[i,2] += Fy
 
            w.F[j,1] -= Fx
            w.F[j,2] -= Fy
        end
    end
end

function evolve(w::World, steps::Int)
    for _ in 1:steps
        compute_F(w)
        for i in 1:w.N
            w.v[i,1] += w.F[i,1] * w.dt / w.m[i]
            w.v[i,2] += w.F[i,2] * w.dt / w.m[i]
            w.r[i,1] += w.v[i,1] * w.dt
            w.r[i,2] += w.v[i,2] * w.dt
        end
    end
end


w = World(100)

ntrials = 5
steps = 10240
t = zeros(ntrials)
for i=1:ntrials
    rt = @elapsed evolve(w, steps)
    t[i] = 1 / rt * steps
end
maxsteps = maximum(t) 

@printf "Naive Julia: best %d steps/sec\n" maxsteps
