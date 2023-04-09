extends KinematicBody2D

var player = null
var velocity = Vector2.ZERO
var startingPoint = Vector2.ZERO
var wanderPoint = Vector2.ZERO

var rand = RandomNumberGenerator.new()

export(int) var ACCELERATION = 5000
export(float) var FRICTION = 0.9
export(int) var MAX_SPEED = 1000


func _ready():
	startingPoint = global_position
	wanderPoint = startingPoint

func _process(delta):
	if(player != null):
		var input_vector = -(global_position - player.global_position)
		input_vector = input_vector.normalized()
		
		if(input_vector != Vector2.ZERO):
			$AnimatedSprite.animation = "run"
			velocity += input_vector * ACCELERATION * delta
			velocity.clamped(MAX_SPEED)
			
		velocity *= FRICTION
	else:
		if(global_position.distance_to(wanderPoint) <= 5):
			wanderPoint = startingPoint + Vector2(rand.randi_range(0, 20), rand.randi_range(0, 20))
		
		var input = -(global_position - wanderPoint).normalized()
		
		$AnimatedSprite.animation = "run"
		
		velocity += input * ACCELERATION * delta
		velocity.clamped(MAX_SPEED)
		velocity *= FRICTION
	
	if velocity.x < 0:
		scale.x =  -1
	else:
		scale.x = 1
	
	$Pivot.rotation_degrees = atan2(velocity.y, velocity.x) * 180/PI + 90
	
	move_and_slide(velocity)

func _on_Vision_body_entered(body):
	player = body

func _on_Vision_body_exited(_body):
	player = null
