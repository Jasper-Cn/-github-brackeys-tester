extends Node2D

@export var front = true
@onready var spawn_timer: Timer = $SpawnTimer

var car_template = preload("res://scenes/NPCcar.tscn")

# Set possible min/max wait times for cars to spawn
const minSpawnTime: float = 5
const maxSpawnTime: float = 9
const STARTING_BEHIND_X = 100 # x that the car spawns behind the player


func _ready() -> void:
	if front:
		spawn_timer.wait_time = randf_range(minSpawnTime, maxSpawnTime*.5)
	else:
		spawn_timer.wait_time = randf_range(minSpawnTime, maxSpawnTime)
	spawn_timer.start()

# Instaniates car at spawner node
func spawn_car():
	var my_car = car_template.instantiate()
	if front:
		my_car.position.x = get_parent().get_parent().position.x + STARTING_BEHIND_X
	else:
		my_car.position.x = get_parent().get_parent().position.x - STARTING_BEHIND_X
	my_car.position.y = position.y
	# family tree be like
	get_parent().get_parent().get_parent().add_child(my_car)
	my_car.direction = 1
 
# Spawns new car and restarts timer at random interval
func _on_spawn_timer_timeout() -> void:
	spawn_car()
	if front:
		spawn_timer.wait_time = randf_range(minSpawnTime, maxSpawnTime*.5)
	else:
		spawn_timer.wait_time = randf_range(minSpawnTime, maxSpawnTime)
	spawn_timer.start()
