extends CharacterBody2D

var hp = 5
var speed = 200
var on_range: bool = false
var current_state = state.IDLE
enum state {IDLE, HUNT, STUN, DEAD}

@onready var player: Jogador = %player
@onready var enemy_hitbox: Area2D = $Enemy_hitbox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var enemy_fly: CharacterBody2D = $"."

func _ready() -> void:
	enemy_fly.add_to_group("enemies")

var contador_i_frames = 1

func _physics_process(_delta: float) -> void:
	if hp <= 0:
		current_state = state.DEAD
		
	match current_state:
		state.IDLE:
			velocity = Vector2.ZERO 
		state.HUNT:
			animation_player.play("run")
			hunting()
		state.DEAD:
			animation_player.play("morrer")
			await animation_player.animation_finished 
			queue_free()
		state.STUN:
			animation_player.play("idle")
			if sprite_2d.flip_h:
				velocity.x = -speed 
			else:
				velocity.x = speed 
		
	if player.hasAttacked and enemy_hitbox.overlaps_area(player.get_node("areaAtk")) and contador_i_frames==0:
		player.mana_atual+=1
		hp-=1
		contador_i_frames = 1
		#knockback
		current_state = state.STUN
		velocity.y = -330
		if sprite_2d.flip_h == false:
			velocity.x = -speed*1.1
		if sprite_2d.flip_h == true:
			velocity.x = speed*1.1
			
		await get_tree().create_timer(0.1).timeout
		if on_range == true:
			current_state = state.HUNT
		if on_range == false:
			current_state = state.IDLE
	if !player.hasAttacked:
		contador_i_frames=0
	
	move_and_slide()

func _on_enemy_range_body_entered(body: Node2D) -> void:
	if body == player:
		on_range = true
		current_state = state.HUNT

	else:
		on_range = false
		current_state = state.IDLE
#correndo

func hunting():
	var direcao = global_position.direction_to(player.global_position)
	velocity = direcao * speed
	if player.global_position.x > global_position.x:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false



func _on_enemy_range_body_exited(body: Node2D) -> void:
	if body == player:
		await get_tree().create_timer(1.5).timeout
		animation_player.play("idle")
		current_state = state.IDLE
