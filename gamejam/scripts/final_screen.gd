extends Control
@onready var click_sound: AudioStreamPlayer2D = $Audios/ClickSound
@onready var hover_sound: AudioStreamPlayer2D = $Audios/HoverSound
@onready var title: Label = $MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var pontos_1: Label = $Pontos1
@onready var pontos_2: Label = $Pontos2

func _ready():
	pontos_1.text = str(Global.pontos[0])
	pontos_2.text = str(Global.pontos[1])
	if Global.pontos[0] > Global.pontos[1]:
		title.text = "Jogador 1 Venceu"
	elif Global.pontos[0] < Global.pontos[1]:
		title.text = "Jogador 2 Venceu"
	else:
		title.text = "Empate"

func _on_button_1_pressed() -> void:
	click_sound.play()
	await  click_sound.finished
	get_tree().change_scene_to_file("res://scenes/Screens/inicial_screen.tscn")

func _on_button_2_pressed() -> void:
	click_sound.play()
	await  click_sound.finished
	get_tree().quit()

func _on_button_1_mouse_entered() -> void:
	hover_sound.play()

func _on_button_2_mouse_entered() -> void:
	hover_sound.play()
