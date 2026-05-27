

extends CharacterBody2D

@onready var boss: CharacterBody2D = $"."
@onready var player: Jogador = %player
@onready var hitbox: Area2D = $hitbox
@onready var launch_atk_timer: Timer = $launchAtkTimer
@onready var can_jump_timer: Timer = $canJumpTimer
@onready var timer_knockback: Timer = $timerKnockback
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var takeKnockback=false
var hp = 15
const SPEED = 100.0
const JUMP_VELOCITY = -400.0
var direction=1
var contador_i_frames=0
var canJump=false

func _ready() -> void:
	boss.add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if hp<=0:
		boss.visible=false
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://scenes/creditos.tscn")
		#queue_free()
	
	# Add the gravity.
	#print(hp)
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif can_jump_timer.is_stopped():
		can_jump_timer.start()
	
	if abs(player.global_position.x - global_position.x)<1000:
		if player.global_position.x - global_position.x<0:
			direction = -1
			animated_sprite_2d.flip_h = true
		elif player.global_position.x - global_position.x>0:
			direction = 1
			animated_sprite_2d.flip_h = false
	else:
		direction = 0

	
	if !player.hasAttacked:
		contador_i_frames=0
	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if direction and not takeKnockback: #decidir se vai implementar knockback no boss
		if player.hasAttacked and hitbox.overlaps_area(player.get_node("areaAtk")) and contador_i_frames==0:
			player.mana_atual+=1
			hp-=1
			#knockback
			timer_knockback.start()
			var knockbackDirection = Vector2(-direction*400,0)
			var forcaLancamentoBoss = 1000
			velocity = knockbackDirection.normalized() * forcaLancamentoBoss #lança o boss na velocidade do knockback
			velocity.y -= 300
			contador_i_frames=1
			print(hp)
			takeKnockback=true
		else:
			velocity.x = direction * SPEED
	else:
		animated_sprite_2d.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_launch_atk_timer_timeout() -> void:
	#print("bala")
	animated_sprite_2d.play("attack")
	var bala = preload("res://scenes/boss_shot.tscn").instantiate()
	var AlturaAteTopoBoss=160
	bala.global_position = global_position + Vector2(0,-AlturaAteTopoBoss)
	#var balaCarregada = bala.instantiate()
	boss.add_sibling(bala)
	await get_tree().create_timer(0.4).timeout
	if direction:
		animated_sprite_2d.play("andar")


func _on_timer_knockback_timeout() -> void:
	takeKnockback=false


func _on_can_jump_timer_timeout() -> void:
	var x = Vector2(0,-500)
	velocity = x.normalized() * 450 #pulo
	velocity.y -= 300
	move_and_slide()
