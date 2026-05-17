extends Area2D

@export var dialogue: Dialogue
@export var tooltip_text: String = ""

@onready var tooltip = $Label

signal interacted

var player_in_range = false

func _ready():
	tooltip.hide()

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		interacted.emit()
		if dialogue:
			SignalBus.dialogue_started.emit(dialogue) #TODO: this shouldn't happen here. interactable shouldn't be hardwired to start a dialogue

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		tooltip.text = tooltip_text
		tooltip.show()


func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in_range = false
		tooltip.hide()
