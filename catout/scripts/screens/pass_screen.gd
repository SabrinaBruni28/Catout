extends Control

@onready var hover_sound: AudioStreamPlayer2D = $Audios/HoverSound
@onready var click_sound: AudioStreamPlayer2D = $Audios/ClickSound
@onready var title: Label = $MarginContainer/HBoxContainer/VBoxContainer/Title

func _ready() -> void:
	title.text = "Gatinho " + str(Global.player_win)+ " Venceu"

func _on_button_1_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file(Global.fase_luta)

func _on_button_2_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file(Global.tela_inicial)

func _on_button_3_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file(Global.fase_corrida)
	
func _on_button_1_mouse_entered() -> void:
	hover_sound.play()

func _on_button_2_mouse_entered() -> void:
	hover_sound.play()

func _on_button_3_mouse_entered() -> void:
	hover_sound.play()
