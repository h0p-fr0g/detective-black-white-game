extends Area2D

@export var dialogue: DialogueData
@export var dialogue_interacted: DialogueData
@export var tooltip_text: String = ""

@onready var tooltip = $Label


var player_in_range = false
var interacted = false

func _ready():
	tooltip.hide()

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		SignalBus.dialogue_started.emit(dialogue_interacted if interacted else dialogue)
		interacted = true


func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		tooltip.text = tooltip_text
		tooltip.show()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false
		tooltip.hide()
