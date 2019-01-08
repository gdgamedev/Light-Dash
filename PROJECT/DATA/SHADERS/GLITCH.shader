shader_type canvas_item;

uniform float alb_size : hint_range(-0.1, 0.1);
uniform float alb_alpha = 0;

void fragment() {
	vec2 disp_r = vec2(0, alb_size);
	vec2 disp_g = vec2(alb_size, -alb_size);
	vec2 disp_b = vec2(-alb_size, -alb_size);
	
	float col_r = texture(SCREEN_TEXTURE, SCREEN_UV + disp_r).r;
	float col_b = texture(SCREEN_TEXTURE, SCREEN_UV + disp_b).b;
	float col_g = texture(SCREEN_TEXTURE, SCREEN_UV + disp_g).g;
	
	vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV) + vec4(col_r, col_g, col_b, alb_alpha);
	
	COLOR = col;
	
	
	
	}