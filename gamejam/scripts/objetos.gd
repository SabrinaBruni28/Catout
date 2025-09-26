extends RigidBody2D

@export var throw_force: float = 1000.0
@export var altura: float = 500.0
@export var throw_direction: Vector2 = Vector2(1, -1)  # padrão, pode editar no Inspector

var held_by: Node = null
var is_held: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# começa parado
	add_to_group("item")

func _physics_process(delta: float) -> void:
	if is_held and held_by:
		# Segue o jogador sem colisão
		global_position = held_by.global_position + Vector2(held_by.scale.x, held_by.scale.y * -18)
		linear_velocity = Vector2.ZERO
		angular_velocity = 0

func pick_up(player: Node) -> void:
	is_held = true
	held_by = player
	collision_shape.disabled = true
	set_collision_layer_value(1, false)  # tira de layer
	set_collision_mask_value(1, false)   # não colide com nada

func throw_item() -> void:
	is_held = false
	held_by = null
	collision_shape.disabled = false
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	linear_velocity = throw_direction.normalized() * throw_force
