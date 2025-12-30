extends Node2D

@onready var jogador_1: CharacterBody2D = $Jogador_1
@onready var jogador_2: CharacterBody2D = $Jogador_2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audios.music.stop()
	jogador_1.set_personagem(Global.get_gato_anim(1, "corrida"))
	jogador_2.set_personagem(Global.get_gato_anim(2, "corrida"))
