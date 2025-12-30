extends Node

@onready var hover_sound: AudioStreamPlayer2D = $HoverSound
@onready var click_sound: AudioStreamPlayer2D = $ClickSound
@onready var music: AudioStreamPlayer2D = $Music

func _on_music_finished() -> void:
	music.play()
