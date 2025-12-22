extends Control

@onready var hover_sound: AudioStreamPlayer2D = $Audios/HoverSound
@onready var click_sound: AudioStreamPlayer2D = $Audios/ClickSound

func _on_button_1_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().change_scene_to_file(Global.fase_corrida)

func _on_button_2_pressed() -> void:
	click_sound.play()
	await click_sound.finished
	get_tree().quit()

func _on_button_1_mouse_entered() -> void:
	hover_sound.play()

func _on_button_2_mouse_entered() -> void:
	hover_sound.play()

func _on_gato_marrom_jogador_1_pressed() -> void:
	click_sound.play()
	Global.decide_gato1(Global.gato_marrom())

func _on_gato_preto_jogador_1_pressed() -> void:
	click_sound.play()
	Global.decide_gato1(Global.gato_preto())

func _on_gato_marrom_jogador_2_pressed() -> void:
	click_sound.play()
	Global.decide_gato2(Global.gato_marrom())

func _on_gato_preto_jogador_2_pressed() -> void:
	click_sound.play()
	Global.decide_gato2(Global.gato_preto())

func _on_gato_marrom_jogador_1_mouse_entered() -> void:
	hover_sound.play()

func _on_gato_preto_jogador_1_mouse_entered() -> void:
	hover_sound.play()

func _on_gato_marrom_jogador_2_mouse_entered() -> void:
	hover_sound.play()

func _on_gato_preto_jogador_2_mouse_entered() -> void:
	hover_sound.play()
