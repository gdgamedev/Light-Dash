extends Node

#função para calcular um número aleatório
func _rand(n_min, n_max, is_float):
	if is_float:
		randomize()
		return rand_range(n_min, n_max)
	else:
		randomize()
		return stepify(rand_range(n_min, n_max), 1)