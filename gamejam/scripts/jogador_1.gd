extends CharacterBody2D

const SPEED = 400.0
const DASH_SPEED = 2400.0

@onready var dash_timer: Timer = $Timers/DashTimer
@onready var morte_timer: Timer = $Timers/MorteTimer
@onready var defesa_timer: Timer = $Timers/DefesaTimer

#######################   A (dash)     B (defesa)    C (contraataque)
var flags: Array[bool] = [true, true, true]
@onready var acao_timers: Array[Timer] = [
	$Timers/AcaoTimer1,
	$Timers/AcaoTimer2,
	$Timers/AcaoTimer3
]

@onready var player: AnimatedSprite2D = $Jogador
@onready var escudo: AnimatedSprite2D = $Escudo

signal morreu

var direction
var isdashing: bool = false
var ismorrendo: bool = false
var isdefesa: bool = false
var dash_direction: int = 0

func  _ready() -> void:
	escudo.hide()
	for i in range(acao_timers.size()):
		acao_timers[i].connect("timeout", Callable(self, "resetar_acao").bind(i))

func _physics_process(delta: float) -> void:
	if ismorrendo:
		return
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	diretions()
	defesa()
	dash()
	move_and_slide()

func diretions():
	if isdashing or isdefesa:
		return

	direction = Input.get_axis("esquerda1", "direita1")
		
	# Flip sprite
	if direction > 0:
		player.flip_h = false
	elif direction < 0:
		player.flip_h = true

	# Movimento normal
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func dash():
	if isdefesa or not flags[0]:
		return
	# Se está dashing, mantém velocidade constante
	if isdashing:
		velocity.x = dash_direction * DASH_SPEED
		return

	# Dash
	if Input.is_action_just_pressed("dash1") and not isdashing:
		isdashing = true
		flags[0] = false
		dash_timer.start()
		acao_timers[0].start()
		
		# Direção do dash (se estiver parado, usa o flip_h)
		if direction != 0:
			dash_direction = direction
		else:
			dash_direction = -1 if player.flip_h else 1
		
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0  # opcional: corta a gravidade no dash

func defesa():
	if isdefesa or isdashing or not flags[1]:
		return
	# Defesa
	if Input.is_action_just_pressed("defesa1"):
		escudo.show()
		escudo.play("escudo")
		defesa_timer.start()
		isdefesa = true
		flags[1] = false
		acao_timers[1].start()

func morrer():
	if ismorrendo:
		return
	ismorrendo = true
	morte_timer.start()
	player.play("die")
	emit_signal("morreu")  # dispara o sinal só uma vez
	await player.animation_finished
	
	hide()
	$CollisionShape2D.disabled = true
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()  # inimigo (quem bateu)

	# Se eu não estou defendendo e o inimigo deu dash → morro
	if not isdashing and parent.isdashing and not isdefesa:
		morrer()
	# Se estou defendendo → o inimigo leva knockback
	elif isdefesa and parent.isdashing:
		var direcao_knockback = -1 * parent.dash_direction

		# Aplica empurrão no inimigo
		parent.isdashing = false                     # corta o dash
		parent.velocity.x = direcao_knockback * DASH_SPEED  # força do empurrão
		parent.velocity.y = -200                     # opcional: faz pular um pouco

func _on_dash_timer_timeout() -> void:
	isdashing = false
	velocity.x = 0

func _on_morte_timer_timeout() -> void:
	# volta pra posição inicial
	global_position = Vector2(600, 94)  # ou guarda uma variável spawn_point
	show()
	$CollisionShape2D.disabled = false
	ismorrendo = false
	player.play("idle")

func _on_defesa_timer_timeout() -> void:
	isdefesa = false
	escudo.hide()

func resetar_acao(indice: int) -> void:
	flags[indice] = true
