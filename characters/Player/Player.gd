extends KinematicBody2D

const ACCELERATION = 500
const FRICTION = 500
const MAX_SPEED = 80

var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
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
	
