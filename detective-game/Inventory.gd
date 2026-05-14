extends Node

signal inventory_updated

var items = []

func add_item(item_name):
	items.append(item_name)
	inventory_updated.emit()
	print("Inventory: ", items)
