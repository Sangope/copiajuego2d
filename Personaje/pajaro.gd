extends RigidBody2D

@export var velocidad_avance: float = 240.0
@export var fuerza_salto: float = -350.0

var puntos: int = 0

func _ready() -> void:
	lock_rotation = true
	gravity_scale = 0.85

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		linear_velocity.y = fuerza_salto
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		linear_velocity.y = fuerza_salto
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		linear_velocity.y = fuerza_salto

func _physics_process(_delta: float) -> void:
	linear_velocity.x = velocidad_avance

	for obs in get_tree().get_nodes_in_group("obstaculos_puntos"):
		if not obs.puntuado and global_position.x > obs.global_position.x:
			obs.puntuado = true
			puntos += 1
			print("Puntos: ", puntos)
