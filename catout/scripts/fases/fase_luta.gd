extends Node2D

@onready var jogador_1: CharacterBody2D = $Jogador1
@onready var jogador_2: CharacterBody2D = $Jogador2

@onready var label_pontos_jogador_1: Label = $Labels/LabelPontosJogador1
@onready var label_pontos_jogador_2: Label = $Labels/LabelPontosJogador2

@onready var tempo_jogo: Timer = $TempoJogo
@onready var label_tempo: Label = $Labels/LabelTempo

var morte_subita: bool = false
var pontos_jogador1: int = 0
var pontos_jogador2: int = 0

# no script principal
func _ready() -> void:
	# Conecta sinais (Godot 4)
	jogador_1.connect("morreu", Callable(self, "_on_jogador_1_morreu"))
	jogador_2.connect("morreu", Callable(self, "_on_jogador_2_morreu"))
	tempo_jogo.start()
	
func _process(delta: float) -> void:
	if not morte_subita:
		label_tempo.text = "Tempo: " + str(int(tempo_jogo.time_left)) + " s"# mostra só a parte inteira em segundos

func _on_jogador_1_morreu():
	jogador1_tomar_dano(1)

func _on_jogador_2_morreu():
	jogador2_tomar_dano(1)

func jogador1_tomar_dano(dano: int) -> void:
	pontos_jogador2 += dano
	label_pontos_jogador_2.text = str(pontos_jogador2)
	if morte_subita:
		acaba_jogo()

func jogador2_tomar_dano(dano: int) -> void:
	pontos_jogador1 += dano
	label_pontos_jogador_1.text = str(pontos_jogador1)
	if morte_subita:
		acaba_jogo()

func _on_tempo_jogo_timeout() -> void:
	if pontos_jogador1 != pontos_jogador2:
		acaba_jogo()
	else:
		label_tempo.text = "Morte Súbita"
		label_tempo.uppercase = true
		morte_subita = true
		label_tempo.start_piscar_rapido()

func acaba_jogo():
	Global.pontos[0] = pontos_jogador1
	Global.pontos[1] = pontos_jogador2
	get_tree().change_scene_to_file(Global.tela_final)
