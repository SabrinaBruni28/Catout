extends Area2D
var win: bool = false

func _ready() -> void:
	# Conecta o sinal usando um Callable
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and not win:
		win = true
		# Define o vencedor como 1 ou 2, dependendo de qual jogador é
		if body.name == "Jogador_1":
			Global.player_win = 1
		elif body.name == "Jogador_2":
			Global.player_win = 2
		
		# Espera 2 segundos antes de trocar de cena
		await get_tree().create_timer(0.4).timeout
		get_tree().change_scene_to_file(Global.tela_pass)
