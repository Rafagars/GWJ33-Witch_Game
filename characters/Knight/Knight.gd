extends Area2D

var dir = Vector2.ZERO
onready var player = get_parent().get_node("Player")
export var health = 2
var mana_scene = preload("res://obj/ManaOrb/ManaOrb.tscn")
var counter = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir = Vector2(player.position.x - self.position.x, player.position.y - self.position.y).normalized()
	self.position += dir * delta * 60
	if Vector2(player.position.x - self.position.x, player.position.y - self.position.y).length() < 20:
		$AnimatedSprite.play("Attack")
		$Attack.disabled = false
	else:
		$AnimatedSprite.play("Walk")
		$Attack.disabled = true
	if health < 1:
		Globals.i -= 1
		if counter > 0:
			var mana = mana_scene.instance()
			mana.position = self.position
			get_parent().add_child(mana)
			counter -= 1
		queue_free()
		
	if $Attack/RayCast2D.is_colliding():
		var collider = $Attack/RayCast2D.get_collider()
		if collider.is_in_group("PLAYER") and collider.hit == false:
			collider.hit = true
			collider.health -= 1
			collider.healthCooldownTimer.start(collider.healthCooldown)
			get_node("/root/LevelUI").update_hearts(4, collider.health)


func _on_VisibilityNotifier2D_screen_exited():
	Globals.i -= 1
	queue_free()
