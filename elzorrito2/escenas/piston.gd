extends StaticBody2D

@onready var colision : CollisionShape2D = $CollisionShape2D

var move_speed : float = 60  # Velocidad de movimiento en píxeles por segundo
var amplitude : float = 21.0  # Amplitud del movimiento
var direction : int = 1  # Dirección del movimiento: 1 para abajo, -1 para arriba

var start_position : Vector2

var start_delay : float = 0.0  # Tiempo de retraso antes de comenzar el movimiento
var elapsed_time : float = 0.0  # Tiempo transcurrido desde que empezó el movimiento

# Llamado cuando el nodo entra en la escena
func _ready() -> void:
	# Guarda la posición inicial de la colisión
	start_position = colision.position 
	
	# Asigna un valor aleatorio para el tiempo de inicio
	start_delay = randf_range(0.0, 2.0)  # Retraso aleatorio entre 0 y 2 segundos
	colision.position.y = start_position.y + randf_range(-amplitude, amplitude)  # Posición aleatoria inicial

# Llamado cada frame
func _process(delta: float) -> void:
	# Acumula el tiempo transcurrido
	elapsed_time += delta
	
	# Si ha pasado el tiempo de retraso, comienza el movimiento
	if elapsed_time >= start_delay:
		# Mueve la colisión hacia arriba y hacia abajo
		colision.position.y += direction * move_speed * delta
		
		# Rebotar en los límites de la amplitud
		if colision.position.y > start_position.y + amplitude:  # Límite inferior
			direction = -1  # Cambiar dirección hacia arriba
		elif colision.position.y < start_position.y - amplitude:  # Límite superior
			direction = 1  # Cambiar dirección hacia abajo
