extends Control

func _on_jogar_novamente_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fase_luta.tscn")

func _on_sair_button_pressed() -> void:
	get_tree().quit()
