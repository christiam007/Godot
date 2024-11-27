extends Node2D

@onready var musica = $"07_BadGuys"
@onready var animacion = $Control/Portada
@onready var animacion2 = $Control/Portada2
@onready var efecto = $Coin10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	musica.play(Estado.cancion)
	animacion.visible = true
	animacion2.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	
	get_tree().change_scene_to_file("res://escenas/mundo.tscn")


func _on_button_2_pressed() -> void:
	Estado.cancion = musica.get_playback_position()
	get_tree().change_scene_to_file("res://escenas/opciones.tscn")


func _on_button_mouse_entered() -> void:
	efecto.play()


func _on_button_2_mouse_entered() -> void:
	efecto.play()


func _on_control_mouse_entered() -> void:
	animacion.visible = false
	animacion2.visible = true


func _on_control_mouse_exited() -> void:
	animacion.visible = true
	animacion2.visible = false
