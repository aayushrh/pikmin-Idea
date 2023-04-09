extends KinematicBody2D

var player = null
var velocity = Vector2.ZERO
var insideHit = false
var cooldown = true

export(int) var ACCELERATION = 5000
export(float) var FRICTION = 0.9
export(int) var MAX_SPEED = 1000
export(int) var damage = 10

func _ready():
	$AnimatedSprite.set_animation("idle")
	$Attack2/CollisionShape2D2.disabled = true

func _process(delta):
	if(insideHit and cooldown):
		velocity = Vector2.ZERO
		$AnimatedSprite.set_animation("attack2")
		$Attack2/CollisionShape2D2.disabled = false
		cooldown = false
		$Attack.start(1)
		$AttackCooldown.start(2)
		
	if(player != null and !(insideHit and cooldown)):
		var input_vector = Vector2.ZERO
		input_vector.x = (player.global_position - global_position).x
		input_vector = input_vector.normalized()
		velocity += input_vector * ACCELERATION * delta
		velocity.clamped(MAX_SPEED)
		velocity.x *= FRICTION
		#if(velocity.x < 0):
			#scale.x = -1
		#else:
			#scale.x = 1
		
	velocity.y += 9
	move_and_slide(velocity)
	
func _on_Vision_body_entered(body):
	player = body

func _on_Attacking_body_entered(body):
	insideHit = true

func _on_Attack_timeout():
	$Attack2/CollisionShape2D2.disabled = true
	$AnimatedSprite.set_animation("idle")

func _on_AttackCooldown_timeout():
	cooldown = true

func _on_Attacking_body_exited(body):
	insideHit = false

func _on_Attack2_body_entered(body):
	body.take_damage(10)
