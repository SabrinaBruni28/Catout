extends CharacterBody2D

# --- CONSTANTES DE MOVIMENTO ---
const SPEED = 400.0
const JUMP_VELOCITY = -500.0
const DELIZE_VELOCITY = 500.0
const VELOCITY_MAX = 700.0
const KNOCKBACK_SPEED = 1000.0

# --- VARIÁVEIS DE ESTADO ---
var direction = 0
var morreu: bool = false
var ispulando: bool = false
var isdeslizando: bool = false
var held_item = null

# --- CONFIGURAÇÕES EXPORTADAS ---
@export var input_prefix: String = "p1_"   # prefixo do jogador
@export var spawn_point: Vector2 = Vector2(0,0)

# --- NODES INTERNOS ---
@onready var player: AnimatedSprite2D = $Jogador
@onready var deslize_timer: Timer = $Timers/DeslizeTimer
@onready var jump_timer: Timer = $Timers/JumpTimer
@onready var collision_normal: CollisionShape2D = $CollisionNormal
@onready var collision_deslize: CollisionShape2D = $CollisionDeslize

# --- CONTROLE DE ANIMAÇÃO ---
var current_animation: String = ""

func _ready() -> void:
	# Coloca o jogador na Layer 1
	self.collision_layer = 2
	# Define que ele só colide com a Layer 2 (ex: chão, obstáculos)
	self.collision_mask = 1

	collision_normal.disabled = false
	collision_deslize.disabled = true
	add_to_group("player")  # adiciona a um grupo para colisões e itens

# --- PROCESSO PRINCIPAL DE FÍSICA ---
func _physics_process(delta: float) -> void:
	# DIREÇÃO HORIZONTAL
	directions(delta)
	# PULO
	jump(delta)
	# DESLIZE
	deslizar()
	# MOVIMENTAÇÃO FINAL
	move_and_slide()
	# ITENS
	jogar_item()
	
	# Atualiza animações de acordo com estado atual
	if isdeslizando:
		set_animation("deslize")
	elif not is_on_floor():
		set_animation("jump")
	elif direction != 0:
		set_animation("run")
	else:
		set_animation("idle")

# --- PULO ---
func jump(delta: float) -> void:
	# Aplica gravidade se não estiver no chão
	if not is_on_floor():
		velocity += get_gravity() * delta
		return
	
	# Impede pulo enquanto deslizando
	if isdeslizando:
		return
	
	# Pulo acionado pelo jogador
	if Input.is_action_just_pressed(input_prefix + "pular") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		ispulando = true
		set_animation("jump")
		jump_timer.start()

# --- DESLIZE ---
func deslizar():
	if ispulando or isdeslizando:
		return
	if Input.is_action_just_pressed(input_prefix + "deslize"):
		isdeslizando = true
		velocity.y = DELIZE_VELOCITY
		set_animation("deslize")
		deslize_timer.start()
		
		# troca a colisão para a menor
		collision_normal.disabled = true
		collision_deslize.disabled = false

# --- DIREÇÃO HORIZONTAL ---
func directions(delta: float) -> void:
	if isdeslizando:
		return
	# Recebe input do jogador (-1 a 1)
	direction = Input.get_axis(input_prefix + "esquerda", input_prefix + "direita")
	
	# Ajusta flip do sprite
	if direction > 0:
		player.flip_h = false
	elif direction < 0:
		player.flip_h = true
	
	# Movimento horizontal limitado por VELOCITY_MAX
	if direction != 0:
		velocity.x += direction * SPEED * delta * 2
		velocity.x = clamp(velocity.x, -VELOCITY_MAX, VELOCITY_MAX)
	else:
		# Se não estiver deslizando, desacelera
		if not isdeslizando:
			velocity.x = 0

# --- Pegar item ---
func pegar_item(area: Area2D):
	var parent = area.get_parent()
	if not parent.is_held and not parent.lancado:
		held_item = parent
		held_item.pick_up(self)

# --- Jogar item ---
func jogar_item():
	if Input.is_action_just_pressed(input_prefix + "jogar") and held_item:
		held_item.throw_item()
		held_item = null
		
func knockback():
	var direcao_knockback = -1
	velocity.x = direcao_knockback * KNOCKBACK_SPEED
	velocity.y = -200

func knockfront():
	var direcao_knockback = 1
	velocity.x += direcao_knockback * KNOCKBACK_SPEED
	velocity.y = -200

# --- FUNÇÃO PARA MORRER ---
func morre():
	if morreu:
		return
	morreu = true
	set_animation("die")
	queue_free()

# --- FUNÇÃO DE ANIMAÇÃO ---
func set_animation(anim: String) -> void:
	if current_animation == anim:
		return
	current_animation = anim
	player.play(anim)

# --- CALLBACK DO TIMER DE DESLIZE ---
func _on_deslize_timer_timeout() -> void:
	isdeslizando = false
	# volta para a colisão normal
	collision_normal.disabled = false
	collision_deslize.disabled = true

# --- CALLBACK DO TIMER DE PULO ---
func _on_jump_timer_timeout() -> void:
	ispulando = false

# --- DETECTA COLISÃO COM ITENS ---
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("item") and not held_item:
		pegar_item(area)
