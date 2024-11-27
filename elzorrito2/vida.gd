extends Area2D

@onready var sonido = $"../Coin10"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	sonido.play()
	Estado.vida += 20
	queue_free()
