extends Area2D
func _ready() -> void:
	pass
	

func _on_body_entered(body):
	if body == %player:
		%player.hp_max += 1
		queue_free()
	
