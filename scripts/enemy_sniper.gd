extends CharacterBody2D

var hp = 5
var current_state = state.IDLE
enum state {IDLE,SHOOT,STUN,DEAD}
var mirando: bool = false
var contador_i_frames=1
const BULLET = preload("res://scenes/sniper_bullet.tscn")

@onready var knockback: Timer = $knockback
@onready var colldown = $cooldown
@onready var player: Jogador = %player
@onready var enemy_hitbox: Area2D = $Enemy_hitbox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var enemy_sniper: CharacterBody2D = $"."

func _ready() -> void:
	enemy_sniper.add_to_group("enemies")

func _physics_process(delta) -> void:
	if player.global_position.x > global_position.x:
		sprite_2d.flip_h = true
	if player.global_position.x < global_position.x:
		sprite_2d.flip_h = false
	#print(current_state)
	if hp <= 0:
		current_state = state.DEAD
#isso fica procurando "como" o inimigo tá
	match current_state:
		state.IDLE:
			velocity = Vector2.ZERO
			move_and_slide()
		state.SHOOT:
			shooting()
		state.DEAD:
			queue_free()
		state.STUN:
			$cooldown.stop()
			$spread.stop()

				

	if player.hasAttacked and enemy_hitbox.overlaps_area(player.get_node("areaAtk")) and contador_i_frames==0:
		knockback.start()
		animation_player.play("stun")
		player.mana_atual+=1
		hp-=1
		contador_i_frames = 1
		#knockback
		current_state = state.STUN
		if sprite_2d.flip_h == false:
			velocity.x = 300*delta
		if sprite_2d.flip_h == true:
			velocity.x = -300*delta
		await animation_player.animation_finished
		velocity.x = 0
		await get_tree().create_timer(0.5).timeout
		if mirando == true:
			await get_tree().create_timer(1.5).timeout
			current_state = state.SHOOT
			
	if !player.hasAttacked:
		contador_i_frames=0
		

	move_and_slide()


#detecção
func _on_enemy_range_body_entered(body: CharacterBody2D) -> void:
	if body is Jogador:
		mirando = true
		$cooldown.start()

func _on_cooldown_timeout() -> void:
	if mirando and current_state!= state.SHOOT:
		current_state = state.SHOOT
	

func _on_spread_timeout() -> void:
	if mirando and current_state!= state.SHOOT:
		current_state = state.SHOOT
		
#pew pew pew 
func shooting():
	if mirando:
		animation_player.play("shot")
		var new_shoot = BULLET.instantiate()
		var alvo = get_tree().current_scene.find_child("player", true, false)
		new_shoot.height = global_position.direction_to(alvo.global_position).y
		add_sibling(new_shoot)
		new_shoot.global_position = self.global_position
		if player.global_position.x > global_position.x:
			sprite_2d.flip_h = true
			new_shoot.direction = 1
		else:
			sprite_2d.flip_h = false
			new_shoot.direction = -1
		current_state = state.IDLE
		if mirando and $spread.is_stopped():
			$spread.start()
	
	
func _on_enemy_range_body_exited(body: CharacterBody2D) -> void:
	if body is Jogador:
		current_state = state.IDLE
		mirando = false
		animation_player.play("idle")

func _on_knockback_timeout() -> void:
	velocity = Vector2.ZERO
	move_and_slide()
