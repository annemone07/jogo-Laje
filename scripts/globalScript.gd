extends Node

var playerDirection=1
var playerPos
var salaAtual
var salaAnterior
var hpPlayer
var manaPlayer
var master_bus = AudioServer.get_bus_index("Master")
var musica_bus = AudioServer.get_bus_index("Musica")
var valor_slider_master:float=1.0
var valor_slider_musica:float=1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
