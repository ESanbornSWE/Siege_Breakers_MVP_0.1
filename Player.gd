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
	




func _on_hurtbox_area_entered(area):
	pass


func _on_hurtbox_body_entered(body):
	sprite.hide()
	#TODO add timer to disable this for a short time, blink character back into existence
	pass # Replace with function body.


func _on_hurtbox_body_exited(body):
	sprite.show()
	pass # Replace with function body.
