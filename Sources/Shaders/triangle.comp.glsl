#version 450

uniform vec2 p1;
uniform vec2 p2;
uniform vec2 p3;
uniform writeonly image2D destTex;

float sign(vec2 p1, vec2 p2, vec2 p3) {
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
}

bool inTriangle(vec2 pt, vec2 v1, vec2 v2, vec2 v3) {
    bool b1, b2, b3;
    b1 = sign(pt, v1, v2) < 0.0f;
    b2 = sign(pt, v2, v3) < 0.0f;
    b3 = sign(pt, v3, v1) < 0.0f;
    return b1 == b2 && b2 == b3;
}

void main() {
	ivec2 storePos = ivec2(gl_GlobalInvocationID.xy);
	if (inTriangle(vec2(storePos.x, storePos.y), p1, p2, p3)) {
		imageStore(destTex, storePos, vec4(1.0, 0.0, 0.0, 1.0));
	}
}
