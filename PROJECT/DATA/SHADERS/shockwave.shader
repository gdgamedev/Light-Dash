shader_type canvas_item;

//disperção
uniform float disp = 1.0;
//blur
uniform float blur = 0.01;

void fragment() {
	//centro da imagem
	vec2 center = vec2(0.5, 0.5);
	//distância do pixel atual do centro em vetor
	vec2 dist_vec = center - SCREEN_UV;
	//cor do pixel atual
	vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV);
	//distância do pixel atual do centro em vetor normalizado
	vec2 d = normalize(dist_vec);
	
	//direção
	float dir = length(d);
	//porcentagem de dispersão baseado na cor vermelha da textura
	float disp_perc = texture(TEXTURE, UV).r;
	//coordenada distorcida
	vec2 coord = vec2(SCREEN_UV.x - (dir * disp_perc * disp), SCREEN_UV.y - (dir * disp_perc * disp));
	//pega a cor da coordenada distorcida
	col = textureLod(SCREEN_TEXTURE, coord, blur * disp_perc);
	
	//aplica a cor do pixel atual
	COLOR = col;
	}