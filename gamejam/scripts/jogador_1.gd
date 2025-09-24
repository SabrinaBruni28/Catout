extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 2000.0
@onready var dash_timer: Timer = $DashTimer
@onready var morte_timer: Timer = $MorteTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var isdashing: bool = false
var ismorrendo: bool = false
var dash_direction: int = 0
var direction

func _physics_process(delta: float) -> void:
	if ismorrendo:
		return
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
		dash_timer.start()
		
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

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()  # sobe um nível, já que o Area2D é filho do player
	if not isdashing and  parent.isdashing:
		morrer()

func _on_dash_timer_timeout() -> void:
	isdashing = false

func _on_morte_timer_timeout() -> void:
	# volta pra posição inicial
	global_position = Vector2(380, 94)  # ou guarda uma variável spawn_point
	show()
	$CollisionShape2D.disabled = false
	ismorrendo = false
	animated_sprite.play("idle")
	
func morrer():
	ismorrendo = true
	morte_timer.start()
	animated_sprite.play("die")
	await animated_sprite.animation_finished
	
	# esconde o personagem
	hide()
	# desativa colisão pra não interagir morto
	$CollisionShape2D.disabled = true
