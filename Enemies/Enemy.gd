extends KinematicBody2D

var player = null
var velocity = Vector2.ZERO
var startingPoint = Vector2.ZERO
var wanderPoint = Vector2.ZERO
var state = "idle"

var rand = RandomNumberGenerator.new()

export(int) var ACCELERATION = 5000
export(float) var FRICTION = 0.9
export(int) var MAX_SPEED = 1000
export(float) var ATTACK_RANGE = 100
export(float) var ATTACK_COOLDOWN = 1.0

onready var AttackTimer = $AttackTimer

func _ready():
	startingPoint = global_position
	wanderPoint = startingPoint
	#AttackTimer.wait_time = ATTACK_COOLDOWN
	#AttackTimer.start()


func _process(delta):
	update_state()
	
	match state:
		"idle":
			handle_wandering(delta)
		"attack":
			handle_player_movement(delta)
			if AttackTimer.is_stopped():
				attack_player()

	update_animation()
	update_pivot_rotation()
	
	velocity.y += 9
	
	move_and_slide(velocity)

func update_state():
	if player:
		state = "attack" if player.global_position.distance_to(global_position) < ATTACK_RANGE else "idle"
	else:
		state = "idle"

func handle_player_movement(delta):
	var input_vector = (player.global_position - global_position).normalized()
	input_vector.y = 0
	velocity += input_vector * ACCELERATION * delta
	velocity = velocity.clamped(MAX_SPEED)
	velocity *= FRICTION

func handle_wandering(delta):
	if global_position.distance_to(wanderPoint) <= 5:
		wanderPoint = startingPoint + Vector2(rand.randi_range(0, 20), rand.randi_range(0, 20))

	var input = (wanderPoint - global_position).normalized()
	velocity += input * ACCELERATION * delta
	velocity = velocity.clamped(MAX_SPEED)
	velocity *= FRICTION
	$Pivot.rotation_degrees += 1

func attack_player():
	# attack logic here, e.g., spawn a projectile or create a hitbox
	if player:
		var hitbox = Area2D.new()
		hitbox.set_collision_mask_bit(1, true)  # Assuming the player is on layer 1
		hitbox.set_collision_layer_bit(0, true)  # Set the hitbox to layer 0
		hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")

		var circle_shape = CircleShape2D.new()
		circle_shape.radius = 20
		
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = circle_shape

		hitbox.add_child(collision_shape)
		add_child(hitbox)

		yield(get_tree().create_timer(0.1), "timeout")  # Remove the hitbox after 0.1 seconds
		hitbox.queue_free()

		AttackTimer.start()

func update_animation():
	$AnimatedSprite.animation = "run" if velocity.length() > 0.1 else "idle"
	scale.x = 1 if velocity.x >= 0 else -1

func update_pivot_rotation():
	$Pivot.rotation_degrees = atan2(velocity.y, velocity.x) * 180 / PI + 90

func _on_Vision_body_entered(body):
	player = body

func _on_Vision_body_exited(_body):
	#player = null
	pass

func _on_Hitbox_body_entered(body):
	if body == player:
		# Apply damage to the player
		body.take_damage(10)

func _on_AttackTimer_timeout():
	# This method will be called when the AttackTimer times out
	pass
