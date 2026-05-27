extends CharacterBody2D

var hp = 5
var speed = 150
var on_range: bool = false
var current_state = state.IDLE
enum state {IDLE,HUNT,STUN,DEAD, ATK}
@onready var player: Jogador = %player
@onready var enemy_hitbox: Area2D = $Enemy_hitbox
@onready var enemy_sprite: Sprite2D = $Enemy_sprite
@onready var anim: AnimationPlayer = $anim
@onready var enemy_chaser: CharacterBody2D = $"."

var contador_i_frames=1

func _ready() -> void:
	enemy_chaser.add_to_group("enemies")

func _physics_process(delta) -> void:
	#print(current_state)
	if hp <= 0:
		#enemy_hitbox.queue_free()
		current_state = state.DEAD
#isso fica procurando "como" o inimigo tá
	match current_state:
		state.IDLE:
			velocity.x = 0
		state.HUNT:
			$anim.play("run")
			hunting()
		state.DEAD:
			$anim.play("morrer")
			await $anim.animation_finished 
			queue_free()
		state.ATK:
			$anim.play("atk")
		state.STUN:
			$anim.play("idle")
			if enemy_sprite.flip_h:
				velocity.x = -speed*2
			else:
				velocity.x = speed*2
				
				

	if player.hasAttacked and enemy_hitbox.overlaps_area(player.get_node("areaAtk")) and contador_i_frames==0:
		player.mana_atual+=1
		player.mana_atual = clamp(player.mana_atual,0,5)
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
		enemy_sprite.flip_h = true
	else:
		velocity.x = -speed
		enemy_sprite.flip_h = false
	
#parando
func _on_enemy_range_body_exited(body: Node2D) -> void:
	if body == player:
		$anim.stop()
		$anim.play("idle")
		on_range = false
		current_state = state.IDLE
		velocity.x = 0


func _on_enemy_hitbox_body_entered(body: CharacterBody2D) -> void:
	if body is Jogador:
		current_state = state.ATK
		velocity.x = 0
	await $anim.animation_finished
	current_state = state.HUNT
