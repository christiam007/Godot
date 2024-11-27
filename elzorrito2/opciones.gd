extends Node2D

var volumen : float = 10.0  
@onready var musica = $"07_BadGuys"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	musica.play(Estado.cancion)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volumen_value_changed(value: float) -> void:
	
	volumen = value / 100.0  
	AudioServer.set_bus_volume_db(0, linear_to_db(volumen))


func _on_button_pressed() -> void:
	Estado.cancion = musica.get_playback_position()
	get_tree().change_scene_to_file("res://escenas/Menu.tscn")
