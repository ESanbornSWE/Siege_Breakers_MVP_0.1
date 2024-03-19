extends CharacterBody2D

@export var move_speed : float = 200
@export var starting_driection : Vector2 = Vector2(0,1)

@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	velocity = input_direction * move_speed
	
	move_and_slide()
	
	if velocity == Vector2.ZERO:
		sprite.play("Idle_Down")
	else:
		if input_direction == Vector2(-1,0):
			sprite.play("Walk_Left")
		elif input_direction == Vector2(1,0):
			sprite.play("Walk_Right")
		elif input_direction == Vector2(0,-1):
			sprite.play("Walk_Up")
		elif input_direction == Vector2(0,1):
			sprite.play("Walk_Down")
		else:
			pass
	


func hitflash():
	var x = 0
	while (x < 5):
		sprite.hide()
		$Timer.start() #timers two ways
		await($Timer.timeout)
		sprite.show()
		await get_tree().create_timer(0.3).timeout
		x += 1
	pass


func _on_hurtbox_body_entered(body):
	hitflash()
	pass # Replace with function body.

func _on_timer_timeout():
	sprite.show()
