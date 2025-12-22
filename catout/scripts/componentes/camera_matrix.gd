extends Camera2D

@onready var matriz_timer: Timer = $MatrizTimer
@onready var efeito_matriz: Area2D = $EfeitoMatriz
@onready var jogador_1: CharacterBody2D = $"../Jogador_1"
@onready var jogador_2: CharacterBody2D = $"../Jogador_2"
@onready var camera_principal: Camera2D = $"../CameraPrincipal"

# Distância do deslocamento em cada novo rastro
@export var deslocamento: Vector2 = Vector2(45, 0)

func _process(delta: float) -> void:
	# Faz essa câmera seguir a outra
	if camera_principal:
		global_position = camera_principal.global_position

func _on_matriz_timer_timeout() -> void:
	var clone := efeito_matriz.duplicate() as Area2D
	clone.position += deslocamento * get_child_count()
	
	# reconectar sinal no clone
	clone.connect("area_entered", Callable(self, "_on_efeito_matriz_area_entered"))
	
	add_child(clone)

func _on_efeito_matriz_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("player"):
		parent.morre()
		dead(parent)

func dead(dead_player):
	# Se o jogador 1 não morreu, ele venceu
	if jogador_1 != dead_player:
		Global.player_win = 1
	else:
		Global.player_win = 2
	get_tree().change_scene_to_file(Global.tela_pass)
