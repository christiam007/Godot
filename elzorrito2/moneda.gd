extends Area2D
@onready var anim = $AnimatedSprite2D
@onready var sound = $"../Coin10"


func _ready() -> void:
	Estado.monedas = -1
	anim.play()
		


func _on_body_entered(body: Node2D) -> void:
	print("moneda")
	sound.play()
	queue_free()
	Estado.monedas += 1
