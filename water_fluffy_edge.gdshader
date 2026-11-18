shader_type spatial;
render_mode blend_mix, depth_prepass_alpha;

uniform sampler2D HeightMap;

void vertex() {
	// Called for every vertex the material is visible on.

	//
}

void fragment() {
	// Called for every pixel the material is visible on.
	float value = texture(HeightMap, UV).r;
	ALBEDO = vec3(0,0,value);
	float h = 0.08f;
	float m = 0.01;
	if( value > h-m && value < h+m){
		ALBEDO = vec3(0,value,0);
		
	}
	//PREMUL_ALPHA_FACTOR = 0.0f;
	
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
