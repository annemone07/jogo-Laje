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
@onready var atk_esquerda: CollisionShape2D = $areaAtk/atkEsquerda
@onready var timer_ranged: Timer = $timerRanged
@onready var timer_i_frames: Timer = $timer_I_frames

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("mLeft", "mRight")
	GlobalScript.playerPos = global_position
	#print(canEnter)
	entrar()
	
	if hp_atual<=0:
		GlobalScript.salaAtual = get_parent().scene_file_path
		morreu.emit()
	
	if takeDmg and not invulnerable:
			hp_atual-=1
			#print ("Esse é um máximoooooo:", max_hp)
			print(hp_atual)
			takeDmg=false
			invulnerable=true
	
	#gravidade
	if not is_on_floor():
		if contadorCoyote==0:
			print("teste")
			coyote_timer.start()
			contadorCoyote+=1
		velocity += get_gravity() * delta
	else:
		contadorCoyote=0
		canJump=true
		
	#caso não esteja atravessando uma porta/caminho, pode se mover
	if not loading.is_playing():
		if Input.is_action_just_pressed("jump") and canJump:
			canJump = false
			velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		if timer_attack.is_stopped():
			var upDown = Input.get_axis("up", "down")
			print(direction)
			print(upDown)
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
			print(area_atk.rotation)
			#if direction>0:
			#	atk_direita.disabled=false
			#	atk_esquerda.disabled=true
			#elif direction<0:
			#	atk_direita.disabled=true
			#	atk_esquerda.disabled=false
		
		ranged()
		
		attack()
		
		animacao_ataque()
		
		if not invulnerable: #caso normal
			if direction: #se andando
				GlobalScript.playerDirection = direction
				velocity.x = direction * SPEED
			else: #se sem andar
				velocity.x = move_toward(velocity.x, 0, SPEED)
		else: #se em estado de knockback, como foi lançado lá em _on_hurtbox_body_entered, se movimenta até chegar em 0
			velocity = velocity.move_toward(Vector2.ZERO, delta)
	else:
		#caso esteja atravessando uma porta, para de andar
		velocity.x = 0
	
	move_and_slide()

func _on_coyote_timer_timeout() -> void: #permite pular por um tempo dps de sair da plataforma (0.5s)
	canJump = false
	print("teste2")

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
		timer_attack.start()
		hasAttacked=true

func ranged():
	if Input.is_action_just_pressed("rangedAttack") and timer_ranged.is_stopped() && mana_atual > 0:
		var bala = preload("res://scenes/ranged_shot.tscn").instantiate()
		#var balaCarregada = bala.instantiate()
		player.add_sibling(bala)
		#timer_ranged.start()
		hasAttacked=true
		mana_atual -= 1
		print ("mana atual:", mana_atual)

func _on_timer_attack_timeout() -> void:
	hasAttacked=false

#player taking dmg if enemy enters their hurtbox
func _on_hurtbox_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("enemies"): #verifica se corpo é inimigo
		if not invulnerable:
			takeDmg=true
			timer_i_frames.start()
		knockbackDirection = body.position.direction_to(global_position)
		velocity = knockbackDirection.normalized() * 300 #lança o player na velocidade do knockback
		velocity.y -= 150

func _on_timer_i_frames_timeout() -> void:
	invulnerable=false
	
func animacao_ataque():
	#eventual animação ao atacar, por enquanto mostra qual lado do ataque tá ativo
	if hasAttacked:
		area_atk.visible=true
	else:
		area_atk.visible=false
