extends Area2D
func _ready() -> void:
	pass
	

func _on_body_entered(body):
	if body == %player:
		%player.hp_atual += 1
		%player.max_hp += 1
		queue_free()
	
