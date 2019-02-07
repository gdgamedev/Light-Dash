shader_type canvas_item;

uniform bool glow_shader;
uniform float glow_alpha;
uniform float glow_size;

uniform bool blur_shader;
uniform float blur_size;

uniform bool glitch_shader;
uniform float glitch_x;
uniform float glitch_y;

void fragment() {
	//cor padrão caso não houver shader
	vec4 col = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	vec2 uv = vec2(0.0, 0.0);
	
	//glitch shader
	if (glitch_shader) {
		
		uv = vec2(glitch_x, glitch_y);
		
		}
	
	//blur shader
	if (blur_shader) {
		
		col.rgb = textureLod( SCREEN_TEXTURE, SCREEN_UV, blur_size ).rgb;
		
		}
	
	//glow shader
	if (glow_shader) {
		vec3 glow;
		glow.r = textureLod( SCREEN_TEXTURE, SCREEN_UV + uv, glow_size ).r * glow_alpha;
		glow.g = textureLod( SCREEN_TEXTURE, SCREEN_UV, glow_size ).g * glow_alpha;
		glow.b = textureLod( SCREEN_TEXTURE, SCREEN_UV - uv, glow_size ).b * glow_alpha;
		col.rgb += glow;
		
		}
	
	
	
	//resultado de todos os filtros
	COLOR = col;
	}
	
	
	
	
	
	
	