extends Node2D
class_name NPCBase

@export var npc_name: String = "Person"
@export var character_sprite: SpriteFrames
@export var flip_h: bool = false

@onready var sprite = $AnimatedSprite2D


func _ready():
	if character_sprite:
		sprite.sprite_frames = character_sprite
		sprite.flip_h = flip_h
		sprite.play("idle")
