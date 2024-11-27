extends Area2D
@onready var anim = $vida
@onready var sonido = $"../Coin10"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	sonido.play()
	Estado.vida += 50
	queue_free()
