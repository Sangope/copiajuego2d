extends Camera2D

@export var objeto_a_seguir: Node2D

func _process(_delta: float) -> void:
	if objeto_a_seguir != null:
		position.x = objeto_a_seguir.position.x
