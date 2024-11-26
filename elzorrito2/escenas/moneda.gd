extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.moneda+=1
		print(Global.moneda)
		$Pickup.play()  # Reproducir sonido
		$AnimationPlayer.play("Pickup")  # Reproducir animación
		await get_tree().create_timer(0.3).timeout  # Corregido el await
		queue_free()
			
			
		
