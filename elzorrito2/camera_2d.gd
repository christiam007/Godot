extends Camera2D
@onready var vida : Label = $bida
@onready var monedas : Label = $monedas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vida.text = str(Estado.vida)
	monedas.text = str(Estado.monedas)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	vida.text = str(Estado.vida)
	monedas.text = "Monedas: " +  str(Estado.monedas)
