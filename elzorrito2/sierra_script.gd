extends Node2D

@onready var personaje : AnimatedSprite2D = $"../personaje/sprites"  # Asegúrate de que este sea el nodo correcto
@onready var sierra : AnimatedSprite2D = $AnimatedSprite2D

# Función que se llama cuando el nodo entra en el árbol de la escena
func _ready() -> void:
	sierra.play("default")

# Llamado cada frame, pero no se usa en este caso
func _process(delta: float) -> void:
	pass

# Se llama cuando un cuerpo entra en el área
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entró un cuerpo.")
	
	# Verificar si el cuerpo que entró es el personaje
	if body.name == "personaje":
		# Reproducir la animación 'golpe' en el personaje
		Estado.daño = true
		
		# Verificar el estado y aplicar daño
		if Estado.formas[0] == "zorro":
			Estado.vida -= 20
		elif Estado.formas[1] == "sapo":
			Estado.vida -= 40
		elif Estado.formas[2] == "cactus":
			Estado.vida -= 10
	await get_tree().create_timer(1.0).timeout
	print("Entró un cuerpo2.")

# Se llama cuando un cuerpo sale del área
func _on_area_2d_body_exited(body: Node2D) -> void:
	pass  # Reemplaza esto con lo que necesites hacer al salir
