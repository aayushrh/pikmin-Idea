extends KinematicBody2D

export(int) var speed = 250

var direction = Vector2.ZERO

func _process(delta):
	move_and_slide(direction * speed * 75 * delta)

func _on_Wall_body_entered(body):
	queue_free()
