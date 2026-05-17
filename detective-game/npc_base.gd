extends Node2D
class_name NPCBase

@export var npc_name: String = "Person"
@export var flip_h: bool = false
@export var second_dialogue: Dialogue

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.flip_h = flip_h
	sprite.play("idle")


func _on_interacted() -> void:
	await get_tree().process_frame
	$Interactable.dialogue = second_dialogue
