extends Camera2D

@onready var jogador_1: CharacterBody2D = $"../Jogador_1"
@onready var jogador_2: CharacterBody2D = $"../Jogador_2"

@export var smooth_speed: float = 5.0
@export var vertical_offset: float = 200.0
@export var peso_inferior: float = 0.7  # quanto "puxa" para o mais embaixo (0.5 = média normal, >0.5 puxa mais)

func _process(delta: float) -> void:
	if not jogador_1 and not jogador_2:
		return
	
	var target_x: float = global_position.x
	var target_y: float = global_position.y

	# --- Calcula o alvo no eixo X ---
	if jogador_1 and jogador_2:
		var leader := jogador_1 if jogador_1.global_position.x > jogador_2.global_position.x else jogador_2
		
		if leader.velocity.x > 0:
			target_x = leader.global_position.x
	elif jogador_1:
		if jogador_1.velocity.x > 0:
			target_x = jogador_1.global_position.x
	elif jogador_2:
		if jogador_2.velocity.x > 0:
			target_x = jogador_2.global_position.x

	# --- Calcula o alvo no eixo Y (puxa mais para quem está mais embaixo) ---
	var y_positions: Array[float] = []
	if jogador_1:
		y_positions.append(jogador_1.global_position.y)
	if jogador_2:
		y_positions.append(jogador_2.global_position.y)

	if y_positions.size() == 1:
		target_y = y_positions[0] - vertical_offset
	elif y_positions.size() == 2:
		var y1 = y_positions[0]
		var y2 = y_positions[1]
		var lower = max(y1, y2)  # mais embaixo
		var higher = min(y1, y2) # mais em cima
		# média ponderada: dá mais peso ao jogador embaixo
		target_y = (lower * peso_inferior + higher * (1.0 - peso_inferior)) - vertical_offset

	# --- Move suavemente a câmera ---
	var target_position = Vector2(target_x, target_y)
	global_position = global_position.lerp(target_position, smooth_speed * delta)
