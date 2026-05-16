extends Control

@onready var grid = $GridContainer
@export var slot_scene: PackedScene 

func _ready():
	Inventory.inventory_updated.connect(refresh_ui)
	refresh_ui()

func refresh_ui():
	for child in grid.get_children():
		child.queue_free()
	
	for item in Inventory.items:
		var new_slot = TextureRect.new()
		new_slot.custom_minimum_size = Vector2(40, 40)
		new_slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		new_slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		new_slot.texture = item["icon"]
		new_slot.tooltip_text = item["name"]
		
		new_slot.mouse_filter = Control.MOUSE_FILTER_STOP
		
		new_slot.gui_input.connect(_on_slot_gui_input.bind(item))
		
		grid.add_child(new_slot)

func _on_slot_gui_input(event: InputEvent, item_data: Dictionary):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		if item_data.has("popup") and item_data["popup"] != null:
			SignalBus.popup_opened.emit(item_data["popup"])
		else:
			print("Dieses Item hat keine Popup-Details zum Untersuchen.")
