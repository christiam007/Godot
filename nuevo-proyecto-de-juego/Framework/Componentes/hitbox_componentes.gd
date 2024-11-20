class_name HitBox extends Area2D




func _on_area_entered(area: Area2D) -> void:
	if area is HealthBox:
		area.componente_salud.recibir_daño(50)
