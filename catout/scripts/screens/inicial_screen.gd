extends Control

@onready var hover_sound: AudioStreamPlayer2D = $Audios/HoverSound
@onready var click_sound: AudioStreamPlayer2D = $Audios/ClickSound
@onready var music: AudioStreamPlayer2D = $Audios/Music

func _on_button_1_pressed() -> void:
	click_sound.play()
	music.stop()
	await  click_sound.finished
	get_tree().change_scene_to_file(Global.tela_opcoes)

func _on_button_2_pressed() -> void:
	click_sound.play()
	music.stop()
	await  click_sound.finished
	get_tree().quit()

func _on_button_1_mouse_entered() -> void:
	hover_sound.play()

func _on_button_2_mouse_entered() -> void:
	hover_sound.play()
