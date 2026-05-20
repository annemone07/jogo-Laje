extends Area2D
@onready var ranged_shot: Area2D = $"."
@onready var player: Jogador = %player
const SPEED = 50.0
const JUMP_VELOCITY = -400.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass#ranged_shot.linear_velocity = player.velocity + Vector2(20,20)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direcao = player.direction
	position += direcao * transform.x * SPEED * delta
	if abs(transform.x)>Vector2(200,0):
		queue_free()
