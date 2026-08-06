extends Node2D

@onready var jogador_1: CharacterBody2D = $Jogador_1
@onready var jogador_2: CharacterBody2D = $Jogador_2
@onready var pause_screen: Control = $CameraPrincipal/PauseScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audios.music.stop()
	jogador_1.set_personagem(Global.get_gato_anim(1, "corrida"))
	jogador_2.set_personagem(Global.get_gato_anim(2, "corrida"))
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_screen.visible = true
		get_tree().paused = true

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
