extends Area2D

@onready var game_manager = $"../Game Manager"
@onready var deliveries_left: Label = $"../UI elements/deliveries left"
@onready var house_sprite: Sprite2D = $arrow
@onready var delivery_label = get_tree().get_root().get_node("game").get_node("%UI elements/delivery label")
@onready var timer: Timer = $"../UI elements/time label/Timer"


const BIKE = preload("res://scenes/bike.tscn")
const BLUE_ARROW = preload("res://assets/handmade/blue_arrow.webp")
const HOUSE_IMG = preload("res://assets/handmade/white_arrow.webp")
const GREEN_ARROW = preload("res://assets/handmade/green_arrow.webp")

var at_house = false # True when within range of a delivery house
var game_over_scene:PackedScene = load("res://scenes/end_screen.tscn")
var delivered = false # A value for each of the target houses

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# If you are at a house and you press deliver and you haven't already delivered to this house:
	if at_house and Input.is_action_just_pressed("deliver") and !delivered:
		game_manager.complete_delivery()
		delivered = true # Prevents player from spamming deliver at 1 house
		house_sprite.texture = GREEN_ARROW
		
		print ("delivery count ", game_manager.delivery_count)
		deliveries_left.text = "Deliveries Remaining: " + str(Global.DELIVERIES_PER_DAY - game_manager.delivery_count) # Set the on-screen text
		if game_manager.delivery_count == Global.DELIVERIES_PER_DAY:
			# If you have completed your deliveries for the day, move on to the next day.
			get_tree().change_scene_to_packed(game_over_scene)
			game_manager.delivery_count = 0
		else:
			# Stop the timer, add to the number of deliveries today, and restart the timer.
			timer.stop()
			game_manager.delivery_count += 1
			timer.wait_time = game_manager.delivery_time
			timer.start()

# When within range of the house, change arrow to blue.
func _on_body_entered(_body: Node2D) -> void:
	if !delivered:
		at_house = true
		house_sprite.texture = BLUE_ARROW 
		delivery_label.visible = true

# When exiting range of the house, change arrow back to defaul.
func _on_body_exited(_body: Node2D) -> void:
	if !delivered:
		at_house = false
		house_sprite.texture = HOUSE_IMG
		delivery_label.visible = false
