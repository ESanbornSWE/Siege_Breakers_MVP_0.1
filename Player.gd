extends CharacterBody2D

@export var move_speed : float = 150
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var sprite = $AnimatedSprite2D
@onready var input_direction = null
@onready var attacking = false
@onready var health = $HealthBar.value

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
	
	#reset_rotation()
	move_and_slide()

	
func reset_rotation():
	await get_tree().create_timer(0.2).timeout
	$AttackNode.rotation = 0	

#replace sprite.play with sword creation and tweens for rotation.
func attack():
	$AttackNode/Attack/Axe.show()
	$AttackNode/Attack/CollisionShape2D.disabled = false
	var tween = create_tween()
	attacking = true
	if input_direction == Vector2(-1,0): 
		$AttackNode.scale.x = 1
		$AttackNode.scale.y = 1
		$AttackNode.rotation = (PI/2)
		tween.tween_property($AttackNode, "rotation", (-PI/8), (.3))
		await(tween.finished)
	elif input_direction == Vector2(1,0):
		$AttackNode.scale.x = -1
		$AttackNode.scale.y = 1
		$AttackNode.rotation = (-PI/2)
		tween.tween_property($AttackNode, "rotation", (PI/8), (.3))
		await(tween.finished)
	elif input_direction == Vector2(0,-1):
		$AttackNode.scale.x = -1
		$AttackNode.scale.y = -1
		$AttackNode.rotation = (0)
		tween.tween_property($AttackNode, "rotation", (-PI), (.3))
		await(tween.finished)
	elif input_direction == Vector2(0,1):
		$AttackNode.scale.x = 1
		$AttackNode.scale.y = 1
		$AttackNode.rotation = (0)
		tween.tween_property($AttackNode, "rotation", -PI, (.2))
		await(tween.finished)
	else:
		$AttackNode.scale.x = 1
		$AttackNode.scale.y = 1
		$AttackNode.rotation = (0)
		tween.tween_property($AttackNode, "rotation", -PI, (.2))
		await(tween.finished)
	attacking = false
	await get_tree().create_timer(0.15).timeout
	$AttackNode/Attack/Axe.hide()
	$AttackNode/Attack/CollisionShape2D.disabled = true

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
	damage()
	pass

func damage():
	update_heatlh(-1)

func update_heatlh(update_val):
	$HealthBar.value += update_val
