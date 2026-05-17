extends Node2D

@export var inverted_dialogue: Dialogue
@export var black_dialogue: Dialogue
#@export var credits: PackedScene

var stage = 0

func _ready() -> void:
	await get_tree().process_frame
	SignalBus.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished(dialogue):
	if stage == 0:
		GlobalFlags.trigger_invert_shader(true)
		SignalBus.dialogue_started.emit(inverted_dialogue)
		stage = 1
	
	elif stage == 1:
		$Blackscreen.visible = true
		await get_tree().create_timer(2.0).timeout
		SignalBus.dialogue_started.emit(black_dialogue)
		$Driver.queue_free()
		$ApartmentDoor.queue_free()
		stage = 2
		
	elif stage == 2:
		await get_tree().create_timer(2.0).timeout
		GlobalFlags.trigger_invert_shader(false)
		$DeadDriver.visible = true
		$Blackscreen.visible = false
		await get_tree().create_timer(5.0).timeout
		$Title.visible = true
		await get_tree().create_timer(5.0).timeout
		$Title.visible = false
		await get_tree().create_timer(1.0).timeout
		$Credits.visible = true
		await get_tree().create_timer(5.0).timeout
		$Credits.visible = false
		await get_tree().create_timer(1.0).timeout
		$Thanks.visible = true
		
