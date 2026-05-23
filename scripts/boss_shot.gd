extends RigidBody2D

@onready var boss_shot: RigidBody2D = $"."
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var player: Jogador = %player

var dir
var launchSpeed=300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#linear_velocity = Vector2(randi_range(100,500),randi_range(100,500))
	dir = [-1,1].pick_random()
	apply_impulse(Vector2((dir * launchSpeed),-300))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if boss_shot.sleeping or ray_cast_2d.is_colliding():
		await(get_tree().create_timer(0.5).timeout)
		queue_free()

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if body is Jogador:
		body.hp_atual-=1
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area == player.area_atk:
		queue_free()
