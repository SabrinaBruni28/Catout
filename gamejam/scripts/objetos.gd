extends RigidBody2D

const THROW_FORCE = 1000.0
const ALTURA = 500.0

@export var direction = 1
@export var spawn_point: Vector2 = Vector2(0, 0)

var held_by: Node = null   # guarda quem está segurando
var is_held: bool = false

@onready var tap_sound: AudioStreamPlayer2D = $Audios/TapSound
@onready var hurt_sound: AudioStreamPlayer2D = $Audios/HurtSound
@onready var knockback_sound: AudioStreamPlayer2D = $Audios/KnockbackSound

func _ready() -> void:
	# começa parado
	add_to_group("item")
	linear_velocity = Vector2.ZERO
	angular_velocity = 0

func _physics_process(delta: float) -> void:
	if is_held and held_by:
		# segue o jogador sem causar colisão
		global_position = held_by.global_position + Vector2(30 * held_by.scale.x, -20)
		linear_velocity = Vector2.ZERO
		angular_velocity = 0

# chamado pelo jogador quando pega
func pick_up(player: Node) -> void:
	is_held = true
	held_by = player
	freeze = true   # congela o rigidbody
	$CollisionShape2D.disabled = true  # desativa colisão enquanto está segurando

# chamado pelo jogador quando joga
func throw_item() -> void:
	is_held = false
	held_by = null
	freeze = false
	$CollisionShape2D.disabled = false  # ativa colisão de novo
	linear_velocity = Vector2(direction * THROW_FORCE, -ALTURA)
