extends Control

@onready var jogador_1: AnimatedSprite2D = $Jogador1
@onready var jogador_2: AnimatedSprite2D = $Jogador2
@onready var title: Label = $MarginContainer/HBoxContainer/VBoxContainer/Title

func _ready() -> void:
	set_personagem(Global.get_gato_anim(1, "corrida"), jogador_1)
	set_personagem(Global.get_gato_anim(2, "corrida"), jogador_2)
	title.text = "Gatinho " + str(Global.player_win)+ " Venceu"

func set_personagem(caminho_tres: String, player) -> void:
	var sprite_frames = load(caminho_tres) as SpriteFrames
	if sprite_frames:
		player.frames = sprite_frames
		player.play("idle")  # animação inicial
	else:
		push_error("Falha ao carregar o .tres: " + caminho_tres)

func _on_button_1_pressed() -> void:
	Audios.click_sound.play()
	await Audios.click_sound.finished
	get_tree().change_scene_to_file(Global.fase_luta)

func _on_button_2_pressed() -> void:
	Audios.click_sound.play()
	await Audios.click_sound.finished
	get_tree().change_scene_to_file(Global.tela_inicial)

func _on_button_3_pressed() -> void:
	Audios.click_sound.play()
	await Audios.click_sound.finished
	get_tree().change_scene_to_file(Global.fase_corrida)
	
func _on_button_1_mouse_entered() -> void:
	Audios.hover_sound.play()

func _on_button_2_mouse_entered() -> void:
	Audios.hover_sound.play()

func _on_button_3_mouse_entered() -> void:
	Audios.hover_sound.play()
