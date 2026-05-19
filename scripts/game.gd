extends Node2D
@onready var game: Node2D = $"."
@onready var nivelAtual:Node
@onready var proximo:Resource
@onready var proximo_nivel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_cutscene_inicial_finish() -> void:
	#troca cutscene inicial pra primeira área
	nivelAtual = game.get_node("cutscene_inicial")
	game.remove_child(nivelAtual)
	nivelAtual.call_deferred("free")
	proximo = load("res://scenes/first_area.tscn")
	proximo_nivel = proximo.instantiate()
	game.add_child(proximo_nivel)
