shader_type canvas_item;

void fragment() {
	lowp vec4 col = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	
	lowp vec2 uv = SCREEN_UV;
	
	uv -= mod(uv, vec2(0.005, 0.005));
	
	col = textureLod(SCREEN_TEXTURE, uv, 0.0);
	
	COLOR = col;
	
	
	
	}