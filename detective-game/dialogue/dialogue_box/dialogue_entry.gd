extends Resource
class_name DialogueEntry

@export var character_sprite: Texture2D = preload("res://dialogue/portraits/detective.png")
@export var text: Array[String]
@export var choice: DialogueChoice
