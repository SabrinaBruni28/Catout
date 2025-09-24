extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 1500.0
@onready var timer: Timer = $Timer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var isdashing: bool = false
var dash_direction: int = 0
var direction

func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pulo
	if Input.is_action_just_pressed("pular1") and is_on_floor() and not isdashing:
		velocity.y = JUMP_VELOCITY

	# Input horizontal (apenas se não estiver dando dash)
	if not isdashing:
		direction = Input.get_axis("esquerda1", "direita1")
		
		# Flip sprite
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true

		# Movimento normal
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Dash
	if Input.is_action_just_pressed("dash1") and not isdashing:
		isdashing = true
		timer.start()
		
		# Direção do dash (se estiver parado, usa o flip_h)
		if direction != 0:
			dash_direction = direction
		else:
			dash_direction = -1 if animated_sprite.flip_h else 1
		
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0  # opcional: corta a gravidade no dash

	# Se está dashing, mantém velocidade constante
	if isdashing:
		velocity.x = dash_direction * DASH_SPEED

	move_and_slide()

func _on_timer_timeout() -> void:
	isdashing = false
