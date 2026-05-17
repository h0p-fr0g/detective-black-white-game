extends Node2D

@export var late_dialogue: Dialogue
@export var make_call_dialogue: Dialogue
@export var second_try_dialogue: Dialogue
@export var third_try_dialogue: Dialogue

@onready var interactable = $Interactable
@onready var tooltip_label = $Interactable/Label

var is_ringing = true
var ring_timer = 0.0
var second_call_setup_done = false


var event_step: int = 0

func _ready():
	if not GlobalFlags.phone_should_ring:
		is_ringing = false
		$Sprite2D.rotation = 0
		
		if not GlobalFlags.second_neighbor_dialogue_finished:
			_deactivate_phone()
			return

	if SignalBus:
		SignalBus.dialogue_started.connect(_on_dialogue_started)
		SignalBus.dialogue_finished.connect(_on_dialogue_finished)

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
				
	else:
		if GlobalFlags.second_neighbor_dialogue_finished:
			if event_step > 0:
				return
				
			if not second_call_setup_done:
				_activate_phone_for_second_call()
			
			if interactable.player_in_range:
				interactable.tooltip_text = "[E] make a call"
				tooltip_label.text = interactable.tooltip_text
				tooltip_label.show()
		

func _on_dialogue_started(dialogue: Dialogue):
	if dialogue == interactable.dialogue and is_ringing:
		is_ringing = false
		$Sprite2D.rotation = 0
		GlobalFlags.phone_should_ring = false
		_deactivate_phone()


func _on_dialogue_finished(p_ended_dialogue: Dialogue) -> void:

	if p_ended_dialogue == make_call_dialogue and event_step == 0:
		event_step = 1

	if event_step == 1:
		event_step = 2
		
		GlobalFlags.trigger_invert_shader(true) 
		
		if second_try_dialogue:
			await get_tree().process_frame
			SignalBus.dialogue_started.emit(second_try_dialogue)
		return

	if event_step == 2:
		event_step = 3
		
		GlobalFlags.trigger_invert_shader(false)
		
		if third_try_dialogue:
			await get_tree().process_frame
			SignalBus.dialogue_started.emit(third_try_dialogue)
		return

	if event_step == 3:
		GlobalFlags.location_bar_unlocked = true
		event_step = 0
		_deactivate_phone()


func _deactivate_phone():
	if tooltip_label:
		tooltip_label.text = ""
		tooltip_label.hide()
	interactable.set_process(false)
	interactable.visible = false
	interactable.set_deferred("monitoring", false)
	interactable.set_deferred("monitorable", false)

func _activate_phone_for_second_call():
	second_call_setup_done = true
	
	if make_call_dialogue:
		interactable.dialogue = make_call_dialogue
		
	interactable.set_process(true)
	interactable.visible = true
	interactable.set_deferred("monitoring", true)
	interactable.set_deferred("monitorable", true)
