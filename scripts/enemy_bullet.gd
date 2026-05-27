extends Area2D

#A mira do eixo Y da bala está como height, pra deixar ela mirando no jogador, precisa definir ela no atirador
@onready var sprite_2d: Sprite2D = $Sprite2D

var speed = 450
var direction = 1
var height = 0.0 

func _process(delta: float) -> void:
	position.x += speed * delta * direction
	position.y += speed * delta * height
	if direction>0:
		sprite_2d.flip_h=false
	else:
		sprite_2d.flip_h=true

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
	elif body is Jogador:
		body.hp_atual-=1
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "areaAtk":
		queue_free()
