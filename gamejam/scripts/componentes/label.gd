extends Label

var tween: Tween

func start_piscar_rapido() -> void:
	if tween:
		tween.kill() # garante que não tem tween antigo
	tween = create_tween()
	tween.set_loops() # repete para sempre
	tween.tween_property(self, "modulate:a", 0.0, 0.2) # apaga em 0.2s
	tween.tween_property(self, "modulate:a", 1.0, 0.2) # acende em 0.2s

func stop_piscar() -> void:
	if tween:
		tween.kill()
	modulate.a = 1.0 # garante que o texto fica visível no final
