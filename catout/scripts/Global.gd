extends Node

# Gatos escolhidos (guarda o PATH BASE)
var gatos_jogador := {
	1: "res://tres/gato_marrom/",
	2: "res://tres/gato_preto/"
}

var player_win := 0
var pontos := [0, 0]

# Telas
const tela_inicial = "res://scenes/screens/inicial_screen.tscn"
const tela_final = "res://scenes/screens/final_screen.tscn"
const tela_pass = "res://scenes/screens/pass_screen.tscn"
const tela_opcoes = "res://scenes/screens/opcoes_screen.tscn"
const tela_controles = "res://scenes/screens/controles_screen.tscn"

# Fases
const fase_luta = "res://scenes/fase_luta/fase_luta.tscn"
const fase_corrida = "res://scenes/fase_corrida/fase_corrida.tscn"

# Gatos disponíveis
var gatos := {
	"marrom": "res://tres/gato_marrom/",
	"preto":  "res://tres/gato_preto/",
}

func _ready():
	# valores padrão
	gatos_jogador[1] = gatos["marrom"]
	gatos_jogador[2] = gatos["preto"]

func get_gato_anim(jogador: int, fase: String) -> String:
	var base_path = gatos_jogador[jogador]

	match fase:
		"luta":
			return base_path + "gato_luta.tres"
		"corrida":
			return base_path + "gato_corrida.tres"
		_:
			push_error("Fase inválida: " + fase)
			return ""

func decide_gato(jogador: int, gato_path: String):
	gatos_jogador[jogador] = gato_path
