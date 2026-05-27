extends Area2D
@onready var rock: TileMapLayer = %rock
@onready var fall_rock: AnimationPlayer = %fallRock
@onready var area_2d: Area2D = $"."

func _on_body_entered(body: CharacterBody2D) -> void:
	if body is Jogador and fall_rock:
		fall_rock.play("fall")
		area_2d.queue_free()
