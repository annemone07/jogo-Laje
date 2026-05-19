class_name Jogador

extends CharacterBody2D
signal trocarSala

var posVoltar=global_position
var canEnter = false
var posTp = Vector2(100,100)
var canJump = true
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var coyote_timer: Timer = $coyoteTimer
@onready var loading: AnimationPlayer = %loading

func _physics_process(delta: float) -> void:
	#print(canEnter)
	entrar()
	
	#gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer.start()
	else:
		canJump=true
	
	#caso não esteja atravessando uma porta/caminho, pode se mover
	if not loading.is_playing():
		if Input.is_action_just_pressed("jump") and canJump:
			velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("mLeft", "mRight")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		#caso esteja atravessando, para de andar
		velocity.x=0
	move_and_slide()

func _on_coyote_timer_timeout() -> void: #permite pular por um tempo dps de sair da plataforma (0.5s)
	canJump = false

func entrar(): #inicia animação de entrar nas portas
	if canEnter:
		if Input.is_action_just_pressed("up"):
			loading.play("loading1")

func _on_loading_animation_finished(anim_name: StringName) -> void: #teleporta jogador e finaliza animação
	if anim_name=="loading1":
		posVoltar = global_position
		global_position=Vector2(posTp)
		loading.play("loading2")
