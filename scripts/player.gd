class_name Jogador

extends CharacterBody2D
signal trocarSala
signal morreu
var knockbackDirection=0
var posVoltar=global_position
var invulnerable=false
var takeDmg=false
var hasAttacked=false
var canEnter = false
var posTp = Vector2(100,100)
var canJump = true
var contadorCoyote=0
const SPEED = 300.0
const JUMP_VELOCITY = -800.0
var rangedAtacou=false
@export var max_mana: int = 5
@export var max_hp: int = 5
@onready var mana_atual = max_mana
@onready var hp_atual = max_hp
@onready var player: Jogador = $"."
@onready var coyote_timer: Timer = $coyoteTimer
@onready var loading: AnimationPlayer = %loading
@onready var area_atk: Area2D = $areaAtk
@onready var timer_attack: Timer = $timerAttack
@onready var atk_direita: CollisionShape2D = $areaAtk/atkDireita
@onready var timer_ranged: Timer = $timerRanged
@onready var timer_i_frames: Timer = $timer_I_frames
@onready var personagem: Sprite2D = $Personagem
@onready var atk_sound: AudioStreamPlayer2D = $atkSound
@onready var jump_sound: AudioStreamPlayer2D = $jumpSound
@onready var ranged_atk_sound: AudioStreamPlayer2D = $rangedAtkSound
@onready var dmg_sound: AudioStreamPlayer2D = $dmgSound
@onready var run_1_sound: AudioStreamPlayer2D = $run1Sound
@onready var run_2_sound: AudioStreamPlayer2D = $run2Sound
@onready var player_animations: AnimationPlayer = $Personagem/player_animations
@onready var hurtbox: Area2D = $hurtbox


func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("mLeft", "mRight")
	GlobalScript.playerPos = global_position
	
	mana_atual = clamp(mana_atual,0,5)
	#print(canEnter)
	entrar()
	if direction == -1.0:
		personagem.flip_h = true

	if direction == 1.0:
		personagem.flip_h = false
		
	if hp_atual<=0:
		GlobalScript.salaAtual = get_parent().scene_file_path
		player_animations.play("dead")
		#await(player_animations.animation_finished)
		morreu.emit()
	
	if takeDmg and not invulnerable:
		dmg_sound.play()
		hp_atual-=1
		#print ("Esse é um máximoooooo:", max_hp)
		print(hp_atual)
		takeDmg=false
		invulnerable=true
	
	#gravidade
	if not is_on_floor():
		if contadorCoyote==0:
			#print("teste")
			coyote_timer.start()
			contadorCoyote+=1
		velocity += get_gravity() * delta*1.2
	else:
		contadorCoyote=0
		canJump=true
		
	#caso não esteja atravessando uma porta/caminho, pode se mover
	if not loading.is_playing():
		if Input.is_action_just_pressed("jump") and canJump:
			player_animations.play("jump")
			jump_sound.play()
			canJump = false
			velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		if timer_attack.is_stopped():
			var upDown = Input.get_axis("up", "down")
			
			
			#print(direction)
			#print(upDown)
			if direction<0.0:
				if upDown>0.0:
					area_atk.rotation_degrees = -225
				elif upDown<0.0:
					area_atk.rotation_degrees = -135
				else:
					area_atk.rotation_degrees = -180
			elif direction>0.0:
				if upDown>0.0:
					area_atk.rotation_degrees = 45
				elif upDown<0.0:
					area_atk.rotation_degrees = -45
				else:
					area_atk.rotation_degrees = 0
			else:
				if upDown<0:
					area_atk.rotation_degrees = -90
				elif upDown>0:
					area_atk.rotation_degrees = 90
				else:
					if GlobalScript.playerDirection>0:
						area_atk.rotation_degrees = 0
					elif GlobalScript.playerDirection<0:
						area_atk.rotation_degrees = -180
					
			#print(area_atk.rotation)
			#if direction>0:
			#	atk_direita.disabled=false
			#	atk_esquerda.disabled=true
			#elif direction<0:
			#	atk_direita.disabled=true
			#	atk_esquerda.disabled=false
		
		ranged()
		
		attack()
		
		animacao_ataque()
		
		
		if Input.is_action_just_pressed("regen") and mana_atual==5:
			mana_atual-=5
			hp_atual+=3
			hp_atual=clamp(hp_atual,0,5)
		
		#if timer_attack.timeout:
		#	if direction<0.0:
		#		area_atk.rotation = -90
		#	elif direction>0.0:
		#		area_atk.rotation = 90
		
		if not invulnerable: #caso normal
			if direction: #se andando
				if not hasAttacked and not rangedAtacou and canJump:
					player_animations.play("run")
				GlobalScript.playerDirection = direction
				velocity.x = direction * SPEED
			else: #se sem andar
				if not hasAttacked and not rangedAtacou and canJump:
					player_animations.play("idle")
				velocity.x = move_toward(velocity.x, 0, SPEED)
		else: #se em estado de knockback, como foi lançado lá em _on_hurtbox_body_entered, se movimenta até chegar em 0
			velocity = velocity.move_toward(Vector2.ZERO, delta)
	else:
		#caso esteja atravessando uma porta, para de andar
		velocity.x = 0
	
	move_and_slide()

func _on_coyote_timer_timeout() -> void: #permite pular por um tempo dps de sair da plataforma (0.5s)
	canJump = false
	print("coyote")

func entrar(): #inicia animação de entrar nas portas
	if canEnter:
		if Input.is_action_just_pressed("up"):
			loading.play("loading1")

func _on_loading_animation_finished(anim_name: StringName) -> void: #teleporta jogador e finaliza animação
	if anim_name=="loading1":
		posVoltar = global_position
		global_position=Vector2(posTp)
		loading.play("loading2")

func attack():
	if Input.is_action_just_pressed("attackButton") and timer_attack.is_stopped():
		atk_sound.play()
		timer_attack.start()
		hasAttacked=true
		await player_animations.animation_finished
		player_animations.play("idle")
func ranged():
	if Input.is_action_just_pressed("rangedAttack") and timer_ranged.is_stopped() && mana_atual > 0:
		timer_ranged.start()
		rangedAtacou=true
		mana_atual -= 1
		ranged_atk_sound.play()
		var bala = preload("res://scenes/ranged_shot.tscn").instantiate()
		#var balaCarregada = bala.instantiate()
		player.add_sibling(bala)
		#timer_ranged.start()
		#hasAttacked=true
		player_animations.play("atirou")
		await player_animations.animation_finished
		player_animations.play("idle")
		#print ("mana atual:", mana_atual)

func _on_timer_attack_timeout() -> void:
	hasAttacked=false

#player taking dmg if enemy enters their hurtbox
func _on_hurtbox_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemies") and body.hp>0 and is_instance_valid(body): #verifica se corpo é inimigo
		if not invulnerable:
			print("foi atacado")
			takeDmg=true
			timer_i_frames.start()
			player_animations.play("dano")
			await player_animations.animation_finished
			if is_instance_valid(body) and is_instance_valid(player) and is_instance_valid(hurtbox):
				player_animations.play("idle")
				knockbackDirection = body.position.direction_to(global_position)
				velocity = knockbackDirection.normalized() * 300 #lança o player na velocidade do knockback
				velocity.y -= 150

func _on_timer_i_frames_timeout() -> void:
	invulnerable=false
	
func animacao_ataque():
	if hasAttacked:
		player_animations.stop()
		player_animations.play("bateu")
		
		


func _on_timer_ranged_timeout() -> void:
	rangedAtacou=false
