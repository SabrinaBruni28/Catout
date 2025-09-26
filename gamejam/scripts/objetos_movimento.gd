extends CharacterBody2D

@export var speed: float = 500.0
@export var knockback_force: float = 1000.0  # força para empurrar o jogador
var active: bool = false

@onready var camera: Camera2D = $"../../Camera2D"
@onready var parte_frente: AnimatedSprite2D = $ParteFrente
@onready var parte_tras: AnimatedSprite2D = $ParteTras

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Verifica se entrou na câmera
	if not active and camera:
		var viewport_rect = Rect2(
			camera.global_position - camera.get_viewport_rect().size * 0.5 * camera.zoom,
			camera.get_viewport_rect().size * camera.zoom
		)
		if viewport_rect.has_point(global_position):
			active = true
	
	if active:
		# Movimento da direita pra esquerda
		velocity.x = -speed
		parte_frente.play("idle")
		parte_tras.play("idle")
		
		# Move e verifica colisão
		var collision = move_and_collide(velocity * delta)
		if collision:
			var body = collision.get_collider()
			# Se colidiu com jogador, chama knockback
			if body.is_in_group("player") and body.has_method("knockback"):
				# Passa a força e direção do knockback
				body.knockback()
	else:
		parte_frente.pause()
		parte_tras.pause()
		velocity.x = 0
		move_and_slide()
