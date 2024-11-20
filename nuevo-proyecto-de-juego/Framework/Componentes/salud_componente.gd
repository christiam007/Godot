class_name SaludComponente extends Node
signal salud_actualizada(actual: int, maxima: int)
signal sin_salud()

@export var salud_maxima : int = 100
var salud_actual : int = 0
var tiene_salud : bool = true

func _ready():
	salud_actual = salud_maxima

func recibir_daño(cantidad: int):
	if !tiene_salud:
		return
		
	salud_actual = clamp(salud_actual - cantidad,0 ,salud_maxima)
	emit_signal("salud_actualizada", salud_actual, salud_maxima)
	
	if (salud_actual <= 0):
		tiene_salud = false
		emit_signal("sin_salud")
