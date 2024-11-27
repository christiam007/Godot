extends Node2D
@onready var musicote = $YourLoveIsMyDrug

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	musicote.play(Estado.cancion)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
