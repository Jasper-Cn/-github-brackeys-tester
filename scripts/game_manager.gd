extends Node
const START_SCREEN = preload("res://assets/start_screen.tscn")
@onready var timer: Timer = $"../UI elements/time label/Timer"
@onready var time_label: Label = $"../UI elements/time label"
@onready var money: Label = $"../UI elements/money"
const target_house_prefab = preload("res://scenes/target_house.tscn")
var delivery_time = 0
var house_distance = 10
var difficulty = 0.7 # smaller number = harder because less time
const base_payment = 5
var balance = 0
var time_remaining
var current_house_x = 124
var delivery_count = 1
const HOUSE_RANGE_MIN = 2
const HOUSE_RANGE_MAX = 10


func _ready() -> void:
	start_delivery(house_distance)
	for i in range(Global.DELIVERIES_PER_DAY):
		#print("house clone created")
		current_house_x += 144*randi_range(HOUSE_RANGE_MIN, HOUSE_RANGE_MAX)# Distance between houses
		var instance = target_house_prefab.instantiate()
		instance.position.x = current_house_x
		instance.position.y = -50
		get_parent().call_deferred("add_child", instance)
func _process(_delta: float) -> void:
	checkRespawn()
	time_remaining = int(ceil(timer.time_left))
	time_label.text = "Tip Timer: " + str(time_remaining)

# Run when you click the start button
func start_delivery(distance: int) -> void:
	delivery_time = distance * difficulty # Difficulty levels have not yet been implemented
	money.text = "$" + str(Global.coins) # Show money on screen
	timer.wait_time = int(delivery_time) # Set the amount of time you get per house
	timer.start()
	print("delivery started")

func _on_timer_timeout() -> void:
	print("No tips! You ran out of time.")
	timer.stop()
	time_label.add_theme_color_override("font_color", "red") 
	

func complete_delivery():
	timer.stop()
	balance += (base_payment + time_remaining * difficulty)
	Global.coins += balance
	money.text = "$" + str(Global.coins)
	time_label.add_theme_color_override("font_color", "black") 


# Reset button
func checkRespawn():
	if Input.is_action_just_pressed("reset"):
		print("resetting game")
		get_tree().reload_current_scene()
		Engine.time_scale = 1
