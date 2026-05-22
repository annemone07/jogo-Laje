extends Area2D

#A mira do eixo Y da bala está como height, pra deixar ela mirando no jogador, precisa definir ela no atirador

var speed = 650
var direction = 1
var height = 0.0 

func _process(delta: float) -> void:
	position.x += speed * delta * direction
	position.y += speed * delta * height


#func _on_body_entered(body: Node2D) -> void:
#	queue_free()
