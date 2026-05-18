extends Node2D
signal enter(can)
@onready var enter_arrow: Sprite2D = $EnterArrow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: CharacterBody2D) -> void:
	enter.emit(true)
	enter_arrow.visible = true

func _on_body_exited(body: Node2D) -> void:
	enter.emit(false)
	enter_arrow.visible = false
