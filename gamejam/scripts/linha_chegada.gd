extends Area2D

func _ready() -> void:
	# Conecta o sinal usando um Callable
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print(body.name + " chegou!")
		get_tree().change_scene_to_file("res://scenes/Screens/pass_screen.tscn")
