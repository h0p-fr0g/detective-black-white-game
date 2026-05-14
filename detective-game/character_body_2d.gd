extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0

@onready var _animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if (Input.is_action_just_pressed("jump") and is_on_floor()):
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED
		_animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	update_animations(direction)


func update_animations(direction):
	if not is_on_floor():
		if _animated_sprite.sprite_frames.has_animation("jump"):
			_animated_sprite.play("jump")
	
	elif direction != 0:
		_animated_sprite.play("run")
	
	else:
		_animated_sprite.play("idle")
