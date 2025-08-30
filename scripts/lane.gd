extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawner: Marker2D = $Spawner
@onready var parent_lane = get_node("../Lane")

var car_template = preload("res://scenes/NPCcar.tscn")

# Set possible min/max wait times for cars to spawn
const minSpawnTime: float = 4
const maxSpawnTime: float = 7

func _process(_delta: float) -> void:
	pass

func _ready() -> void:
	spawn_timer.start()

# Instaniates car at spawner node
func spawn_car():
	print("spawning car")
	var my_car = car_template.instantiate()
	my_car.position = spawner.position
	parent_lane.add_child(my_car)
 
# Spawns new car and restarts timer at random interval
func _on_spawn_timer_timeout() -> void:
	spawn_car()
	spawn_timer.wait_time = randf_range(minSpawnTime, maxSpawnTime)
	spawn_timer.start()
