extends Area2D
@onready var ranged_shot: Area2D = $"."
@onready var player: Jogador = %player
const SPEED = 500.0
const JUMP_VELOCITY = -400.0
var direcao = 1
var spawnPos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direcao = GlobalScript.playerDirection
	global_position = GlobalScript.playerPos
	pass#ranged_shot.linear_velocity = player.velocity + Vector2(20,20)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += direcao * global_transform.x * SPEED * delta
	if abs(global_position - GlobalScript.playerPos)>Vector2(1000,0):
		queue_free()


func _on_body_entered(body: CharacterBody2D) -> void:
	if body is Enemy:
		body.hp-=1
		print(body.hp)
		queue_free()
