extends KinematicBody2D

var velocity = Vector2.ZERO

export(int) var ACCELERATION = 5000
export(float) var FRICTION = 0.9
export(int) var MAX_SPEED = 1000
export(int) var DASH_SPEED = 2000
export(float) var DASH_TIME = 1.5
export(float) var DASH_COOLDOWN = 1

var can_dash = true

var playerState = "Move"

onready var Bullet = preload("res://Player//Bullet.tscn")

onready var aTree = $AnimationTree
onready var state = aTree["parameters/playback"]

func _ready():
	aTree.active = true
	#state.travel("Attack")
	#playerState = "Attack"

func _process(delta):
	if(Input.is_action_just_pressed("shoot")):
		var vector = get_global_mouse_position() - global_position
		vector = vector.normalized()
		var bullet = Bullet.instance()
		bullet.global_position = global_position
		bullet.direction = vector
		get_tree().current_scene.add_child(bullet)
	if(playerState == "Move"):
		_move(delta)
	elif (playerState == "Dash"):
		_dash(delta)
	elif (playerState == "Attack"):
		_attack()
	
func _attack():
	state.travel("Attack")

func _move(delta):
	var vector = get_global_mouse_position() - global_position
	vector = vector.normalized()
	aTree.set("parameters/Attack/blend_position", vector)
	
	if(Input.is_action_just_pressed("attack")):
		state.travel("Attack")
		playerState = "Attack"
		$SwordTimer.start(0.5)
	
	if(Input.is_action_just_pressed("dash") and can_dash):
		playerState = "Dash"
		can_dash = false
		$DashTimer.start(DASH_TIME)
		$DashCooldown.start(DASH_COOLDOWN)
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("game_right") - Input.get_action_strength("game_left")
	input_vector.y = Input.get_action_strength("game_down") - Input.get_action_strength("game_up")
	input_vector.normalized()
	
	if(input_vector != Vector2.ZERO):
		state.travel("Run")
		aTree.set("parameters/Idle/blend_position", input_vector)
		aTree.set("parameters/Run/blend_position", input_vector)
		velocity += input_vector * ACCELERATION * delta
		velocity.clamped(MAX_SPEED)
	else:
		state.travel("Idle")
	velocity *= FRICTION
	
	velocity = move_and_slide(velocity)

func _dash(delta):
	var input_vector = velocity.normalized()
	input_vector *= DASH_SPEED * 100
	move_and_slide(input_vector * delta)

func _on_DashTimer_timeout():
	playerState = "Move"

func _on_DashCooldown_timeout():
	can_dash = true

func _on_SwordTimer_timeout():
	playerState = "Move"
