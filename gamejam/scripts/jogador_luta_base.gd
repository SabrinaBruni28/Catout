extends CharacterBody2D

const SPEED = 500.0
const DASH_SPEED = 3000.0
const KNOCKBACK_SPEED = 5000.0

@export var input_prefix: String = "p1_"   # cada jogador muda isso no Inspector
@export var spawn_point: Vector2 = Vector2(0, 0)

@onready var dash_timer: Timer = $Timers/DashTimer
@onready var morte_timer: Timer = $Timers/MorteTimer
@onready var defesa_timer: Timer = $Timers/DefesaTimer
@onready var contra_defesa_timer: Timer = $Timers/ContraDefesaTimer

@onready var acao_timers: Array[Timer] = [
	$Timers/AcaoTimerDash,
	$Timers/AcaoTimerDefesa,
	$Timers/AcaoTimerContraDefesa
]

@onready var player: AnimatedSprite2D = $Jogador

@onready var tap_sound: AudioStreamPlayer2D = $Audios/TapSound
@onready var hurt_sound: AudioStreamPlayer2D = $Audios/HurtSound
@onready var knockback_sound: AudioStreamPlayer2D = $Audios/KnockbackSound

signal morreu

var direction: float
var flags: Array[bool] = [true, true, true]
var dash_direction: int = 0

var isdefesa: bool = false
var isdashing: bool = false
var ismorrendo: bool = false
var iscontradefesa: bool = false

func _ready() -> void:
	for i in range(acao_timers.size()):
		acao_timers[i].connect("timeout", Callable(self, "resetar_acao").bind(i))

func _physics_process(delta: float) -> void:
	if ismorrendo:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	diretions()
	dash()
	defesa()
	contradefesa()
	move_and_slide()

# Métodos comuns ---------------------------
func diretions():
	if isdashing or iscontradefesa: return
	if isdefesa: 
		velocity.x = 0
		return
	else: 
		direction = Input.get_axis(input_prefix + "esquerda", input_prefix + "direita")
	if direction > 0: player.flip_h = false
	elif direction < 0: player.flip_h = true
	if direction != 0:
		player.play("run")
	else:
		player.play("idle")
		
	velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)

func dash():
	if isdefesa or iscontradefesa or not flags[0]: return
	if isdashing:
		velocity.x = dash_direction * DASH_SPEED
		return
	if Input.is_action_just_pressed(input_prefix + "dash") and not isdashing:
		isdashing = true
		player.play("dash")
		iniciar_acao(0)
		dash_timer.start()
		dash_direction = direction if direction != 0 else (-1 if player.flip_h else 1)
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0

func defesa():
	if isdefesa or isdashing or iscontradefesa or not flags[1]: return
	if Input.is_action_just_pressed(input_prefix + "defesa"):
		defesa_timer.start()
		isdefesa = true
		player.play("defesa")
		iniciar_acao(1)
		
func contradefesa():
	if isdefesa or isdashing or not flags[2]: return
	if iscontradefesa:
		velocity.x = dash_direction * DASH_SPEED
		return
	if Input.is_action_just_pressed(input_prefix + "contradefesa") and not iscontradefesa:
		iscontradefesa = true
		player.play("contradefesa")
		iniciar_acao(2)
		contra_defesa_timer.start()
		dash_direction = direction if direction != 0 else (-1 if player.flip_h else 1)
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0

func morrer():
	if ismorrendo: return
	ismorrendo = true
	hurt_sound.play()
	player.play("die")
	emit_signal("morreu")
	morte_timer.start()
	await player.animation_finished
	hide()
	$CollisionShape2D.disabled = true
	
func knockback():
	knockback_sound.play()
	var direcao_knockback = -1 * dash_direction
	isdashing = false
	iscontradefesa = false
	velocity.x = direcao_knockback * KNOCKBACK_SPEED
	velocity.y = -200

func iniciar_acao(indice: int) -> void:
	flags[indice] = false
	acao_timers[indice].start()

func resetar_acao(indice: int) -> void:
	flags[indice] = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	
	# Colisão durante dash
	if isdashing:
		if parent.isdashing:
			knockback()
			parent.knockback()
		elif parent.isdefesa:
			knockback()
		else:
			parent.morrer()
	
	# Colisão durante contradefesa
	elif iscontradefesa:
		if parent.iscontradefesa:
			# 🔑 desliga colisão com jogadores
			set_collision_mask_value(1, false)  # layer 1 (players)
		else:
			parent.morrer()

func _on_dash_timer_timeout() -> void:
	isdashing = false
	velocity.x = 0
	player.play("idle")

func _on_morte_timer_timeout() -> void:
	global_position = spawn_point
	show()
	$CollisionShape2D.disabled = false
	ismorrendo = false
	player.play("idle")

func _on_defesa_timer_timeout() -> void:
	isdefesa = false
	player.play("idle")

func _on_contra_defesa_timer_timeout() -> void:
	iscontradefesa = false
	velocity.x = 0
	# 🔑 reativa colisão com jogadores
	set_collision_mask_value(1, true)
	player.play("idle")
