extends Node2D

@onready var jogador_1: CharacterBody2D = $Jogador_1
@onready var jogador_2: CharacterBody2D = $Jogador_2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jogador_1.set_personagem(Global.gato1_corrida())
	jogador_2.set_personagem(Global.gato2_corrida())
