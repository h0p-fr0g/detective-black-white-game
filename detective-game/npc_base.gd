extends Area2D

@export var npc_name: String = "Person"
@export var dialogue: DialogueData
@export var dialogue_interacted: DialogueData
@export var character_sprite: SpriteFrames
@export var flip_h: bool = false

@onready var tooltip = $Label
@onready var sprite = $AnimatedSprite2D

var player_in_range = false
var interacted = false

func _ready():
	tooltip.hide()
	if character_sprite:
		sprite.sprite_frames = character_sprite
		sprite.flip_h = flip_h
		sprite.play("idle")

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		tooltip.text = "[E] talk to " + npc_name
		tooltip.show()

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		tooltip.hide()

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		SignalBus.dialogue_started.emit(dialogue_interacted if interacted else dialogue)
		interacted = true
