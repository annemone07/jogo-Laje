extends Node2D
@onready var master_vol: HSlider = $master_vol
@onready var musica_vol: HSlider = $musica_vol
@onready var resolucoes: MenuButton = $Resolucoes

@onready var tamanhos_tela = [Vector2i(1920,1080),Vector2i(960,540),Vector2i(640,360)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_vol.value = GlobalScript.valor_slider_master
	musica_vol.value = GlobalScript.valor_slider_musica
	GlobalScript.valor_slider_master=master_vol.value
	GlobalScript.valor_slider_musica=musica_vol.value
	resolucoes.get_popup().add_item("1920x1080")
	resolucoes.get_popup().add_item("960x540")
	resolucoes.get_popup().add_item("640x360")
	resolucoes.get_popup().id_pressed.connect(self._on_popup_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_popup_pressed(botao):
	DisplayServer.window_set_size(tamanhos_tela[botao])

func _on_master_vol_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(GlobalScript.master_bus, linear_to_db(value))
	GlobalScript.valor_slider_master = value


func _on_musica_vol_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(GlobalScript.musica_bus, linear_to_db(value))
	GlobalScript.valor_slider_musica = value


func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
