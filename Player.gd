extends CharacterBody2D

@export var move_speed : float = 200
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var sprite = $AnimatedSprite2D
@onready var input_direction = null
@onready var attacking = false
@onready var tween = create_tween()

func _physics_process(_delta):
	#get input direction from player
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	#move in direction from input at predefined speed
	velocity = input_direction * move_speed
	
	if Input.is_action_just_pressed("Attack"):
		attack()
	else:
		if attacking == false:
			move_animation()
		
	move_and_slide()
	
	#Need better way to trigger and control tweens for all attacks.
	tween.tween_property($AttackNode, "rotation", 2*PI, 10)


	
		

func attack():
	attacking = true
	if input_direction == Vector2(-1,0): 
		sprite.play("Attack_Left")
		await(sprite.animation_finished)
	elif input_direction == Vector2(1,0):
		sprite.play("Attack_Right")
		await(sprite.animation_finished)
	elif input_direction == Vector2(0,-1):
		sprite.play("Attack_Up")
		await(sprite.animation_finished)
	elif input_direction == Vector2(0,1):
		sprite.play("Attack_Down")
		await(sprite.animation_finished)
	else:
		sprite.play("Attack_Down")
		await(sprite.animation_finished)
	attacking = false


func move_animation():
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
