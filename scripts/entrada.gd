extends Node2D
signal enter(can,saida)
@onready var enter_arrow: Sprite2D = $EnterArrow
@onready var pos_saida: Node2D = $posSaida
@onready var entrada: Area2D = $"."
@onready var delay_voltar: Timer = $delay_voltar
@onready var player: Jogador = %player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#	if entrada.overlaps_body(CharacterBody2D)

#detecta que o jogador tá numa área de porta
func _on_body_entered(body: CharacterBody2D) -> void:
	if body is Jogador:
		body.canEnter = true
		body.posTp = pos_saida.global_position
		enter_arrow.visible = true

#detecta que o jogador saiu de uma área de porta
func _on_body_exited(body: CharacterBody2D) -> void:
	player.canEnter = false
	enter_arrow.visible = false
