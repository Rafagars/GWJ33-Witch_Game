extends KinematicBody2D

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80

var velocity = Vector2.ZERO

export var health = 4
export var mana = 10
export var fireDelay: float = 0.2
onready var fireDelayTimer := $FireDelayTimer

var mouse_pos = Vector2.ZERO

var beam_scene = preload("res://characters/Player/beam/Beam.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
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
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)
	$Pointer.look_at(get_global_mouse_position())


func _on_ManaTimer_timeout():
	if mana < 10:
		mana += 1
