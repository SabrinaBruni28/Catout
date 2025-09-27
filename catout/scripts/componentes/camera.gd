extends Camera2D

@onready var jogador_1: CharacterBody2D = $"../Jogador_1"
@onready var jogador_2: CharacterBody2D = $"../Jogador_2"
@onready var objetos: Node = $"../Objetos"

@export var smooth_speed: float = 5.0
@export var vertical_offset: float = 200.0  # quanto acima do jogador a câmera ficará
@export var left_kill_margin: float = 0.0  # margem extra (pixels) para matar só depois de um pouco fora da tela

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

	# Move a câmera suavemente até o alvo, com offset vertical
	var target_position: Vector2 = target.global_position - Vector2(0, vertical_offset)
	global_position = global_position.lerp(target_position, smooth_speed * delta)

	# --- Checa se algum jogador saiu pela lateral esquerda ---
	var viewport_size: Vector2 = get_viewport_rect().size / zoom
	var viewport_rect: Rect2 = Rect2(global_position - viewport_size * 0.5, viewport_size)
	var left_bound: float = viewport_rect.position.x - left_kill_margin

	for player in [jogador_1, jogador_2]:
		if not player:
			continue

		# calcula a borda esquerda real do jogador
		var leftmost_x: float = player.global_position.x
		if player.has_node("CollisionShape2D"):
			var cs: CollisionShape2D = player.get_node("CollisionShape2D") as CollisionShape2D
			if cs.shape is RectangleShape2D:
				var rect: RectangleShape2D = cs.shape as RectangleShape2D
				var ext: Vector2 = rect.extents * player.global_scale
				leftmost_x = player.global_position.x - abs(ext.x)
			elif cs.shape is CircleShape2D:
				var circle: CircleShape2D = cs.shape as CircleShape2D
				leftmost_x = player.global_position.x - circle.radius * abs(player.global_scale.x)

		# Se passou do limite → morreu
		if leftmost_x < left_bound:
			if player.has_method("morre"):
				player.morre()
				dead(player)
		
func dead(dead_player):
	# Se o jogador 1 não morreu, ele venceu
	if jogador_1 != dead_player:
		Global.player_win = 1
	else:
		Global.player_win = 2
	# Muda para a tela final
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file(Global.tela_pass)
