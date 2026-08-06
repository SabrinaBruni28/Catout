extends Area2D

var velocidade: float = 100.0
var aceleracao: float = 18.0

func _process(delta: float) -> void:
	velocidade += aceleracao * delta
	position.x += velocidade * delta
