extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DELIZE_VELOCITY = 500.0

var direction
var morreu: bool = false

@export var input_prefix: String = "p1_"   # cada jogador muda isso no Inspector
@export var spawn_point: Vector2 = Vector2(0, 0)

@onready var player: AnimatedSprite2D = $Jogador

func _physics_process(delta: float) -> void:
	directions()
	jump(delta)
	move_and_slide()

func jump(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed(input_prefix + "pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func directions():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis(input_prefix + "esquerda", input_prefix + "direita")
		
	if direction > 0: player.flip_h = false
	elif direction < 0: player.flip_h = true
	if direction != 0:
		player.play("run")
	else:
		player.play("idle")
	velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)
	
func morre():
	if morreu:
		return
	morreu = true
	player.play("die")
	queue_free()
