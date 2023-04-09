extends KinematicBody2D

export(int) var speed = 1
export(int) var direction = 1


func _process(delta):
	var input_vector = Vector2(400,13100)
	input_vector.x *= speed * direction * delta
	move_and_slide(input_vector)
