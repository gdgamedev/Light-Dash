extends Node

func rand_n(n_from, n_to, is_float):
	
	if is_float:
		randomize()
		return rand_range(n_from, n_to)
	else:
		randomize()
		return int( rand_range(n_from, n_to) )