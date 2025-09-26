extends RigidBody2D

@export var throw_force: float = 1000.0
@export var altura: float = 500.0
@export var throw_direction: Vector2 = Vector2(1, -1)  # padrão, pode editar no Inspector
@export var velocidade: bool = false

var held_by: Node = null
var is_held: bool = false
var lancado: bool = false

@onready var camera: Camera2D = $"../../Camera2D"
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
		
	if lancado:
		var viewport_rect = Rect2(
			camera.global_position - camera.get_viewport_rect().size * 0.5 * camera.zoom,
			camera.get_viewport_rect().size * camera.zoom
		)
		if not viewport_rect.has_point(global_position):
			queue_free()

func pick_up(player: Node) -> void:
	if lancado or is_held:
		return
	if velocidade:
		collision_shape.disabled = true
		player.knockfront()
		queue_free()
		return
	
	is_held = true
	held_by = player
	collision_shape.disabled = true
	set_collision_layer_value(1, false)  # tira de layer
	set_collision_mask_value(1, false)   # não colide com nada

func throw_item() -> void:
	lancado = true
	is_held = false
	held_by = null
	collision_shape.disabled = false
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	linear_velocity = throw_direction.normalized() * throw_force
