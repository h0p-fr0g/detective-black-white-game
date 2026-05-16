extends Node

signal inventory_updated

var items = []

func add_item(item_name, item_icon, popup):
	var new_item = {
		"name": item_name,
		"icon": item_icon,
		"popup": popup
	}
	items.append(new_item)
	inventory_updated.emit()

func _on_slot_gui_input(event: InputEvent, item_data: Dictionary):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Auf Item geklickt: ", item_data["name"])
		
		# HIER DIE ANPASSUNG: Wir suchen nach "popup" (passend zu deiner Inventory.gd!)
		if item_data.has("popup") and item_data["popup"] != null:
			# Wir feuern die PopupData in deinen SignalBus
			SignalBus.popup_opened.emit(item_data["popup"])
		else:
			print("Dieses Item hat keine Popup-Details zum Untersuchen.")
