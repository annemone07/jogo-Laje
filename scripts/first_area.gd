extends Node2D
@onready var camera_2d: Camera2D = $CanvasLayer/Camera2D
@onready var player: CharacterBody2D = $player
@onready var loading: AnimationPlayer = $CanvasLayer/loading
@onready var black_screen: Sprite2D = $CanvasLayer/BlackScreen
@onready var nivelAtual:Node
@onready var proximo:Resource
@onready var proximo_nivel
@onready var musica_fundo: AudioStreamPlayer2D = $CanvasLayer/musicaFundo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loading.play("loading2")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position.x = player.position.x
	camera_2d.position.y = player.position.y-100


func _on_player_morreu() -> void:
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
	#nivelAtual = get_tree().current_scene.get_child(-1)
	#get_tree().current_scene.remove_child(nivelAtual)
	#nivelAtual.call_deferred("free")
	#proximo = load("res://scenes/death_screen.tscn")
	#proximo_nivel = proximo.instantiate()
	#get_tree().current_scene.add_child(proximo_nivel)

#func _on_musica_fundo_finished() -> void:
	#musica_fundo.play() # Replace with function body.
