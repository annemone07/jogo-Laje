extends CharacterBody2D

var hp = 10
var current_state = state.IDLE
enum state {IDLE,SHOOT,STUN,DEAD}
var mirando: bool = false
var contador_i_frames=1
const BULLET = preload("res://scenes/enemy_bullet.tscn")

@onready var colldown = $cooldown
@onready var player: Jogador = %player
@onready var enemy_hitbox: Area2D = $Enemy_hitbox
@onready var enemy_sprite: Sprite2D = $Enemy_collision/Enemy_sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_shooter: CharacterBody2D = $"."

func _ready() -> void:
	enemy_shooter.add_to_group("enemies")

func _physics_process(delta) -> void:
	#print(current_state)
	if hp <= 0:
		current_state = state.DEAD
#isso fica procurando "como" o inimigo tá
	match current_state:
		state.IDLE:
			velocity.x = 0
		state.SHOOT:
			
			shooting()
		state.DEAD:
			animation_player.play("morrer")
			await animation_player.animation_finished 
			queue_free()
		state.STUN:
			if enemy_sprite.flip_h:
				velocity.x = 300
			else:
				velocity.x = -300
				
				

	if player.hasAttacked and enemy_hitbox.overlaps_area(player.get_node("areaAtk")) and contador_i_frames==0:
		hp-=1
		contador_i_frames = 1
		#knockback
		current_state = state.STUN
		velocity.y = -330
		if enemy_sprite.flip_h == false:
			velocity.x = -300*2
		if enemy_sprite.flip_h == true:
			velocity.x = 300*2
		$cooldown.stop()
		$spread.stop()
		await get_tree().create_timer(0.5).timeout
		$cooldown.start()
	if !player.hasAttacked:
		contador_i_frames=0

	velocity.y += 800*delta
		

	move_and_slide()


#detecção
func _on_enemy_range_body_entered(body: Node2D) -> void:
	if body == player:
		mirando = true
		$cooldown.start()

func _on_cooldown_timeout() -> void:
	$cooldown.stop()
	current_state = state.SHOOT
	

func _on_spread_timeout() -> void:
	current_state = state.SHOOT

#pew pew pew 
func shooting():
	var new_shoot = BULLET.instantiate()
	var alvo = get_tree().current_scene.find_child("player", true, false)
	new_shoot.height = global_position.direction_to(alvo.global_position).y
	add_sibling(new_shoot)
	new_shoot.position = self.position
	if player.global_position.x > global_position.x:
		enemy_sprite.flip_h = false
		new_shoot.direction = 1
	else:
		enemy_sprite.flip_h = true
		new_shoot.direction = -1
	current_state = state.IDLE
	if mirando == true:
		$spread.start()
	
	
func _on_enemy_range_body_exited(body: Node2D) -> void:
	if body == player:
		current_state = state.IDLE
		$cooldown.stop()
		$spread.stop()
		
