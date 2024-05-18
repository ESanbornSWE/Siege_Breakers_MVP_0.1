extends CharacterBody2D

@export var move_speed : float = 150
@export var starting_direction : Vector2 = Vector2(0,1)

@onready var sprite = $AnimatedSprite2D
@onready var input_direction = null
@onready var attacking = false
@onready var health = $HealthBar.value

signal player_death

func _physics_process(_delta):
	#get input direction from player
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	#move in direction from input at predefined speed
	velocity = input_direction * move_speed
	
	if Input.is_action_just_pressed("Attack") && attacking == false:
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
	if $HealthBar.value > 0:
		$AttackNode/Attack/Axe.show()
		await get_tree().create_timer(.1).timeout
		$AttackNode/Attack/CollisionShape2D.disabled = false
		var tween = create_tween()
		attacking = true
		if sprite.animation == "Walk_Left": 
			$AttackNode.scale.x = 1
			$AttackNode.scale.y = 1
			$AttackNode.rotation = (PI/2)
			tween.tween_property($AttackNode, "rotation", (-PI/8), (.2))
			await(tween.finished)
		elif sprite.animation == "Walk_Right":
			$AttackNode.scale.x = -1
			$AttackNode.scale.y = 1
			$AttackNode.rotation = (-PI/2)
			tween.tween_property($AttackNode, "rotation", (PI/8), (.2))
			await(tween.finished)
		elif sprite.animation == "Walk_Up":
			$AttackNode.scale.x = -1
			$AttackNode.scale.y = -1
			$AttackNode.rotation = (0)
			tween.tween_property($AttackNode, "rotation", (-PI), (.2))
			await(tween.finished)
		elif sprite.animation == "Walk_Down":
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
		await get_tree().create_timer(0.1).timeout
		$AttackNode/Attack/Axe.hide()
		$AttackNode/Attack/CollisionShape2D.disabled = true
		attacking = false
	else:
		pass

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
	if $HealthBar.value > 0:
		while (x < 5):
			$Hurtbox/HurtboxShape.disabled = true
			sprite.hide()
			$Timer.start() #timers two ways
			await($Timer.timeout)
			sprite.show()
			await get_tree().create_timer(0.3).timeout
			x += 1
		$Hurtbox/HurtboxShape.disabled = false
		pass
	else:
		pass


func _on_hurtbox_body_entered(_body):
	damage()
	hitflash()
	pass

func damage():
	update_heatlh(-1)

func update_heatlh(update_val):
	$HealthBar.value += update_val
	if $HealthBar.value == 0:
		death()
	
func death():
	player_death.emit()
	var tween = create_tween().set_parallel(true)
	move_speed = 0
	$Hurtbox.set_deferred("monitoring", false)
	$EnvCollision.set_deferred("disabled", true)
	sprite.hide()
	$HealthBar.hide()
	$Sprite2D.show()
	tween.tween_property($Sprite2D, "rotation", (2*PI), (2))
	tween.tween_property($Sprite2D, "scale", Vector2(0,0), 2)
	
func reset():
	sprite.show()
	$HealthBar.value = $HealthBar.max_value
	$HealthBar.show()
	$Hurtbox.set_deferred("monitoring", true)
	$EnvCollision.set_deferred("disabled", false)
	move_speed = 150
	
