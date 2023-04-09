extends Node2D

func _on_Area2D_body_entered(body):
	body.speedMult *= 0.75

func _on_Area2D_body_exited(body):
	body.speedMult *= 1.33333333333333333
	
