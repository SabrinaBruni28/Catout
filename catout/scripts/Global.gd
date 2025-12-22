extends Node

var gato1
var gato2
var player_win = 0
var pontos: Array = [0, 0]

# Telas do Jogo
const  tela_inicial = "res://scenes/screens/inicial_screen.tscn"
const tela_final = "res://scenes/screens/final_screen.tscn"
const tela_pass = "res://scenes/screens/pass_screen.tscn"
const tela_opcoes = "res://scenes/screens/opcoes_screen.tscn"

# Fases do jogo
const fase_luta = "res://scenes/fase_luta/fase_luta.tscn"
const fase_corrida = "res://scenes/fase_corrida/fase_corrida.tscn"


func _ready() -> void:
	gato1 = "res://tres/gato_marrom/"
	gato2 = "res://tres/gato_preto/"

# Escolha de gato
func gato_preto():
	return "res://tres/gato_preto/"
	
func gato_marrom():
	return "res://tres/gato_marrom/"

func gato1_luta():
	return gato1 + "gato_luta.tres"

func gato2_luta():
	return gato2 + "gato_luta.tres"
	
func gato1_corrida():
	return gato1 + "gato_corrida.tres"

func gato2_corrida():
	return gato2 + "gato_corrida.tres"
	
func decide_gato1(gato):
	gato1 = gato
	
func decide_gato2(gato):
	gato2 = gato
