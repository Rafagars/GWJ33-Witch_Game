extends Node2D

var archer_scene = preload("res://characters/Archer/Archer.tscn")
var knight_scene = preload("res://characters/Knight/Knight.tscn")
var pos = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	$WaveTimer.set_wait_time(2)
	$WaveTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		return get_tree().change_scene("res://menus/PauseMenu.tscn")

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
		knight.position = Vector2(pos)
		add_child(knight)
	else: 
		archer.position = Vector2(pos)
		archer.spawn_point = Vector2(pos)
		add_child(archer)
	
	Globals.i += 1

func random_fifty_fifty():
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	return random_generator.randi_range(0, 1)

func _on_WaveTimer_timeout():
	if Globals.i < Globals.MAX_ENEMIES:
		spawn_enemies()
