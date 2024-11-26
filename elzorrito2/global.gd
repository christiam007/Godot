extends Node


var moneda:= 0 : 
	set (val):
		moneda = val
		if player != null:
			player.actualizarInterfazMoneda()
	get:
		return moneda

var player
