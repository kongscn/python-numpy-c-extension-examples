import std.stdio;
import std.random;
import std.math;
import std.datetime;
import std.algorithm;


struct Point{
    double x;
    double y;
}

class World{
    int N;
    double dt = 1e-3;
    double[] m;
    Point[] r;
    Point[] v;
    Point[] F;
    Point[] s;
    double[] s3;

    int threads = 1;
    double m_min = 1.0;
    double m_max = 30.0;
    double r_max = 50.0;
    double v_max = 4.0;

    this(int _N){
        N = _N;
        m.length = N;
        r.length = N;
        v.length = N;
        F.length = N;
        s.length = N;
        s3.length = N;
        foreach(i; 0 .. N){
            m[i] = uniform(m_min, m_max);
            r[i].x = uniform(-r_max, r_max);
            r[i].y = uniform(-r_max, r_max);
            v[i].x = uniform(-v_max, v_max);
            v[i].y = uniform(-v_max, v_max);
            F[i].x = 0.0;
            F[i].y = 0.0;
        }
    }
}

void compute_F(World w){
    double sx, sy,  s3, Fx, Fy, tmp;
    foreach(i; 0 .. w.N){
        foreach(j; i+1 .. w.N){
            sx = w.r[j].x - w.r[i].x;
            sy = w.r[j].y - w.r[i].y;
 
            s3 = sqrt(sx * sx + sy * sy);
            s3 *= s3 * s3;
 
            tmp = w.m[i] * w.m[j] / s3;
            Fx = tmp * sx;
            Fy = tmp * sy;
 
            w.F[i].x += Fx;
            w.F[i].y += Fy;
 
            w.F[j].x -= Fx;
            w.F[j].y -= Fy;
        }
    }
}

void evolve(World w, int steps){
    foreach(_; 0 .. steps){
        compute_F(w);
        foreach(i; 0 .. w.N){
            w.v[i].x += w.F[i].x * w.dt / w.m[i];
            w.v[i].y += w.F[i].y * w.dt / w.m[i];

            w.r[i].x += w.v[i].x * w.dt;
            w.r[i].y += w.v[i].y * w.dt;
        }
    }
}

void main(){
    auto nperson = 100;
    auto steps = 4096;
    int ntrials = 5;
    auto tm1 = Clock.currTime();
    World w = new World(nperson);
    auto tm2 = Clock.currTime();
    double[] rest;
    rest.length = ntrials;
    foreach(i; 0 .. ntrials)
    {
        auto tms = Clock.currTime();
        evolve(w, steps);
        auto tmf = Clock.currTime();
        auto dtm = tmf - tms;
        rest[i] = 1 / (dtm.total!("usecs")()*1e-6) * steps;
    }
    auto ordered = sort(rest);
    writefln("Naive D lang: best %s steps/sec", ordered[$-1]);  
}