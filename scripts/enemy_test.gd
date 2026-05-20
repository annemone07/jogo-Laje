class_name Enemy

extends CharacterBody2D

@onready var player: Jogador = %player
@onready var hitbox: Area2D = $hitbox

var hp = 10
const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction=1
var contador_i_frames=0

func _physics_process(delta: float) -> void:
	if hp<=0:
		queue_free()
	
	# Add the gravity.
	#print(hp)
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if abs(player.global_position.x - global_position.x)<500:
		if player.global_position.x - global_position.x<0:
			direction = -1
		elif player.global_position.x - global_position.x>0:
			direction = 1
	else:
		direction = 0
	
	if player.hasAttacked and (hitbox.overlaps_area(player.get_node("areaAtk"))) and contador_i_frames==0:
		hp-=1
		velocity.x = -direction * SPEED*20
		print(hp)
		contador_i_frames=1
	
	if !player.hasAttacked:
		contador_i_frames=0
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
