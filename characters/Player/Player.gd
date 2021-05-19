extends KinematicBody2D

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80

var velocity = Vector2.ZERO

export var health = 4
export var mana = 10
# To avoid that the player gets hit more that once in less that a second
export var healthCooldown: int = 3 
onready var healthCooldownTimer := $HeatlhCooldownTimer
var hit = false
# Stores the click position
var mouse_pos = Vector2.ZERO

var beam_scene = preload("res://characters/Player/beam/Beam.tscn")

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$ManaTimer.set_wait_time(2)
	$ManaTimer.start()

func _input(event):
	if event is InputEventMouseButton:
		mouse_pos = Vector2(event.position)

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	if Input.is_action_just_pressed("attack"):
		if mana > 0:
			var beam = beam_scene.instance()
			beam.position = self.position
			beam.dir = Vector2(mouse_pos.x - self.position.x, mouse_pos.y - self.position.y).normalized()
			mana -= 1
			get_parent().add_child(beam)
			
	if Input.is_action_just_pressed("ui_accept"):
		return get_tree().change_scene("res://menus/PauseMenu.tscn")
		
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector.y == 1 and input_vector.x == 0:
		$AnimatedSprite.play("Walk_front")
	elif input_vector.y == -1 and input_vector.x == 0:
		$AnimatedSprite.play("Walk_back")
	elif input_vector.x == 1 and input_vector.y == 0:
		$AnimatedSprite.play("Walk_right")
	elif input_vector.x == -1 and input_vector.y == 0:
		$AnimatedSprite.play("Walk_Left")
	else:
		$AnimatedSprite.stop()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector.normalized() * MAX_SPEED, ACCELERATION * delta)
	else:
		#Stop movement
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	$Pointer.look_at(get_global_mouse_position())
	
	get_node("/root/LevelUI").update_currency(mana)
	
	if health < 1:
		Globals.score = 0
		return get_tree().change_scene("res://menus/GameOver.tscn")


func _on_ManaTimer_timeout():
	#Restore mana if mana isn't full
	if mana < 10:
		mana += 1


func _on_HeatlhCooldownTimer_timeout():
	#Makes the player vunerable again
	hit = false
