extends Node2D

@onready var musica2 = $"space-game-loop"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	musica2.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "personaje":
		print("entro en el portal..")
		get_tree().change_scene_to_file("res://escenas/negro.tscn")