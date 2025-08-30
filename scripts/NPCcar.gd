extends Area2D
var front
const SPEED = 75
var direction = -1
@onready var bike: CharacterBody2D = $"../Bike"

func _process(delta: float) -> void:
	position.x += SPEED * delta * direction
	
func _on_body_entered(_body: Node2D) -> void:
	bike.stun()
