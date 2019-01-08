shader_type canvas_item;
render_mode unshaded;

uniform float blursize = 1.0;
uniform float bluralpha = 0.1;

void fragment() {
	lowp vec4 glow_col = textureLod(SCREEN_TEXTURE, SCREEN_UV, blursize);
	
	glow_col.a = bluralpha;
	
	lowp vec4 col = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0) + glow_col;
	
	COLOR = col;
	}