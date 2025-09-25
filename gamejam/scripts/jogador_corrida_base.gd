extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DELIZE_VELOCITY = 500.0
const VELOCITY_MAX = 700.00

var direction
var morreu: bool = false
var ispulando: bool = false
var isdeslizando: bool = false

var item

@export var input_prefix: String = "p1_"   # cada jogador muda isso no Inspector
@export var spawn_point: Vector2 = Vector2(0, 0)

@onready var player: AnimatedSprite2D = $Jogador
@onready var deslize_timer: Timer = $Timers/DeslizeTimer

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	directions(delta)
	jump(delta)
	deslizar()
	move_and_slide()

func jump(delta: float) -> void:
	if isdeslizando:
		return
	# Handle jump.
	if Input.is_action_just_pressed(input_prefix + "pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		ispulando = true
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		ispulando = false

func deslizar():
	if ispulando or isdeslizando:
		return
	if Input.is_action_just_pressed(input_prefix + "deslize"):
		player.play("deslize")
		isdeslizando = true
		velocity.y = DELIZE_VELOCITY
		deslize_timer.start()
		
func jogar_item():
	item = null
		
func directions(delta):
	if isdeslizando:
		return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis(input_prefix + "esquerda", input_prefix + "direita")
		
	if direction > 0: player.flip_h = false
	elif direction < 0: player.flip_h = true
	if direction != 0:
		player.play("run")
	else:
		player.play("idle")
	if direction:
		if velocity.x < VELOCITY_MAX and velocity.x > -VELOCITY_MAX:
			velocity.x += direction * SPEED * delta * 2
	else: velocity.x = 0
	
func morre():
	if morreu:
		return
	morreu = true
	player.play("die")
	queue_free()

func _on_deslize_timer_timeout() -> void:
	isdeslizando = false
	player.play("idle")

func _on_area_2d_area_entered(area: Area2D) -> void:
	item = area
