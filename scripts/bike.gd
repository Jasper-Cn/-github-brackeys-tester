extends CharacterBody2D

# X direction movement
const X_BACKWARDS_SLOW = .5
const DECEL_SPEED = 5
const BACKWARDS_MAX_SPEED = -200# rate at which you decelerate when spacebar is let go
const X_ACCEL = 100.0 # X direction acceleration
const MAX_SPEED = 300
const X_DECEL = 100 # rate at which you decelerate when spacebar is let go
# y deceleration speed
const Y_DECEL = 0.5

# if car is stunned stunned = 0, meaning that all acceleration is null
var stunned = false
const STUN_DURATION = 1.4

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var stun_timer: Timer = $"Stun Timer"

func _process(_delta: float) -> void:
	if Input.is_action_pressed("up") and velocity.y > 0:
		animated_sprite_2d.play("default")
	elif Input.is_action_pressed("down") and velocity.y < 0:
		animated_sprite_2d.play("default")
	elif Input.is_action_pressed("up"):
		animated_sprite_2d.play("turn_up")
	elif Input.is_action_pressed("down"):
		animated_sprite_2d.play("turn_down")
	elif velocity.x == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("default")
		
func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	if Input.is_action_pressed("forward"):
		animated_sprite_2d.play("default")
	elif Input.is_action_pressed("up"):
		velocity.y = clamp(velocity.y - X_ACCEL * delta, BACKWARDS_MAX_SPEED, MAX_SPEED) # Add the acceleration to the speed, but only until max speed
	else:
		velocity.y = clamp(velocity.y + X_ACCEL * delta, BACKWARDS_MAX_SPEED, MAX_SPEED) # Add the acceleration to the speed, but only until max speed
	move_and_slide()
	

func stun():
	
	stun_timer.wait_time = STUN_DURATION
	stun_timer.start()
	stunned = true


func _on_stun_timer_timeout() -> void:
	stunned = false
	
func _handle_movement(delta):
	# Handle forward movement.
	if Input.is_action_pressed("forward") and not stunned:
		velocity.x = clamp(velocity.x + X_ACCEL * delta, BACKWARDS_MAX_SPEED, MAX_SPEED) # Add the acceleration to the speed, but only until max speed
	elif Input.is_action_pressed("backward") and not stunned:
		velocity.x = clamp(velocity.x - X_ACCEL * X_BACKWARDS_SLOW * delta, BACKWARDS_MAX_SPEED, MAX_SPEED)
		if velocity.x > 0: # minor movement fix
			velocity.x = move_toward(velocity.x, 0, DECEL_SPEED) 
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL_SPEED)
	# Handle up/down movement
	if Input.is_action_pressed("up") and not stunned:
		velocity.y = clamp(velocity.y - X_ACCEL * delta, BACKWARDS_MAX_SPEED, MAX_SPEED) # Add the acceleration to the speed, but only until max speed
	elif Input.is_action_pressed("down") and not stunned:
		velocity.y = clamp(velocity.y + X_ACCEL * delta, BACKWARDS_MAX_SPEED, MAX_SPEED) # Add the acceleration to the speed, but only until max speed
	else:
		velocity.y = move_toward(velocity.y, 0, Y_DECEL) # moves velocity towards 0, slowing it down every from by 10 when not pressing up or down
	
