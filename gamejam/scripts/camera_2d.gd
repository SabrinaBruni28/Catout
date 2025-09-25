extends Camera2D

@onready var jogador_1: CharacterBody2D = $"../Jogador_1"
@onready var jogador_2: CharacterBody2D = $"../Jogador_2"

@export var smooth_speed: float = 5.0

func _process(delta: float) -> void:
	if not jogador_1 or not jogador_2:
		return

	# escolhe o jogador mais à frente (maior x)
	var target: Node2D = jogador_1 if jogador_1.global_position.x > jogador_2.global_position.x else jogador_2

	# move a câmera suavemente até ele
	global_position = global_position.lerp(target.global_position, smooth_speed * delta)
