extends CharacterBody2D

@export var move_speed : float = 200
@export var direction : Vector2 = Vector2(0,1)

@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta):

	velocity = move_speed * direction
	if velocity == Vector2.ZERO:
		sprite.play("Idle_Down")
	else:
		if direction == Vector2(-1,0):
			sprite.play("Walk_Left")
		elif direction == Vector2(1,0):
			sprite.play("Walk_Right")
		elif direction == Vector2(0,-1):
			sprite.play("Walk_Up")
		elif direction == Vector2(0,1):
			sprite.play("Walk_Down")
		else:
			pass

	move_and_slide()
	
	pass




func _on_hurtbox_area_entered(area):
	pass


func _on_area_2d_body_entered(body):
	sprite.hide()
	pass # Replace with function body.


func _on_timer_timeout():
	if direction == Vector2(0,1):
		direction = Vector2(0,-1)
	else:
		direction = Vector2(0,1)
	$Timer.start()
	#timed_out = false
	#print("timeout called")
	
	
	pass # Replace with function body.
