extends KinematicBody2D

var player = null
var velocity = Vector2.ZERO
var startingPoint = Vector2.ZERO
var wanderPoint = Vector2.ZERO

var rand = RandomNumberGenerator.new()

export(int) var ACCELERATION = 5000
export(float) var FRICTION = 0.9
export(int) var MAX_SPEED = 1000

onready var aTree = $AnimationTree
onready var state = aTree["parameters/playback"]

func _ready():
	startingPoint = global_position
	wanderPoint = startingPoint

func _process(delta):
	if(player != null):
		var input_vector = -(global_position - player.global_position)
		input_vector = input_vector.normalized()
		
		if(input_vector != Vector2.ZERO):
			state.travel("Run")
			aTree.set("parameters/Idle/blend_position", input_vector)
			aTree.set("parameters/Run/blend_position", input_vector)
			velocity += input_vector * ACCELERATION * delta
			velocity.clamped(MAX_SPEED)
			
		velocity *= FRICTION
	else:
		if(global_position.distance_to(wanderPoint) <= 5):
			wanderPoint = startingPoint + Vector2(rand.randi_range(0, 20), rand.randi_range(0, 20))
		
		var input = -(global_position - wanderPoint).normalized()
		
		state.travel("Run")
		aTree.set("parameters/Idle/blend_position", input)
		aTree.set("parameters/Run/blend_position", input)
		
		velocity += input * ACCELERATION * delta
		velocity.clamped(MAX_SPEED)
		velocity *= FRICTION
	
	$Pivot.rotation_degrees = atan2(velocity.y, velocity.x) * 180/PI + 90
	
	move_and_slide(velocity)

func _on_Vision_body_entered(body):
	player = body

func _on_Vision_body_exited(body):
	player = null
