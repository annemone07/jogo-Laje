extends Node2D
@onready var camera_2d: Camera2D = $CanvasLayer/Camera2D
@onready var corpo_maca: RigidBody2D = $corpoMaca
@onready var timer_cair: Timer = $timerCair
@onready var loading: AnimationPlayer = %loading
@onready var timer_acabar: Timer = $timerAcabar
var contador=0
signal finish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	corpo_maca.freeze = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position.x = corpo_maca.position.x
	camera_2d.position.y = corpo_maca.position.y
	if corpo_maca.sleeping and contador==0:
		contador+=1
		print("a")
		timer_acabar.start()

#inicia maçã cair
func _on_timer_cair_timeout() -> void:
	corpo_maca.freeze=false

#dá o fade to black na cutscene inicial
func _on_timer_acabar_timeout() -> void:
	loading.play("loading1")

#descarrega essa cena e carrega primeira área
func _on_loading_animation_finished(anim_name: StringName) -> void:
	finish.emit()
