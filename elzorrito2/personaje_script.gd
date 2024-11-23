extends CharacterBody2D

@onready var camera: Camera2D = $Camera2D
@onready var sprites: AnimatedSprite2D = $sprites
var velocidad = 100.0
var velocidad_corriendo = 150.0

var impulso_salto = -350.0
var salto_interrumpido : bool = false
var corriendo : bool = false
var direccion
const GRAVITY = 1000.0  # Gravedad personalizada, ajusta según sea necesario.

# Control de la aceleración (esto reduce la inercia)
var aceleracion = 1200.0  # Ajusta este valor para controlar la inercia

var forma
var is_damaged = false  # Variable para verificar si el personaje ha recibido daño

func _ready() -> void:
	forma = Estado.forma_actual

func _physics_process(delta: float) -> void:
	if Estado.vida <= 0:
		sprites.play("muerte")
		return  # Detener el proceso si el personaje está muerto

	if Estado.daño == true and not is_damaged:
		is_damaged = true  # Marca que el personaje ha recibido daño
		await reproducir_animacion_daño()

	# Si el personaje ha recibido daño, eliminamos la inercia
	if is_damaged:
		# Detenemos cualquier movimiento horizontal inmediatamente
		velocity.x = 0
		# No aplicar más aceleración hasta que termine la animación de daño
		# Esto previene que el personaje siga moviéndose después del daño
		return

	# Agregar la gravedad si el personaje no está en el suelo
	if not is_on_floor():
		velocity.y += GRAVITY * delta  # Aplica la gravedad

		# Si el personaje no está en el suelo y no está saltando, significa que está cayendo.
		if not salto_interrumpido:
			if not sprites.is_playing() or sprites.animation != "caida":
				sprites.play("caida")  # Activa la animación de caída si no está saltando

	detectar_input()

	# Solo cambia flip_h si la dirección cambia.
	if direccion != 0:
		# Si la dirección es positiva y flip_h es falso, o si es negativa y flip_h es verdadero, cambia flip_h.
		if (direccion > 0 and sprites.flip_h == true):
			sprites.flip_h = false
		elif (direccion < 0 and sprites.flip_h == false):
			sprites.flip_h = true

		# Mueve al personaje (la aceleración hace que se mueva más rápido)
		if corriendo:
			velocity.x = move_toward(velocity.x, direccion * velocidad_corriendo, aceleracion * delta)
			if not sprites.is_playing() or sprites.animation != "correr":
				sprites.play("correr")
		else:
			velocity.x = move_toward(velocity.x, direccion * velocidad, aceleracion * delta)
			if not sprites.is_playing() or sprites.animation != "andar":
				sprites.play("andar")
	else:
		# Si no hay dirección, desacelera al personaje a 0
		velocity.x = move_toward(velocity.x, 0, aceleracion * delta)
		if direccion == 0 and not sprites.is_playing() or sprites.animation != "idle":
			sprites.play("idle")

	# Verificar si está en el suelo para elegir la animación correcta
	if is_on_floor():
		if sprites.animation == "brincar":
			sprites.play("idle")
		elif direccion:
			if corriendo:
				sprites.play("correr")
			else:
				sprites.play("caminar")
		else:
			sprites.play("idle")
	else:
		if velocity.y < 0:
			sprites.play("brincar")
		else:
			sprites.play("caida")

	move_and_slide()  # El parámetro Vector2.UP indica hacia arriba

# Función para detectar la entrada del jugador (movimiento y salto)
func detectar_input():
	# Manejar el salto.
	if Input.is_action_just_pressed("brincar") and is_on_floor():
		velocity.y = impulso_salto
		salto_interrumpido = false
	
	elif Input.is_action_just_released("brincar"):
		# Si el salto es interrumpido, solo dejamos de saltar y permitimos que entre en caída
		salto_interrumpido = true
	
	# Obtener la dirección de movimiento
	direccion = Input.get_axis("mover_izquierda", "mover_derecha")

	# Manejar la acción de correr
	if Input.is_action_just_pressed("correr"):
		corriendo = true
		if not sprites.is_playing() or sprites.animation != "correr":
			sprites.play("correr")
	elif Input.is_action_just_released("correr"):
		corriendo = false
		if not sprites.is_playing() or sprites.animation != "idle":
			sprites.play("idle")

# Función para reproducir la animación de daño y esperar 1 segundo
func reproducir_animacion_daño() -> void:
	# Reproducir la animación de daño
	sprites.play("daño")
	# Esperar un segundo y luego regresar a la animación normal
	await get_tree().create_timer(1.0).timeout  # Esto hace que el código espere 1 segundo
	Estado.daño = false
	is_damaged = false  # Marcar que el daño ha terminado, permitiendo que el personaje se mueva de nuevo
