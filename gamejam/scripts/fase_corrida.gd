extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@onready var jogador_1: CharacterBody2D = $Jogador_1
@onready var jogador_2: CharacterBody2D = $Jogador_2

# no script principal
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	for player in [jogador_1, jogador_2]:
		if not is_player_visible(player):
			player.morreu()

func is_player_visible(player: Node2D) -> bool:
	if not player or not camera_2d:
		return false

	var viewport_rect = Rect2(
		camera_2d.global_position - camera_2d.get_viewport_rect().size * 0.5 * camera_2d.zoom,
		camera_2d.get_viewport_rect().size * camera_2d.zoom
	)
	return viewport_rect.has_point(player.global_position)
