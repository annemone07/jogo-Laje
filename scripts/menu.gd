extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayServer.window_set_size(DisplayServer.screen_get_size())
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_opcoes_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/opcoes.tscn")


func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/creditos.tscn")
