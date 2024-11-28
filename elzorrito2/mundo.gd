extends Node2D
@onready var musica = $"01_-floral-life"
@onready var char = $personaje
@onready var portal = $Area2D2/Portal
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	musica.play()
	portal.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "personaje":
		Estado.vida -= 30
		
		char.position = Vector2(0.0, 0.0)


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "personaje":
		print("entro en el portal..")
		get_tree().change_scene_to_file("res://escenas/mundo_3.tscn")
