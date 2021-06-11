extends Area2D

var dir = Vector2.ZERO
onready var player = get_parent().get_node("Player")
var heart_scene = preload("res://obj/Heart/Heart.tscn")
var mana_scene = preload("res://obj/ManaOrb/ManaOrb.tscn")
onready var hurt = $Hurt
var turned = false #If turned into animal or not
var spawn_point = Vector2.ZERO #Point from where the enemy spawn
var counter = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func drop_loot():
	if get_node("/root/LevelUI/Level1").random_fifty_fifty() == 0:
		#To avoid "infinites" orb spawning
		var mana = mana_scene.instance()
		mana.position = self.position
		get_parent().add_child(mana)
	else:
		var heart = heart_scene.instance()
		heart.position = self.position
		get_parent().add_child(heart)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
