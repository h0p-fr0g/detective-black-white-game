extends "res://item.gd"

@export var monologue_after_reading: Dialogue

var is_reading_in_office = false 

func _ready():
	super._ready()
	if SignalBus:
		SignalBus.dialogue_started.connect(_on_phone_call_started)
		SignalBus.popup_closed.connect(_on_popup_closed)

func _on_phone_call_started(dialogue_data: Dialogue):
	var phone = get_tree().current_scene.find_child("Phone", true, false)
	if phone and (dialogue_data == phone.interactable.dialogue):
		is_locked = false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not is_locked:
		if not is_reading_in_office:
			is_reading_in_office = true
			
			investigate()
			#pick_up(false) 
			hide()
			set_deferred("monitoring", false)
			set_deferred("monitorable", false)

func _on_popup_closed():
	if is_reading_in_office:
		is_reading_in_office = false
		
		if monologue_after_reading:
			SignalBus.dialogue_started.emit(monologue_after_reading)
			
		PlayerInput.map_unlocked = true
		SignalBus.map_unlocked.emit()
		
		GlobalFlags.files_searched = true;
		
		queue_free()
