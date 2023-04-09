extends KinematicBody2D

var velocity = Vector2.ZERO

export(int) var ACCELERATION = 5000
export(float) var FRICTION = 0.9
export(int) var MAX_SPEED = 1000
export(int) var DASH_SPEED = 2000
export(float) var DASH_TIME = 1.5
export(float) var COYOTE_TIME = 1
export(int) var GRAVITY = 9
export(int) var JUMP = 350
export(int) var INITIAL_HEALTH = 100

var can_dash = true

var speedMult = 1

var playerState = "Move"

var health = INITIAL_HEALTH

onready var Bullet = preload("res://Player//Bullet.tscn")

onready var aTree = $AnimationTree
onready var state = aTree["parameters/playback"]

func _ready():
	aTree.active = true

func _process(delta):
	if(Input.is_action_just_pressed("shoot")):
		var vector = get_global_mouse_position() - global_position
		vector = vector.normalized()
		var bullet = Bullet.instance()
		bullet.global_position = global_position + Vector2(0, 4)
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
	var dir = 0
	if (vector.x >= 0):
		dir = 1
	else:
		dir = -1
	aTree.set("parameters/Attack/blend_position", dir)
	
	if(Input.is_action_just_pressed("attack")):
		state.travel("Attack")
		playerState = "Attack"
		#var timer = Timer.new()
		#timer.connect("timeout", self, "_on_SwordTimer_timeout")
		#timer.start(0.6)
		$SwordTimer.start(0.5)
	
	if(Input.is_action_just_pressed("dash") and can_dash):
		playerState = "Dash"
		can_dash = false
		$DashTimer.start(DASH_TIME/100)
	
	if (abs(velocity.y) <= 0.1):
		can_dash = true
		if(Input.is_action_just_pressed("jump")):
			velocity.y -= JUMP
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("game_right") - Input.get_action_strength("game_left")
	#input_vector.y = Input.get_action_strength("game_down") - Input.get_action_strength("game_up")
	input_vector.normalized()
	
	if(input_vector != Vector2.ZERO):
		state.travel("Run")
		aTree.set("parameters/Idle/blend_position", input_vector)
		aTree.set("parameters/Run/blend_position", input_vector.x)
		aTree.set("parameters/Dash/blend_position", input_vector.x)
		velocity += input_vector * ACCELERATION * delta
		velocity.clamped(MAX_SPEED)
		velocity *= speedMult
	else:
		state.travel("Idle")
	velocity.x *= FRICTION
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity)

func _dash(delta):
	state.travel("Dash")
	var dir = 0
	#var input_vector = (get_global_mouse_position() - global_position).normalized()
	var input_vector = Vector2(1,0)
	if (velocity.x >= 0):
		dir = 1
	else:
		dir = -1
	input_vector *= DASH_SPEED * 100 * dir
	move_and_slide(input_vector * delta)

func _on_DashTimer_timeout():
	playerState = "Move"

func take_damage(num):
	health -= num
	if(health <= 0):
		queue_free()
	print(health)
	
func _on_CoyoteTime_timeout():
	pass

func _on_SwordTimer_timeout():
	playerState = "Move"
