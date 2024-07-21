shader_type canvas_item;

const float INFINITY = 999.9e16;
//const float PI = 3.14159265358979323;
const float PHI = 1.61803398874989484820459; // Golden Ratio
const float EARTH_RADIUS = 6360000.0; // in m
const float ATMOSPHERE_RADIUS = 6420000.0; // in m
const float SUN_POWER = 20.0;
const int SKY_SAMPLES = 16;
const int SUN_SAMPLES = 8;
#define SUNTIME (TIME / 2.0)
#define EPSILON_NRM (0.1 / (1024.0))//scren pixel size

const int ITER_GEOMETRY = 3;
const int ITER_FRAGMENT = 5;
const float SEA_HEIGHT = 0.6;
const float SEA_CHOPPY = 2.0;
const float SEA_SPEED = 0.8;
const float SEA_FREQ = 0.16;
const vec3 SEA_BASE = vec3(0.0, 0.09, 0.18);
const vec3 SEA_WATER_COLOR = vec3(0.8, 0.9, 0.6) * 0.6;
const mat2 octave_m = mat2(vec2(1.6, 1.2), vec2(-1.2, 1.6));
const int NUM_STEPS = 8;

float hash(vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return -1.0 + 2.0 * mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
                             mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float sea_octave(vec2 uv, float choppy) {
    uv += noise(uv);
    vec2 wv = 1.0 - abs(sin(uv));
    vec2 swv = abs(cos(uv));
    wv = mix(wv, swv, wv);
    return pow(1.0 - pow(wv.x * wv.y, 0.65), choppy);
}

float map(vec3 p) {
    float freq = SEA_FREQ;
    float amp = SEA_HEIGHT;
    float choppy = SEA_CHOPPY;
    vec2 uv = p.xz;
    uv.x *= 0.75;

    float d, h = 0.0;
    for (int i = 0; i < ITER_GEOMETRY; i++) {
        d = sea_octave((uv + TIME) * freq, choppy);
        d += sea_octave((uv - TIME) * freq, choppy);
        h += d * amp;
        uv *= octave_m;
        freq *= 1.9;
        amp *= 0.22;
        choppy = mix(choppy, 1.0, 0.2);
    }
    return p.y - h;
}

float map_detailed(vec3 p) {
    float freq = SEA_FREQ;
    float amp = SEA_HEIGHT;
    float choppy = SEA_CHOPPY;
    vec2 uv = p.xz;
    uv.x *= 0.75;

    float d, h = 0.0;
    for (int i = 0; i < ITER_FRAGMENT; i++) {
        d = sea_octave((uv + TIME) * freq, choppy);
        d += sea_octave((uv - TIME) * freq, choppy);
        h += d * amp;
        uv *= octave_m;
        freq *= 1.9;
        amp *= 0.22;
        choppy = mix(choppy, 1.0, 0.2);
    }
    return p.y - h;
}

vec3 getNormal(vec3 p, float eps) {
    vec3 n;
    n.y = map_detailed(p);
    n.x = map_detailed(vec3(p.x + eps, p.y, p.z)) - n.y;
    n.z = map_detailed(vec3(p.x, p.y, p.z + eps)) - n.y;
    n.y = eps;
    return normalize(n);
}

float heightMapTracing(vec3 origin, vec3 direction, inout vec3 p) {
    float tm = 0.0;
    float tx = 1000.0;
    float hx = map(origin + direction * tx);
    if (hx > 0.0)
        return tx;
    float hm = map(origin + direction * tm);
    float tmid = 0.0;
    for (int i = 0; i < NUM_STEPS; i++) {
        tmid = mix(tm, tx, hm / (hm - hx));
        p = origin + direction * tmid;
        float hmid = map(p);
        if (hmid < 0.0) {
            tx = tmid;
            hx = hmid;
        } else {
            tm = tmid;
            hm = hmid;
        }
    }
    return tmid;
}

float diffuse(vec3 n, vec3 l, float p) {
    return pow(dot(n, l) * 0.4 + 0.6, p);
}

float specular(vec3 n, vec3 l, vec3 e, float s) {
    float nrm = (s + 8.0) / (PI * 8.0);
    return pow(max(dot(reflect(e, n), l), 0.0), s) * nrm;
}

bool solveQuadratic(float a, float b, float c, out float t0, out float t1) {
    float discrim = b * b - 4.0 * a * c;
    if (discrim < 0.0)
        return false;
    float rootDiscrim = sqrt(discrim);
    float q = (b > 0.0) ? -0.5 * (b + rootDiscrim) : -0.5 * (b - rootDiscrim);
    t1 = q / a;
    t0 = c / q;
    return true;
}

bool PlanetSphereIntersect(vec3 origin, vec3 direction, float rad, vec3 pos, inout float t0, inout float t1) {
    vec3 L = origin - pos;
    float a = dot(direction, direction);
    float b = 2.0 * dot(direction, L);
    float c = dot(L, L) - (rad * rad);

    if (!solveQuadratic(a, b, c, t0, t1))
        return false;

    float temp;
    if (t0 > t1) {
        temp = t0;
        t0 = t1;
        t1 = temp;
    }
    return true;
}

vec3 calculateSkySphereColor(vec3 origin, vec3 direction, float tmin, float tmax, vec3 sunDirection) {
    vec3 earthCenter = vec3(0, -1.0 * EARTH_RADIUS, 0);
    vec3 betaR = vec3(3.8e-6, 13.5e-6, 33.1e-6);
    vec3 betaM = vec3(21e-6);
    float Hr = 7994.0;
    float Hm = 1200.0;
    float t0, t1;
    if (!PlanetSphereIntersect(origin, direction, ATMOSPHERE_RADIUS, earthCenter, t0, t1) || t1 < 0.0)
        return vec3(0);
    if (t0 > tmin && t0 > 0.0)
        tmin = t0;
    if (t1 < tmax)
        tmax = t1;
    float segmentLength = (tmax - tmin) / float(SKY_SAMPLES);
    float tCurrent = tmin;
    vec3 sumR = vec3(0); // rayleigh contribution
    vec3 sumM = vec3(0); // mie contribution
    float opticalDepthR = 0.0;
    float opticalDepthM = 0.0;
    float mu = dot(direction, sunDirection);
    float phaseR = 3.0 / (16.0 * PI) * (1.0 + mu * mu);
    float g = 0.76;
    float phaseM = 3.0 / (8.0 * PI) * ((1.0 - g * g) * (1.0 + mu * mu)) / ((2.0 + g * g) * pow(max(0.0, 1.0 + g * g - 2.0 * g * mu), 1.5));

    for (int i = 0; i < SKY_SAMPLES; ++i) {
        vec3 samplePosition = origin + (tCurrent) * direction;
        float height = length(samplePosition - earthCenter) - EARTH_RADIUS;

        float hr = exp(-height / Hr) * segmentLength;
        float hm = exp(-height / Hm) * segmentLength;
        opticalDepthR += hr;
        opticalDepthM += hm;

        float t0Light, t1Light;
        PlanetSphereIntersect(samplePosition, sunDirection, ATMOSPHERE_RADIUS, earthCenter, t0Light, t1Light);
        float segmentLengthLight = t1Light / float(SUN_SAMPLES);
        float tCurrentLight = 0.0;
        float opticalDepthLightR = 0.0;
        float opticalDepthLightM = 0.0;
        int jCounter = 0;
        for (int j = 0; j < SUN_SAMPLES; ++j) {
            vec3 samplePositionLight = samplePosition + (tCurrentLight) * sunDirection;
            float heightLight = length(samplePositionLight - earthCenter) - EARTH_RADIUS;
            if (heightLight < 0.0)
                break;
            jCounter += 1;
            opticalDepthLightR += exp(-heightLight / Hr) * segmentLengthLight;
            opticalDepthLightM += exp(-heightLight / Hm) * segmentLengthLight;
            tCurrentLight += segmentLengthLight;
        }
        if (jCounter == SUN_SAMPLES) {
            vec3 tau = betaR * (opticalDepthR + opticalDepthLightR) + betaM * 1.1 * (opticalDepthM + opticalDepthLightM);
            vec3 attenuation = vec3(exp(-tau.x), exp(-tau.y), exp(-tau.z));
            sumR += attenuation * hr;
            sumM += attenuation * hm;
        }
        tCurrent += segmentLength;
    }

    vec3 attenuate_vec = (sumR * betaR * phaseR + sumM * betaM * phaseM) * SUN_POWER;
    if (attenuate_vec.x < 1.413) {
        attenuate_vec.x = pow(attenuate_vec.x * 0.38317, 1.0 / 2.2);
    } else {
        attenuate_vec.x = 1.0 - exp(-attenuate_vec.x);
    }
    if (attenuate_vec.y < 1.413) {
        attenuate_vec.y = pow(attenuate_vec.y * 0.38317, 1.0 / 2.2);
    } else {
        attenuate_vec.y = 1.0 - exp(-attenuate_vec.y);
    }
    if (attenuate_vec.z < 1.413) {
        attenuate_vec.z = pow(attenuate_vec.z * 0.38317, 1.0 / 2.2);
    } else {
        attenuate_vec.z = 1.0 - exp(-attenuate_vec.z);
    }
    return attenuate_vec;
}

vec3 perspectiveCameraRayDirection(vec2 pixelCoord) {
    vec2 pixelPos = (pixelCoord) * 2.0 - 1.0;
    vec3 camRight = vec3(1.0, 0.0, 0.0);
    vec3 camUp = vec3(0.0, 1.0, 0.0);
    vec3 camForward = vec3(0.0, 0.0, 1.0);
    return normalize(pixelPos.x * camRight + pixelPos.y * camUp + camForward);
}

vec3 getSeaColor(vec3 p, vec3 n, vec3 l, vec3 eye, vec3 dist) {
    float fresnel = clamp(1.0 - dot(n, -eye), 0.0, 1.0);
    fresnel = pow(fresnel, 3.0) * 0.5;

    vec3 reflected = calculateSkySphereColor(p, reflect(eye, n), 0.0, INFINITY, l);
    vec3 base = SEA_BASE * calculateSkySphereColor(p, vec3(1.0), 0.0, INFINITY, l);
    vec3 refracted = base + diffuse(n, l, 80.0) * SEA_WATER_COLOR * 0.12;

    vec3 color = mix(refracted, reflected, fresnel);

    float atten = max(1.0 - dot(dist, dist) * 0.01, 0.0);
    color += SEA_WATER_COLOR * (p.y - SEA_HEIGHT) * 0.18 * atten;
    color += vec3(specular(n, l, eye, 20.0)) * 0.8 * reflected;
    return color;
}

vec4 pixel(vec2 uv) {
    vec3 origin = vec3(0.0, 3.0, -15.0);
    vec3 direction = perspectiveCameraRayDirection(uv);
    vec3 sunDir = normalize(vec3(0, abs(cos(SUNTIME)) / 2.0 - 0.2, abs(sin(SUNTIME)) * 2.0));
    vec3 sky = calculateSkySphereColor(origin, direction, 0.0, INFINITY, sunDir);
    vec3 p;
    heightMapTracing(origin, direction, p);
    vec3 dist = p - origin;
    vec3 n = getNormal(p, dot(dist, dist) * EPSILON_NRM);

    vec3 waves = mix(
        sky,
        getSeaColor(p, n, sunDir, direction, dist),
        pow(smoothstep(0.0, -0.5, direction.y), 0.5));

    return vec4(waves, 1.0);
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / vec2(1.0/SCREEN_PIXEL_SIZE.x, 1.0/SCREEN_PIXEL_SIZE.y);
    uv.y = 1.0 - uv.y; // Invert the y-component
    vec2 aa = 0.25 / vec2(1.0/SCREEN_PIXEL_SIZE.x, 1.0/SCREEN_PIXEL_SIZE.y);
    vec4 fragColor = pixel(uv);
    fragColor += pixel(uv + aa);
    fragColor *= 0.5;
    COLOR = fragColor;
}

