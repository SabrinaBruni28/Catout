extends Camera2D

@onready var jogador_1: CharacterBody2D = $"../Jogador_1"
@onready var jogador_2: CharacterBody2D = $"../Jogador_2"
@onready var objetos: Node = $"../Objetos"
@export var smooth_speed: float = 5.0

@export var vertical_offset: float = 200.0  # quanto acima do jogador a câmera ficará

func _process(delta: float) -> void:
	var target: Node2D = null

	# Verifica se os jogadores ainda existem
	if jogador_1 and jogador_2:
		target = jogador_1 if jogador_1.global_position.x > jogador_2.global_position.x else jogador_2
	elif jogador_1:
		target = jogador_1
	elif jogador_2:
		target = jogador_2
	else:
		return  # nenhum jogador ativo

	# Move a câmera suavemente até ele, com offset vertical
	var target_position = target.global_position - Vector2(0, vertical_offset)
	global_position = global_position.lerp(target_position, smooth_speed * delta)

	# Verifica se algum jogador saiu da tela
	for player in [jogador_1, jogador_2]:
		if player and not is_player_visible(player):
			player.morre()

# verifica se o jogador está visível na câmera
func is_player_visible(player: Node2D) -> bool:
	var viewport_size = get_viewport_rect().size/zoom
	var viewport_rect = Rect2(
		global_position - viewport_size * 0.5,
		viewport_size
	)
	
	# considera a posição central do jogador (ou o tamanho se quiser)
	return viewport_rect.has_point(player.global_position)
	
func is_object_visible(objeto: RigidBody2D) -> bool:
	return 0
	
