extends CharacterBody2D

@onready var maquina_estados: Node = $Componentes/MaquinaEstados
@onready var sprites: AnimatedSprite2D = $Sprites



var velocidad = 200.0
var velocidad_corriendo = 150.0

var impulso_salto = -350.0
var salto_interrumpido : bool = false
var corriendo : bool = false
var direccion 

func _ready() -> void:
	maquina_estados.establecer_estado("idle") 

func detectar_input():
	# Handle jump.
	if Input.is_action_just_pressed("brincar") and is_on_floor():
		velocity.y = impulso_salto
		
	elif Input.is_action_just_released("brincar"):
		salto_interrumpido = true
		
	
	elif Input.is_action_just_pressed("brincar"):
		salto_interrumpido = false	
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direccion = Input.get_axis("mover_izquierda", "mover_derecha")
	
	
	
	if Input.is_action_just_pressed("correr"):
		corriendo = true
		
		
	elif Input.is_action_just_released("correr"):
		corriendo = false
		
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if salto_interrumpido and velocity.y < 0:
			velocity.y += 1000*delta
		velocity += get_gravity() * delta
		
	detectar_input()
	logica_maquina_estados()
	
	

	if direccion:
		if (direccion > 0 and sprites.flip_h == true):
			sprites.flip_h = false
		elif (direccion < 0 and sprites.flip_h == false):
			sprites.flip_h = true
		if corriendo:
			velocity.x = move_toward(velocity.x, direccion * velocidad_corriendo,250*delta)
		else:
			velocity.x = move_toward(velocity.x, direccion * velocidad,250*delta)
		
	else:
		
		velocity.x = move_toward(velocity.x, 0, 500*delta)

	move_and_slide()
	
func logica_maquina_estados():
	if maquina_estados.estado_actual == null:
		return
	if is_on_floor():
		if maquina_estados.estado_actual.nombre == "brincar":
			maquina_estados.establecer_estado("idle")
		elif direccion:
			if corriendo:
				maquina_estados.establecer_estado("correr")
			else:
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
			sprites.play("idle")
		"caminar":
			sprites.play("caminar")
		"correr":
			sprites.play("correr")
		"brincar":
			sprites.play("salto")
		"caer":
			sprites.play("caida")
			
		
