class_name Enemy
extends CharacterBody2D

var hp = 10
var speed = 150
var current_state = state.IDLE
enum state {IDLE,HUNT,DEAD}
@onready var player: Jogador = %player
var contador_i_frames=1

func _physics_process(_delta) -> void:
	if hp <0:
		current_state = state.DEAD
#isso fica procurando "como" o inimigo tá
	match current_state:
		state.IDLE:
			velocity.x = 0
		state.HUNT:
			hunting()
		state.DEAD:
			queue_free()

	if player.hasAttacked and $Enemy_hitbox.overlaps_area(player.get_node("areaAtk")) and contador_i_frames==0:
		hp-=1
		#knockback
		if $Enemy_collision/Enemy_sprite.flip_h == false:
			velocity.x = -speed*20
			contador_i_frames=1
			print(hp)
		if $Enemy_collision/Enemy_sprite.flip_h == true:
			velocity.x = speed*20
			contador_i_frames=1
			print(hp)

	if !player.hasAttacked:
		contador_i_frames=0
	if not is_on_floor():
		velocity.y += 100
		
	move_and_slide()


#detecção

func _on_enemy_range_body_entered(body: Node2D)-> void:
	if body == player:
		current_state = state.HUNT

	else:
		current_state = state.IDLE
		velocity.x = 0
#correndo

func hunting():
	if player.global_position.x > global_position.x:
		velocity.x = speed
		$Enemy_collision/Enemy_sprite.flip_h = false
	else:
		velocity.x = -speed
		$Enemy_collision/Enemy_sprite.flip_h = true
		
#parando
func _on_enemy_range_body_exited(body: Node2D) -> void:
	if body == player:
		current_state = state.IDLE
		velocity.x = 0
	pass # Replace with function body.
