class_name Jogador

extends CharacterBody2D
signal trocarSala

var posVoltar=global_position
var hasAttacked=false
var canEnter = false
var posTp = Vector2(100,100)
var canJump = true
var contadorCoyote=0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var player: Jogador = $"."
@onready var coyote_timer: Timer = $coyoteTimer
@onready var loading: AnimationPlayer = %loading
@onready var area_atk: Area2D = $areaAtk
@onready var timer_attack: Timer = $timerAttack
@onready var atk_direita: CollisionShape2D = $areaAtk/atkDireita
@onready var atk_esquerda: CollisionShape2D = $areaAtk/atkEsquerda
@onready var timer_ranged: Timer = $timerRanged

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("mLeft", "mRight")
	GlobalScript.playerPos = global_position
	#print(canEnter)
	entrar()
	
	#controla ataque básico
	
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
		
		if direction>0:
			atk_direita.disabled=false
			atk_esquerda.disabled=true
		elif direction<0:
			atk_direita.disabled=true
			atk_esquerda.disabled=false
		
		ranged()
		
		attack()
		
		if direction:
			GlobalScript.playerDirection = direction
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		#caso esteja atravessando, para de andar
		velocity.x=0
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
	if Input.is_action_just_pressed("rangedAttack") and timer_ranged.is_stopped():
		var bala = preload("res://scenes/ranged_shot.tscn").instantiate()
		#var balaCarregada = bala.instantiate()
		player.add_sibling(bala)
		#timer_ranged.start()
		hasAttacked=true

func _on_timer_attack_timeout() -> void:
	hasAttacked=false
