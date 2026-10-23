extends RigidBody2D

@export var velocidad_avance: float = 240.0
@export var fuerza_salto: float = -350.0
@export var tiempo_reinicio: float = 1.0

var puntos: int = 0
var esta_muerto: bool = false

func _ready() -> void:
	lock_rotation = true
	gravity_scale = 0.85
	contact_monitor = true
	max_contacts_reported = 4
	body_entered.connect(_on_body_entered)

func _input(event: InputEvent) -> void:
	if esta_muerto:
		return

	if event.is_action_pressed("ui_accept"):
		linear_velocity.y = fuerza_salto
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE:
		linear_velocity.y = fuerza_salto
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		linear_velocity.y = fuerza_salto

func _physics_process(_delta: float) -> void:
	if esta_muerto:
		return

	# Detección de colisión inmediata o caída fuera de pantalla
	if get_colliding_bodies().size() > 0 or global_position.y > 660 or global_position.y < -50:
		morir()
		return

	linear_velocity.x = velocidad_avance

	for obs in get_tree().get_nodes_in_group("obstaculos_puntos"):
		if not obs.puntuado and global_position.x > obs.global_position.x:
			obs.puntuado = true
			puntos += 1
			print("Puntos: ", puntos)

func _on_body_entered(_body: Node) -> void:
	morir()

func morir() -> void:
	if esta_muerto:
		return
	esta_muerto = true
	print("¡Has muerto! Reiniciando juego...")

	# Efecto visual: teñir el sprite de la paloma en rojo
	var sprite: Sprite2D = get_node_or_null("Paloma")
	if sprite:
		sprite.modulate = Color(1.0, 0.3, 0.3)

	# Físicas de impacto: detener avance horizontal y dejarlo caer rotando
	set_deferred("lock_rotation", false)
	set_deferred("angular_velocity", 8.0)
	set_deferred("linear_velocity", Vector2(0, -100))

	# Desactivar colisiones para evitar que se atranque al caer
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)

	# Esperar y reiniciar automáticamente la escena
	await get_tree().create_timer(tiempo_reinicio).timeout
	if is_inside_tree():
		get_tree().reload_current_scene()
