extends Node2D
@onready var camera_2d: Camera2D = $CanvasLayer/Camera2D
@onready var player: CharacterBody2D = $player
@onready var loading: AnimationPlayer = $CanvasLayer/loading
@onready var black_screen: Sprite2D = $CanvasLayer/BlackScreen
@onready var nivelAtual:Node
@onready var proximo:Resource
@onready var proximo_nivel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loading.play("loading2")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position.x = player.position.x
	camera_2d.position.y = player.position.y-100


func _on_player_morreu() -> void:
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
