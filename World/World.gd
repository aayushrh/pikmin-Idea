extends Node2D

func _process(delta):
	var num = 17 - round($Player.health/(100/15))
	$CanvasLayer/Health.texture = load("res://Art//UCM Game Jam Art//health bar" + str(num) + ".png")
