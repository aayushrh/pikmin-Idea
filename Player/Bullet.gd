extends KinematicBody2D

export(int) var speed = 5000

var direction = Vector2.ZERO

func _process(delta):
	move_and_slide(direction * speed * delta)
