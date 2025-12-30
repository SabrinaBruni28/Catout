extends Control

func _ready() -> void:
	Audios.music.play()

func _on_button_1_pressed() -> void:
	Audios.click_sound.play()
	await Audios.click_sound.finished
	get_tree().change_scene_to_file(Global.tela_opcoes)

func _on_button_2_pressed() -> void:
	Audios.click_sound.play()
	await Audios.click_sound.finished
	get_tree().change_scene_to_file(Global.tela_inicial)

func _on_button_1_mouse_entered() -> void:
	Audios.hover_sound.play()

func _on_button_2_mouse_entered() -> void:
	Audios.hover_sound.play()
