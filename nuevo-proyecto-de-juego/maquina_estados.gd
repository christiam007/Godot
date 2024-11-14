extends Node
signal estado_actualizado(nuevo_estado: Estado, estado_anterior: Estado)

@export var estados : Array[Estado]

var estado_actual : Estado
var estado_anterior : Estado

func mover_a_estado(nuevo_estado : Estado):
	estado_anterior = estado_actual
	estado_actual = nuevo_estado
	emit_signal("estado_actualizado", estado_actual, estado_anterior)
	
func establecer_estado(nuevo_estado : String) -> bool:
	if estados.size() <= 0:
		return false
		
		
	if estado_actual:	
		if nuevo_estado == estado_actual.nombre:
			return false
		
		
	for estado in estados:
		if estado.nombre == nuevo_estado:
			mover_a_estado(estado)
			return true
	return false
