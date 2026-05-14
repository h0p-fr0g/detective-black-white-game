extends Area2D

@export var item_name: String = "Hint A"
@export var item_texture: Texture2D 

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
	if body.name == "Player":
		player_in_range = true
		tooltip.text = "[E] " + item_name
		tooltip.show()

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		tooltip.hide()

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		pick_up()

func pick_up():
	if Inventory: 
		Inventory.add_item(item_name)
		print(item_name, " picked up!")	
		queue_free()
