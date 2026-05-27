extends CanvasLayer
@onready var life :int
@onready var max_life :int
@onready var mana:int
@onready var max_mana: int
var textura_vida : Texture2D 
var textura_mana : Texture2D
func _ready() -> void:
	textura_vida = $life_sprite.texture
	textura_mana = $mana_sprite.texture
	
	$life_sprite.texture = null
	$mana_sprite.texture = null
	
	#coloca a vida e mana máximas como sendo a atual no começo do jogo
	max_mana = get_parent().max_mana
	max_life = get_parent().max_hp
	life = max_life
	mana = max_mana
	hp_check()
	mana_check()
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	
	current_profile()
	for i in (max_life):
		var nova_barra = Sprite2D.new()
		nova_barra.texture = textura_vida
		$life_sprite.add_child(nova_barra)
	for i in (max_mana):
		var nova_mana = Sprite2D.new()
		nova_mana.texture = textura_mana
		$mana_sprite.add_child(nova_mana)
		
		
	life = get_parent().hp_atual
	max_life = get_parent().max_hp
	hp_check()	
	mana = get_parent().mana_atual
	max_mana = get_parent().max_mana
	mana_check()
#checa qual é o hp atual e remove a barra de vida se ele não estiver lá
func hp_check():
	#coloca um handicap na vida para não ser maior doq o máximo
	if life > max_life:
		life = max_life
	for barra in $life_sprite.get_children():
		var numero_da_barra = barra.get_index()
		var x = ((numero_da_barra)*2000)
		var y = (0)
		barra.position = Vector2(x,y)
		if numero_da_barra >= life:
			barra.queue_free()
	
#foto de perfil da prota (coloquei como animação pq: explico em call se quiser)
func current_profile():
	
	
	if life >= 4:
		$player_portrait/animation.play("normal")
	if life < 4 && life > 2:
		$player_portrait/animation.play("medium")
	if life < 2:
		$player_portrait/animation.play("low")

func mana_check():
	if mana > max_mana:
		mana = max_mana
	for magia in $mana_sprite.get_children():
		var barra_de_mana = magia.get_index()
		var x = ((barra_de_mana)*1600)
		var y = (0)
		magia.position = Vector2(x,y)
		if barra_de_mana >= mana:
			magia.queue_free()

	pass
