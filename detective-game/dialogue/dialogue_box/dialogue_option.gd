extends Resource
class_name DialogueOption

@export var text: String
@export var next_dialogue: Dialogue
@export var replace_with_option: DialogueOption
@export var complete_choice: bool

var completed: bool
