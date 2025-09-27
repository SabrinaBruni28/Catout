extends Camera2D

@onready var matriz_timer: Timer = $MatrizTimer
@onready var efeito_matriz: Area2D = $EfeitoMatriz
@onready var camera_principal: Camera2D = $"../CameraPrincipal"

# Distância do deslocamento em cada novo rastro
@export var deslocamento: Vector2 = Vector2(45, 0)

func _process(delta: float) -> void:
	# Faz essa câmera seguir a outra
	if camera_principal:
		global_position = camera_principal.global_position

func _on_matriz_timer_timeout() -> void:
	# Clona o efeito matriz
	var clone := efeito_matriz.duplicate() as Area2D
	clone.position += deslocamento * get_child_count()
	
	# Adiciona como filho do mesmo nó da câmera
	add_child(clone)

func _on_efeito_matriz_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("player"):
		parent.morre()
		camera_principal.dead(parent)
