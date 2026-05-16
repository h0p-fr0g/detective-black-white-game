extends Node2D

@onready var interactable = $Interactable
@onready var tooltip_label = $Interactable/Label

var is_ringing = true
var ring_timer = 0.0

func _ready():
	if SignalBus:
		SignalBus.dialogue_started.connect(_on_dialogue_started)

func _process(delta):
	if is_ringing:
		ring_timer += delta
		
		if interactable.player_in_range:
			interactable.tooltip_text = "[E] take the call"
			tooltip_label.text = interactable.tooltip_text
			tooltip_label.show()
			
			if ring_timer > 1.5:
				ring_timer = 0.0
				$Sprite2D.rotation = randf_range(-0.08, 0.08)
			elif ring_timer > 0.7:
				$Sprite2D.rotation = 0
				
		else:
			if ring_timer > 1.5:
				ring_timer = 0.0
				interactable.tooltip_text = "*** RING RING! ***"
				tooltip_label.text = "*** RING RING! ***"
				tooltip_label.show()
				$Sprite2D.rotation = randf_range(-0.08, 0.08)
			elif ring_timer > 0.7:
				tooltip_label.hide()
				$Sprite2D.rotation = 0

func _on_dialogue_started(dialogue_data: DialogueData):

	if dialogue_data == interactable.dialogue or dialogue_data == interactable.dialogue_interacted:
		if is_ringing:
			is_ringing = false
			$Sprite2D.rotation = 0
						
			tooltip_label.text = ""
			tooltip_label.hide()
			
			interactable.set_process(false)
			interactable.visible = false
			
			interactable.set_deferred("monitoring", false)
			interactable.set_deferred("monitorable", false)
			
			set_process(false)
