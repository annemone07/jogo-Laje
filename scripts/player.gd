extends CharacterBody2D

var canJump = true
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var coyote_timer: Timer = $coyoteTimer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer.start()
	else:
		canJump=true

	# Handle jump.
	if Input.is_action_just_pressed("jump") and canJump:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("mLeft", "mRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_coyote_timer_timeout() -> void:
	canJump = false
