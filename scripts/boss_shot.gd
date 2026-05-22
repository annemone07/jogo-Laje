extends RigidBody2D

var dir
var launchSpeed=300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#linear_velocity = Vector2(randi_range(100,500),randi_range(100,500))
	dir = [-1,1].pick_random()
	apply_impulse(Vector2((dir * launchSpeed),500))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
