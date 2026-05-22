

extends CharacterBody2D

@onready var boss: CharacterBody2D = $"."
@onready var player: Jogador = %player
@onready var hitbox: Area2D = $hitbox
@onready var boss_1_placeholder: Sprite2D = $Boss1Placeholder
@onready var launch_atk_timer: Timer = $launchAtkTimer
@onready var can_jump_timer: Timer = $canJumpTimer
@onready var timer_knockback: Timer = $timerKnockback

var takeKnockback=false
var hp = 10
const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction=1
var contador_i_frames=0
var canJump=false

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
			boss_1_placeholder.flip_h = true
		elif player.global_position.x - global_position.x>0:
			direction = 1
			boss_1_placeholder.flip_h = false
	else:
		direction = 0

	
	if !player.hasAttacked:
		contador_i_frames=0
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction:# and not takeKnockback: #decidir se vai implementar knockback no boss
		if launch_atk_timer.is_stopped():
			launch_atk_timer.start()
		if player.hasAttacked and hitbox.overlaps_area(player.get_node("areaAtk")) and contador_i_frames==0:
			hp-=1
			#knockback
			#timer_knockback.start()
			#var knockbackDirection = Vector2(-direction,0)
			#velocity = knockbackDirection.normalized() * 900 #lança o player na velocidade do knockback
			#velocity.y -= 300
			contador_i_frames=1
			print(hp)
			takeKnockback=true
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_launch_atk_timer_timeout() -> void:
	print("bala")
	var bala = preload("res://scenes/boss_shot.tscn").instantiate()
	bala.global_position = global_position
	#var balaCarregada = bala.instantiate()
	boss.add_sibling(bala)


func _on_timer_knockback_timeout() -> void:
	takeKnockback=false
