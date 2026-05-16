extends CharacterBody2D

const SPEED = 200.0

@onready var _animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):

	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
		_animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	update_animations(direction)


func update_animations(direction):
	
	if direction != 0:
		_animated_sprite.play("run")
	
	else:
		_animated_sprite.play("idle")
