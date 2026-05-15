extends Control

@onready var grid = $GridContainer
"res://InventorySlot.tscn"
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
		
		grid.add_child(new_slot)
