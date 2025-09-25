extends Control
@onready var click_sound: AudioStreamPlayer2D = $ClickSound
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound

func _on_button_1_pressed() -> void:
	click_sound.play()
	await  click_sound.finished
	get_tree().change_scene_to_file("res://scenes/FaseLuta/fase_luta.tscn")

func _on_button_2_pressed() -> void:
	click_sound.play()
	await  click_sound.finished
	get_tree().quit()

func _on_button_1_mouse_entered() -> void:
	hover_sound.play()

func _on_button_2_mouse_entered() -> void:
	hover_sound.play()
