extends Node

signal inventory_updated

var items = []

func add_item(item_name, item_icon):
	var new_item = {
		"name": item_name,
		"icon": item_icon
	}
	items.append(new_item)
	inventory_updated.emit()
	print("Item collected: ", item_name)
