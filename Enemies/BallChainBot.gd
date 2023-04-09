extends KinematicBody2D

var player = null
var velocity = Vector2.ZERO
var insideHit = false
var cooldown = true

export(int) var ACCELERATION = 200
export(float) var FRICTION = 0.9
export(int) var MAX_SPEED = 200
export(int) var damage = 10

var alive = true

func _ready():
	$Sprite.set_animation("idle")
	$Attack2/CollisionShape2D2.disabled = true

func _process(delta):
	if(insideHit and cooldown and alive):
		velocity = Vector2.ZERO
		$Sprite.set_animation("attack")
		$Attack2/CollisionShape2D2.disabled = false
		cooldown = false
		$Attack.start(1)
		$AttackCooldown.start(2)
		
	if(player != null and !(insideHit and cooldown) and alive):
		var input_vector = Vector2.ZERO
		input_vector.x = (player.global_position - global_position).x
		input_vector = input_vector.normalized()
		velocity += input_vector * ACCELERATION * delta
		velocity.clamped(MAX_SPEED)
		velocity.x *= FRICTION
		if(input_vector.x < 0):
			$Sprite.flip_h = true
			$Attacking/CollisionShape2D.position.x = -27
			$Attack2/CollisionShape2D2.position.x = -27
		else:
			$Sprite.flip_h = false
			$Attacking/CollisionShape2D.position.x = 27
			$Attack2/CollisionShape2D2.position.x = 27
		
	velocity.y += 9
	move_and_slide(velocity)
	
func _on_Vision_body_entered(body):
	player = body

func _on_Attacking_body_entered(body):
	insideHit = true

func _on_Attack_timeout():
	$Attack2/CollisionShape2D2.disabled = true
	$Sprite.set_animation("idle")

func _on_AttackCooldown_timeout():
	cooldown = true

func _on_Attacking_body_exited(body):
	insideHit = false

func _on_Attack2_body_entered(body):
	body.take_damage(10)

func _on_DeathTimer_timeout():
	queue_free()

func _on_Hitbox_area_entered(area):
	alive = false
	$Sprite.animation = "death"
	$Sprite.frame = 0
	$Sprite.playing = true
	$DeathTimer.start(1/2)
