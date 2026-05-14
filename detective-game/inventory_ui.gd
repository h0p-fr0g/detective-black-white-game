extends Control

@onready var list = $ItemList

func _ready():
	Inventory.inventory_updated.connect(refresh_ui)
	refresh_ui()

func refresh_ui():
	list.clear()
	for item in Inventory.items:
		list.add_item(item)
