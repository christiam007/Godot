class_name HealthBox extends Area2D

@export var componente_salud : SaludComponente

if area is HealthBox:
	
	area.componente_salud.recibir_daño(50)
