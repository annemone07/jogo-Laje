extends CharacterBody2D

var hp = 10
var speed = 150
var on_range: bool = false
var current_state = state.IDLE
enum state {IDLE,HUNT,STUN,DEAD}
@onready var player: Jogador = %player
@onready var enemy_hitbox: Area2D = $Enemy_hitbox
@onready var enemy_sprite: Sprite2D = $Enemy_collision/Enemy_sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var contador_i_frames=1

func _physics_process(delta) -> void:
	#print(current_state)
	if hp <= 0:
		current_state = state.DEAD
#isso fica procurando "como" o inimigo tá
	match current_state:
		state.IDLE:
			velocity.x = 0
		state.HUNT:
			hunting()
		state.DEAD:
			animation_player.play("morrer")
			await animation_player.animation_finished 
			queue_free()
		state.STUN:
			if enemy_sprite.flip_h:
				velocity.x = speed*2
			else:
				velocity.x = -speed*2
				
				

	if player.hasAttacked and enemy_hitbox.overlaps_area(player.get_node("areaAtk")) and contador_i_frames==0:
		hp-=1
		contador_i_frames = 1
		#knockback
		current_state = state.STUN
		velocity.y = -330
		if enemy_sprite.flip_h == false:
			velocity.x = -speed*1.1
		if enemy_sprite.flip_h == true:
			velocity.x = speed*1.1
			
		await get_tree().create_timer(0.3).timeout
		if on_range == true:
			current_state = state.HUNT
		if on_range == false:
			current_state = state.IDLE
	if !player.hasAttacked:
		contador_i_frames=0

	velocity.y += 800*delta
		

	move_and_slide()


#detecção

func _on_enemy_range_body_entered(body: Node2D)-> void:
	if body == player:
		on_range = true
		current_state = state.HUNT

	else:
		on_range = false
		current_state = state.IDLE
#correndo

func hunting():
	if player.global_position.x > global_position.x:
		velocity.x = speed
		enemy_sprite.flip_h = false
	else:
		velocity.x = -speed
		enemy_sprite.flip_h = true
		
#parando
func _on_enemy_range_body_exited(body: Node2D) -> void:
	if body == player:
		on_range = false
		current_state = state.IDLE
		velocity.x = 0
