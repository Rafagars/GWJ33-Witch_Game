extends Control

export(Texture) var heart
export(Texture) var empty_heart

onready var hp_counter = $HPCounter
onready var currency_counter = $CurrencyCounter
onready var score = $Score

# update if the types are incorrect
onready var game : Node2D
onready var player : KinematicBody2D


func _ready() -> void:
	draw_hearts(4)


# draw_hearts() is only for when the game starts. Use update_hearts() for mid-game stuff
func draw_hearts(_max_hp):
	for i in _max_hp:
		var s = TextureRect.new()
		s.set_texture(heart)
		hp_counter.add_child(s)


func update_hearts(max_hp, hp):
	for i in hp_counter.get_children():
		i.queue_free()
	
	yield(get_tree(), "idle_frame") # prevents displaying more hearts than needed
	
	# Loops however many hearts the player has and displays accordingly
	for i in max_hp:
		if i+1 <= hp: 
			var s = TextureRect.new()
			s.set_texture(heart)
			hp_counter.add_child(s)
			
		else:
			var s = TextureRect.new()
			s.set_texture(empty_heart)
			hp_counter.add_child(s)


func update_currency(amount : int):
	currency_counter.get_node("text").set_text(str(amount))


func update_score(amount : int):
	score.set_text("Score: " + str(amount))
