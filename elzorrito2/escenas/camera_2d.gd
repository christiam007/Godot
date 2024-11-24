extends Camera2D
@onready var vida : Label = $bida

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vida.text = str(Estado.vida)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	vida.text = str(Estado.vida)
