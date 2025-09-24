extends Node2D

@onready var jogador_1: CharacterBody2D = $Jogador1
@onready var jogador_2: CharacterBody2D = $Jogador2

@onready var label_pontos_jogador_1: Label = $LabelPontosJogador1
@onready var label_pontos_jogador_2: Label = $LabelPontosJogador2

@onready var tempo_jogo: Timer = $TempoJogo
@onready var label_tempo: Label = $LabelTempo

var pontos_jogador1: int = 0
var pontos_jogador2: int = 0

# no script principal
func _ready() -> void:
	# Conecta sinais (Godot 4)
	jogador_1.connect("morreu", Callable(self, "_on_jogador_1_morreu"))
	jogador_2.connect("morreu", Callable(self, "_on_jogador_2_morreu"))
	tempo_jogo.start()
	
func _process(delta: float) -> void:
	label_tempo.text = "Tempo: " + str(int(tempo_jogo.time_left)) + " s"# mostra só a parte inteira em segundos

func _on_jogador_1_morreu():
	jogador1_tomar_dano(10)

func _on_jogador_2_morreu():
	jogador2_tomar_dano(10)

func jogador1_tomar_dano(dano: int) -> void:
	pontos_jogador2 += 1
	label_pontos_jogador_2.text = str(pontos_jogador2)

func jogador2_tomar_dano(dano: int) -> void:
	pontos_jogador1 += 1
	label_pontos_jogador_1.text = str(pontos_jogador1)

func _on_tempo_jogo_timeout() -> void:
	get_tree().reload_current_scene()
