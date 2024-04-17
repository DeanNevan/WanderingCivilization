shader_type spatial;

uniform mat4 transform;

uniform vec3 color : source_color = vec3(0.5, 0.5, 0.5);
uniform vec3 emission_color : source_color = vec3(0.5, 0.5, 0.5);
uniform float emission_strength : hint_range(0.0, 100.0, 0.1) = 1.0;
uniform sampler2D height_gradient;
uniform sampler2D vertical_noise;
uniform float height_scale : hint_range(0.0, 5.0, 0.01) = 1.0;
uniform float rotate_speed : hint_range(0.0, 1.0, 0.01) = 0.05;
varying float x;
varying float y;
varying float z;

float get_len(vec2 a) {
	return sqrt(a.x * a.x + a.y * a.y);
}

float get_rad(vec2 a, vec2 b){
	return acos((a.x * b.x + a.y * b.y) / (get_len(a) * get_len(b)));
}

void vertex() {
	//VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
    //NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
	//y = (inverse(MODEL_MATRIX) * vec4(VERTEX, 1.0)).y;
	vec4 vec = inverse(transform) * vec4(VERTEX, 1.0);
	x = vec.x;
	y = vec.y;
	z = vec.z;
	// Called for every vertex the material is visible on.
}

void fragment() {
	//ALPHA = 0.1;
	//float x;
	//float y;
	//float z;
	//x = (inverse(MODEL_MATRIX) * vec4(VERTEX, 1.0)).x;
	//y = (inverse(MODEL_MATRIX) * vec4(VERTEX, 1.0)).y;
	//z = (inverse(MODEL_MATRIX) * vec4(VERTEX, 1.0)).z;
	//x = VERTEX.x;
	//y = VERTEX.y;
	//z = VERTEX.z;
	
	
	
	float ang = get_rad(vec2(x, z), vec2(1, 0));
	if (z <= 0.0) {
		ang = -ang;
	}
	ang = (ang + PI) / (2.0 * PI);
	ang += TIME * rotate_speed;
	
	float yy = clamp(y * 0.5 * (5.0 - height_scale), 0.0, 0.5);
	float alpha = texture(height_gradient, vec2(yy, 0)).r;
	alpha = 1.0 - alpha;
	alpha *= texture(vertical_noise, vec2(ang, ang)).r;
	ALPHA = alpha;
	ALBEDO = color;
	EMISSION = emission_color * emission_strength;
	
	
	
	//ALPHA = texture(height_gradient, vec2((y + 1.0) * 0.5, 0)).x;
		//ALBEDO = vec3(1.0, 0.0, 0.0);
		//ALPHA = 
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
