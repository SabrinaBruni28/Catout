extends Control

@export var cat_button_scene: PackedScene = preload("res://scenes/componentes/opcao_jogador.tscn")

@onready var grid1 := $Opcoes/HBoxContainer/OpcoesJogador1
@onready var grid2 := $Opcoes/HBoxContainer/OpcoesJogador2
var grupo_jogador1 := ButtonGroup.new()
var grupo_jogador2 := ButtonGroup.new()

func _ready():
	Audios.music.play()
	criar_botoes(grid1, 1, grupo_jogador1, false)
	criar_botoes(grid2, 2, grupo_jogador2, true)

func criar_botoes(grid: Control, jogador: int, group: ButtonGroup, flip := false):
	for gato_id in Global.gatos.keys():
		var btn := cat_button_scene.instantiate()

		var gato_path = Global.gatos[gato_id]
		var anim_path = gato_path + "gato_corrida.tres"

		grid.add_child(btn)
		btn.set_personagem(jogador, anim_path, gato_path, group)
		if flip:
			btn.sprite.flip_h = true

func _on_button_1_pressed() -> void:
	Audios.click_sound.play()
	await Audios.click_sound.finished
	get_tree().change_scene_to_file(Global.fase_corrida)

func _on_button_2_pressed() -> void:
	Audios.click_sound.play()
	await Audios.click_sound.finished
	get_tree().change_scene_to_file(Global.tela_inicial)

func _on_button_1_mouse_entered() -> void:
	Audios.hover_sound.play()

func _on_button_2_mouse_entered() -> void:
	Audios.hover_sound.play()
