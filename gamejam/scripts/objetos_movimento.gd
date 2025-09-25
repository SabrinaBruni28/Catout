extends CharacterBody2D

@export var speed: float = 500.0
var active: bool = false
@onready var camera: Camera2D = $"../../Camera2D"
@onready var parte_frente: AnimatedSprite2D = $ParteFrente
@onready var parte_tras: AnimatedSprite2D = $ParteTras

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if active:
		var viewport_rect = Rect2(
			camera.global_position - camera.get_viewport_rect().size * 0.5 * camera.zoom,
			camera.get_viewport_rect().size * camera.zoom
		)
		if not viewport_rect.has_point(global_position):
			queue_free()

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
	else:
		parte_frente.pause()
		parte_tras.pause()
		velocity.x = 0

	move_and_slide()
