extends CharacterBody2D
class_name Player

@onready var camera: Camera2D = $Camera2D
@onready var sprites: AnimatedSprite2D = $sprites
@onready var sprites2: AnimatedSprite2D = $sprites2
@onready var menu: Control = $popup
@onready var dañador: Area2D = $"dañador"
@onready var monedaLabel := $CanvasLayer/HBoxContainer/MonedasLabel
@onready var espinas: Sprite2D = $Espinas

var velocidad = 100.0
var velocidad_corriendo = 150.0
var impulso_salto = -350.0
var salto_interrumpido : bool = false
var corriendo : bool = false
var direccion
const GRAVITY = 1000.0

var aceleracion = 1200.0
var menu_visible = false 
var forma
var is_damaged = false
var is_dying = false  # Nueva variable para controlar el estado de muerte

func _ready() -> void:
	espinas.visible = false
	Global.player = self
	menu.visible = false
	dañador.collision_layer = 0
	
func _physics_process(delta: float) -> void:
	if is_dying:  # Si está muriendo, no procesar más lógica
		return
		
	forma = Estado.forma_actual
	if forma == "cactus":
		espinas.visible=true
		sprites = $sprites2
		sprites2 = $sprites
		sprites2.visible = false
		impulso_salto = -250.0
		velocidad = 50.0
		velocidad_corriendo = 80.0
		dañador.collision_layer = 1
		
	elif forma == "zorro":
		espinas.visible=false
		sprites = $sprites
		sprites2 = $sprites2
		sprites2.visible = false
		impulso_salto = -350.0
		velocidad = 100.0
		velocidad_corriendo = 150.0
		dañador.collision_layer = 0
	
	if Input.is_action_pressed("menu"):
		if not menu_visible:
			menu_visible = true
			menu.visible = true
	else:
		if menu_visible:
			menu_visible = false
			menu.visible = false
	
	if Estado.vida <= 0 and not is_dying:
		morir()
		return

	if Estado.daño == true and not is_damaged:
		is_damaged = true
		await reproducir_animacion_daño()

	if is_damaged:
		velocity.x = 0
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

		if not salto_interrumpido:
			if not sprites.is_playing() or sprites.animation != "caida":
				sprites.play("caida")

	detectar_input()

	if direccion != 0:
		if (direccion > 0 and sprites.flip_h == true):
			sprites.flip_h = false
		elif (direccion < 0 and sprites.flip_h == false):
			sprites.flip_h = true

		if corriendo:
			velocity.x = move_toward(velocity.x, direccion * velocidad_corriendo, aceleracion * delta)
			if not sprites.is_playing() or sprites.animation != "correr":
				sprites.play("correr")
		else:
			velocity.x = move_toward(velocity.x, direccion * velocidad, aceleracion * delta)
			if not sprites.is_playing() or sprites.animation != "andar":
				sprites.play("andar")
	else:
		velocity.x = move_toward(velocity.x, 0, aceleracion * delta)
		if direccion == 0 and not sprites.is_playing() or sprites.animation != "idle":
			sprites.play("idle")

	if is_on_floor():
		if sprites.animation == "brincar":
			sprites.play("idle")
		elif direccion:
			if corriendo:
				sprites.play("correr")
			else:
				sprites.play("andar")
		else:
			sprites.play("idle")
	else:
		if velocity.y < 0:
			sprites.play("brincar")
		else:
			sprites.play("caida")

	move_and_slide()

# Nueva función para manejar la muerte del personaje
func morir() -> void:
	is_dying = true
	velocity = Vector2.ZERO  # Detener todo movimiento
	sprites.play("muerte")
	
	# Crear un timer para esperar antes de reiniciar
	var timer = get_tree().create_timer(1.0)
	timer.timeout.connect(func(): 
		if get_tree():
			Estado.vida = 100
			# Puedes cambiar esto a change_scene_to_file si prefieres ir a una escena de game over
			get_tree().reload_current_scene()
		else:
			print("Error: get_tree() es nulo")
	)

func detectar_input():
	if Input.is_action_just_pressed("brincar") and is_on_floor():
		velocity.y = impulso_salto
		salto_interrumpido = false
	
	elif Input.is_action_just_released("brincar"):
		salto_interrumpido = true
	
	direccion = Input.get_axis("mover_izquierda", "mover_derecha")

	if Input.is_action_just_pressed("correr"):
		corriendo = true
		if not sprites.is_playing() or sprites.animation != "correr":
			sprites.play("correr")
	elif Input.is_action_just_released("correr"):
		corriendo = false
		if not sprites.is_playing() or sprites.animation != "idle":
			sprites.play("idle")

func reproducir_animacion_daño() -> void:
	sprites.play("daño")
	if get_tree():
		await get_tree().create_timer(1.0).timeout
	Estado.daño = false
	is_damaged = false

func actualizar_sprites() -> void:
	if forma == "cactus":
		espinas.visible=false
		sprites2.visible = false
		sprites = $sprites2
		sprites2 = $sprites
		sprites2.visible = true
		impulso_salto = -250.0
		velocidad = 50.0
		velocidad_corriendo = 80.0
		dañador.collision_layer = 0
	elif forma == "zorro":		
		espinas.visible=true
		sprites2.visible = false
		sprites = $sprites
		sprites2 = $sprites2
		sprites2.visible = true
		impulso_salto = -350.0
		velocidad = 100.0
		velocidad_corriendo = 150.0
		dañador.collision_layer = 1

func _on_button_pressed() -> void:
	Estado.forma_actual = "cactus"
	actualizar_sprites()
	actualizar_sprites()

func _on_button_2_pressed() -> void:
	Estado.forma_actual = "zorro"
	actualizar_sprites()
	actualizar_sprites()
	

			
	
	
	
	


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
