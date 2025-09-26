extends Area2D

func _ready() -> void:
	# Conecta o sinal usando um Callable
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		# Define o vencedor como 1 ou 2, dependendo de qual jogador é
		if body.name == "Jogador_1":
			Global.player_win = 1
		elif body.name == "Jogador_2":
			Global.player_win = 2
		get_tree().change_scene_to_file("res://scenes/Screens/pass_screen.tscn")
