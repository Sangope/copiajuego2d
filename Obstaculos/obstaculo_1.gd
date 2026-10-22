extends StaticBody2D

var puntuado: bool = false

func _ready() -> void:
	add_to_group("obstaculos_puntos")

func _process(_delta: float) -> void:
	if position.y > 1000:
		queue_free()
