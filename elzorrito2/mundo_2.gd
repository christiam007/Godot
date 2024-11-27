extends Node2D

@onready var s1 = $"6"
@onready var s2 = $"7"
@onready var s3 = $cactus
@onready var s4 = $zorro
@onready var musicote = $YourLoveIsMyDrug
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	s1.play()
	s2.play()
	s3.play()
	s4.play()
	musicote.play(1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Estado.cancion = musicote.get_playback_position()
	await get_tree().create_timer(20.0).timeout
	get_tree().change_scene_to_file("res://escenas/fin.tscn")
