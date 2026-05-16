extends "res://item.gd"

@export var monologue_after_reading: DialogueData

func _ready():
	super._ready()
		
	if SignalBus:
		#SignalBus.dialogue_started.connect(_on_phone_call_started)
		SignalBus.popup_closed.connect(_on_popup_closed)

func _on_phone_call_started(dialogue_data: DialogueData):
	var phone = get_tree().current_scene.find_child("Phone", true, false)
	if phone and (dialogue_data == phone.interactable.dialogue or dialogue_data == phone.interactable.dialogue_interacted):
		is_locked = false

func investigate():
	if investigatable and not is_locked:
		super.investigate()
		
		
func _on_popup_closed():
	
	print("Akte geschlossen! Starte Selbstgespräch...")
	
	if monologue_after_reading:
		SignalBus.dialogue_started.emit(monologue_after_reading)
		
	#GlobalFlags.map_unlocked = true
	print("Karte wurde freigeschaltet! [M] ist jetzt aktiv.")
