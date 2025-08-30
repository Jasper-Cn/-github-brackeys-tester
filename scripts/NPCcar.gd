extends RigidBody2D
var front
var speed
var direction = -1
@onready var bike: CharacterBody2D = $"../Bike"
const MINCARSPEED = 50
const MAXCARSPEED = 125

func _ready() -> void:
	speed = randf_range(MINCARSPEED, MAXCARSPEED)

func _process(delta: float) -> void:
	position.x += speed * delta * direction
	
func _on_body_entered(_body: Node2D) -> void:
	bike.stun()
	if _body is RigidBody2D:
		queue_free()
