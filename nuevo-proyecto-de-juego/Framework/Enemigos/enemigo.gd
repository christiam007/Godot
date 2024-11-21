extends CharacterBody2D

@onready var animacion : AnimatedSprite2D = get_node("Animacion")
@onready var maquina_estados: Node = $MaquinaEstados


@export var velocidad := 100
@export var tiempo_espera := 1.0


var direccion := 0.0
var sin_salud := false

func _ready() -> void:
	animacion.connect("animation_finished", detectar_animacion_finalizada)
	maquina_estados.establecer_estado("idle")
	direccion = -1.0
	$Timer.wait_time = tiempo_espera
	$Timer.start()


func _physics_process(delta: float) -> void:
	if sin_salud:
		return	
	
	if !$RayCastSuelo.is_colliding() and is_on_floor():
		cambiar_direccion()
	if $RayCastParedes.is_colliding() and is_on_floor():
		cambiar_direccion()
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		if direccion:
			velocity.x = move_toward(velocity.x, velocidad * direccion, 600)
		else:
			velocity.x = move_toward(velocity.x, 0, 500)
		
	

	move_and_slide()
	logica_maquina_estados()
	
	
func  cambiar_direccion():
	$Timer.stop()
	direccion *= -1
	
	if direccion > 0:
		animacion.flip_h = true
	else:
		animacion.flip_h = false
	$RayCastSuelo.position.x *= -1
	$RayCastParedes.position.x *= -1
	$RayCastParedes.target_position.x *= -1
	
	
	$Timer.wait_time = tiempo_espera
	$Timer.start()
	


func _on_timer_timeout() -> void:
	cambiar_direccion()
	
func logica_maquina_estados():
	if maquina_estados.estado_actual == null:
		return
	if is_on_floor():
		if maquina_estados.estado_actual.nombre == "brincar":
			maquina_estados.establecer_estado("idle")
		elif direccion:
			maquina_estados.establecer_estado("caminar")
		else:
			maquina_estados.establecer_estado("idle")			
	else:
		if velocity.y < 0:
			maquina_estados.establecer_estado("brincar")
		else:
			maquina_estados.establecer_estado("caer")	
	


func _on_maquina_estados_estado_actualizado(nuevo_estado: Estado, estado_anterior: Estado) -> void:
	match nuevo_estado.nombre:
		"idle":
			animacion.play("idle")
		"caminar":
			animacion.play("caminar")
		"brincar":
			animacion.play("salto")
		"caer":
			animacion.play("caida")


func _on_salud_componente_sin_salud() -> void:
	sin_salud = true
	$Timer.stop()
	$Componentes/HealthBoxComponentes.monitorable = false
	$Componentes/HealthBoxComponentes.monitorable = false
	$Componentes/HitboxComponentes.monitoring = false
	$Componentes/HitboxComponentes.monitoring = false
	animacion.play("golpe")
	
func detectar_animacion_finalizada():
	if animacion.animation == "golpe":
		queue_free()
	
