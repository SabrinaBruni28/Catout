extends Button
class_name CatButton

@onready var sprite: AnimatedSprite2D = $Sprite

var gato_path: String
var jogador: int

func set_personagem(player: int, caminho_tres: String, caminho_gato: String, group: ButtonGroup) -> void:
	gato_path = caminho_gato
	jogador = player
	button_group = group

	var sprite_frames = load(caminho_tres) as SpriteFrames
	if sprite_frames:
		sprite.frames = sprite_frames
		sprite.play("idle")
	else:
		push_error("Falha ao carregar o .tres: " + caminho_tres)

func _on_pressed():
	Audios.click_sound.play()
	Global.decide_gato(jogador, gato_path)

func _on_mouse_entered():
	Audios.hover_sound.play()
