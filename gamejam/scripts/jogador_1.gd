extends PlayerBase

func _ready() -> void:
	input_prefix = "p1_"        # muda só o prefixo
	spawn_point = Vector2(200, 94)
	super._ready()              # chama o ready do base
