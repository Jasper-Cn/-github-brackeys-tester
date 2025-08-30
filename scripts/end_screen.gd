extends Node2D

const GAME = preload("res://scenes/game.tscn")
var game_scene:PackedScene = load("res://scenes/game.tscn")
@onready var button: Button = $Control/Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(_button_pressed)

func _button_pressed():
	print("Next delivery!")
	get_tree().change_scene_to_packed(game_scene)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("button"):
		get_tree().change_scene_to_packed(game_scene)
