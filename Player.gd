extends KinematicBody2D

var velocity = Vector2.ZERO

export(int) var ACCELERATION = 5000
export(float) var FRICTION = 0.9
export(int) var MAX_SPEED = 1000

func _process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("game_right") - Input.get_action_strength("game_left")
	input_vector.y = Input.get_action_strength("game_down") - Input.get_action_strength("game_up")
	input_vector.normalized()
	
	if(input_vector != Vector2.ZERO):
		velocity += input_vector * ACCELERATION * delta
		velocity.clamped(MAX_SPEED)
	else:
		pass
	velocity *= FRICTION
	
	velocity = move_and_slide(velocity)
