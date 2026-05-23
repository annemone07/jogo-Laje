extends Area2D

#A mira do eixo Y da bala está como height, pra deixar ela mirando no jogador, precisa definir ela no atirador

var speed = 450
var direction = 1
var height = 0.0 

func _process(delta: float) -> void:
	position.x += speed * delta * direction
	position.y += speed * delta * height


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
	elif body is Jogador:
		body.hp_atual-=1
		queue_free()
