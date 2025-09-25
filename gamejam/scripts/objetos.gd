extends RigidBody2D

const SPEED = 400.0

@export var direction: int = 1  # cada jogador muda isso no Inspector
@export var spawn_point: Vector2 = Vector2(0, 0)

@onready var tap_sound: AudioStreamPlayer2D = $Audios/TapSound
@onready var hurt_sound: AudioStreamPlayer2D = $Audios/HurtSound
@onready var knockback_sound: AudioStreamPlayer2D = $Audios/KnockbackSound

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
