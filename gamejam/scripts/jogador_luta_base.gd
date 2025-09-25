extends CharacterBody2D
class_name PlayerBase   # assim pode ser herdado facilmente

const SPEED = 400.0
const DASH_SPEED = 2400.0

@export var input_prefix: String = "p1_"   # cada jogador muda isso no Inspector
@export var spawn_point: Vector2 = Vector2(0, 0)

@onready var dash_timer: Timer = $Timers/DashTimer
@onready var morte_timer: Timer = $Timers/MorteTimer
@onready var defesa_timer: Timer = $Timers/DefesaTimer

@onready var acao_timers: Array[Timer] = [
	$Timers/AcaoTimer1,
	$Timers/AcaoTimer2,
	$Timers/AcaoTimer3
]

@onready var player: AnimatedSprite2D = $Jogador
@onready var escudo: AnimatedSprite2D = $Escudo

signal morreu

var direction: float
var isdashing: bool = false
var ismorrendo: bool = false
var isdefesa: bool = false
var dash_direction: int = 0
var flags: Array[bool] = [true, true, true]

func _ready() -> void:
	escudo.hide()
	for i in range(acao_timers.size()):
		acao_timers[i].connect("timeout", Callable(self, "resetar_acao").bind(i))

func _physics_process(delta: float) -> void:
	if ismorrendo:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	diretions()
	defesa()
	dash()
	move_and_slide()

# Métodos comuns ---------------------------
func diretions():
	if isdashing or isdefesa:
		return
	direction = Input.get_axis(input_prefix + "esquerda", input_prefix + "direita")
	if direction > 0: player.flip_h = false
	elif direction < 0: player.flip_h = true
	velocity.x = direction * SPEED if direction else move_toward(velocity.x, 0, SPEED)

func dash():
	if isdefesa or not flags[0]: return
	if isdashing:
		velocity.x = dash_direction * DASH_SPEED
		return
	if Input.is_action_just_pressed(input_prefix + "dash") and not isdashing:
		isdashing = true
		flags[0] = false
		dash_timer.start()
		acao_timers[0].start()
		dash_direction = direction if direction != 0 else (-1 if player.flip_h else 1)
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0

func defesa():
	if isdefesa or isdashing or not flags[1]: return
	if Input.is_action_just_pressed(input_prefix + "defesa"):
		escudo.show()
		escudo.play("escudo")
		defesa_timer.start()
		isdefesa = true
		flags[1] = false
		acao_timers[1].start()

func morrer():
	if ismorrendo: return
	ismorrendo = true
	morte_timer.start()
	player.play("die")
	emit_signal("morreu")
	await player.animation_finished
	hide()
	$CollisionShape2D.disabled = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if not isdashing and parent.isdashing and not isdefesa:
		morrer()
	elif isdefesa:
		var direcao_knockback = -1 * parent.dash_direction
		parent.isdashing = false
		parent.velocity.x = direcao_knockback * DASH_SPEED
		parent.velocity.y = -200

func _on_dash_timer_timeout() -> void:
	isdashing = false
	velocity.x = 0

func _on_morte_timer_timeout() -> void:
	global_position = spawn_point
	show()
	$CollisionShape2D.disabled = false
	ismorrendo = false
	player.play("idle")

func _on_defesa_timer_timeout() -> void:
	isdefesa = false
	escudo.hide()

func resetar_acao(indice: int) -> void:
	flags[indice] = true
