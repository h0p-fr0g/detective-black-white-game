extends Area2D

@export var item_name: String = ""
@export var item_texture: Texture2D 
@export var pickable: bool
@export var investigatable: bool
@export var popup: PopupData
@export var is_locked: bool = false

@onready var tooltip = $Label
@onready var sprite = $Sprite2D

var player_in_range = false

func _ready():
	tooltip.hide()
	
	
	if item_texture:
		sprite.texture = item_texture
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if is_locked:
		return
	if body.name == "Player":
		player_in_range = true
		tooltip.text = "[E] " + item_name
		tooltip.show()

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		tooltip.hide()

func _process(_delta):
	if is_locked:
		return

	if player_in_range and Input.is_action_just_pressed("interact"):
		investigate()
		pick_up()
		
func investigate():
	if investigatable:
		SignalBus.popup_opened.emit(popup)

func pick_up(destroy_now: bool = true):
	if pickable:
		if Inventory: 
			Inventory.add_item(item_name, item_texture, popup)
			if destroy_now:
				queue_free()
