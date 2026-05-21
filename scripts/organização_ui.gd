extends Node2D
@onready var placeholder_vida: Sprite2D = $PlaceholderVida
@onready var placeholder_mana: Sprite2D = $PlaceholderMana
@onready var player: Jogador = %player
var vidaPlayerMax
var tamanhoInicialVida
var tamanhoInicialMana
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vidaPlayerMax = player.hp
	tamanhoInicialVida=placeholder_vida.scale.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	placeholder_vida.scale.x = remap(player.hp, 0, vidaPlayerMax, 0, tamanhoInicialVida)
