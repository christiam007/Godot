extends CharacterBody2D

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
@export var velocidad: float = 45.0
@export var distancia_movimiento: float = 100.0  # Distancia que se moverá a cada lado
@export var SPEED: float = 300.0
@export var tiempo_espera: float = 1.0
@export var GRAVITY: float = 980.0  # Añadimos gravedad como variable exportada

var posicion_inicial: Vector2
var posicion_final: Vector2
var direccion: float = -1.0
var sin_salud: bool = false
var vida: int = 100
var no_hit: bool = false

func _ready() -> void:
	animacion.play("andar")
	# Guardamos la posición inicial
	posicion_inicial = position
	# Calculamos la posición final
	posicion_final = posicion_inicial + Vector2(distancia_movimiento, 0)
	$Timer.wait_time = tiempo_espera
	$Timer.start()

func _physics_process(delta: float) -> void:
	
	if vida <= 0:
		animacion.play("muerte")
		await get_tree().create_timer(1.0).timeout
		queue_free()

	
	# Aplicar gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Movimiento horizontal
	velocity.x = velocidad * direccion
	move_and_slide()
	
	# Comprobamos si llegamos a los límites
	if direccion < 0 and position.x <= posicion_inicial.x:
		position.x = posicion_inicial.x
		cambiar_direccion()
	elif direccion > 0 and position.x >= posicion_final.x:
		position.x = posicion_final.x
		cambiar_direccion()

func cambiar_direccion() -> void:
	direccion *= -1
	animacion.flip_h = direccion > 0





func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "dañador" and !no_hit:
		vida -= 20
		print("Vida restante: ", vida)
		no_hit = true
		animacion.play("daño")
		await get_tree().create_timer(1.0).timeout
		animacion.play("andar")
		no_hit = false

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "dañador":
		no_hit = false

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "personaje":
		Estado.daño = true
		
		if Estado.forma_actual == "zorro":
			Estado.vida -= 20
		elif Estado.forma_actual == "cactus":
			Estado.vida -= 5
		
		await get_tree().create_timer(1.0).timeout

func _on_timer_timeout() -> void:
	cambiar_direccion()
