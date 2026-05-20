extends Area2D
@onready var player: Jogador = %player
@onready var pos_saida: Node2D = $posSaida
@onready var loading: AnimationPlayer = %loading

#detecta que o jogador tá numa área de porta
func _on_body_entered(body: CharacterBody2D) -> void:
	if body is Jogador:
		body.posTp = pos_saida.global_position
		loading.play("loading1")

#detecta que o jogador saiu de uma área de porta
func _on_body_exited(body: CharacterBody2D) -> void:
	player.canEnter = false
