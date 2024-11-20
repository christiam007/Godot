extends StaticBody2D

@export var tiempo_espera : int = 1
@export var inicio_aleatorio : bool = false



func _ready() -> void:
	if inicio_aleatorio:
		await get_tree().create_timer(randf_range(0,2)).timeout
	
	$AnimationPlayer.play("idle")
	$Delay.wait_time = tiempo_espera
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Delay.start()


func _on_delay_timeout() -> void:
	$AnimationPlayer.play("idle")
	
