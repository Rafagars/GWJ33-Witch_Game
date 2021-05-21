extends Node2D

var archer_scene = preload("res://characters/Archer/Archer.tscn")
var knight_scene = preload("res://characters/Knight/Knight.tscn")
var pos = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.number_of_archers = 0
	Globals.number_of_knights = 0
	$WaveTimer.set_wait_time(2)
	$WaveTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		#Pause Menu
		get_parent().get_node("PauseMenu").set_visible(true)
		get_tree().paused = true

func spawn_enemies():
	var archer = archer_scene.instance()
	var knight = knight_scene.instance()
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	if random_fifty_fifty():
		pos = Vector2(-10, random_generator.randi_range(50, 250))
	else:
		pos = Vector2(500, random_generator.randi_range(50, 250))
	if random_fifty_fifty():
		if Globals.number_of_knights < Globals.MAX_KNIGHT:
			knight.position = Vector2(pos)
			knight.spawn_point = Vector2(pos)
			add_child(knight)
			Globals.number_of_knights += 1
	else:
		if Globals.number_of_archers < Globals.MAX_ARCHER: 
			archer.position = Vector2(pos)
			archer.spawn_point = Vector2(pos)
			add_child(archer)
			Globals.number_of_archers += 1

func random_fifty_fifty():
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	return random_generator.randi_range(0, 1)

func _on_WaveTimer_timeout():
	spawn_enemies()
