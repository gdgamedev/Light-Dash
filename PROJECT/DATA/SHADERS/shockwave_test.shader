shader_type canvas_item;

//disperção
uniform float disp = 1.0;
//saturação
uniform float sat = 0.01;
//textura
uniform sampler2D text : hint_albedo;

void fragment() {
	//centro da imagem
	vec2 center = vec2(0.5, 0.5);
	//distância do pixel atual do centro em vetor
	vec2 dist_vec = center - SCREEN_UV;
	//cor do pixel atual
	vec4 col = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	//distância do pixel atual do centro em vetor normalizado
	vec2 d = normalize(dist_vec);
	
	//direção
	float dir = length(d);
	//porcentagem de dispersão baseado na cor vermelha da textura
	float disp_perc = texture(TEXTURE, SCREEN_UV).r;
	//coordenada distorcida
	vec2 coord = vec2(SCREEN_UV.x + (dir * disp_perc * disp), SCREEN_UV.y + (dir * disp_perc * disp));
	//pega a cor da coordenada distorcida
	col = textureLod(SCREEN_TEXTURE, coord, 0.0);
	
	col.r += sat * disp_perc;
	col.g += sat * disp_perc;
	col.b += sat * disp_perc;
	
	//aplica a cor do pixel atual
	COLOR = col;
	}