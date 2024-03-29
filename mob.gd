extends CharacterBody2D
#Idle movement isn't working, nor are animations while chasing. Probably need to adjust the animations like an animation player tree
#Chasing is at least working.
@export var move_speed : float = 25
@export var direction : Vector2 = Vector2(0,1)

@onready var sprite = $AnimatedSprite2D
@onready var player = get_tree().current_scene.get_node("Player")
@onready var target_position = null
var in_range = false
@onready var player_position = player.position
@onready var health = $HealthBar.value
@onready var parent_pos = get_tree().current_scene.get_node("Mob").position

func _physics_process(_delta):

	move()

	if velocity == Vector2.ZERO:
		sprite.play("Idle_Down")
	else:
		if direction.x < -0.1 && abs(direction.x) > abs(direction.y):
			sprite.play("Walk_Left")
		elif direction.x > -0.1 && abs(direction.x) > abs(direction.y):
			sprite.play("Walk_Right")
		elif direction.y < 0:
			sprite.play("Walk_Up")
		elif direction.y > 0:
			sprite.play("Walk_Down")
		else:
			pass

	move_and_slide()
	
	pass


func move():
	update_direction()
	velocity = move_speed * direction

func update_direction():

	if in_range == true:
		player_position = player.position
		direction = position.direction_to(player_position)
	else:
		if direction == Vector2(0,1):
			await get_tree().create_timer(1).timeout
			direction =  Vector2(0,-1)
		else:
			await get_tree().create_timer(1).timeout
			direction =  Vector2(0,1)


func damage():
	update_heatlh(-1)

func update_heatlh(update_val):
	$HealthBar.value += update_val
	if $HealthBar.value == 0:
		death()

func hitflash():
	var x = 0
	if $HealthBar.value > 0:
		while (x < 5):
			sprite.hide()
			await get_tree().create_timer(0.3).timeout
			sprite.show()
			await get_tree().create_timer(0.3).timeout
			x += 1
		pass
	else:
		pass

func _on_area_2d_body_entered(body):
	sprite.hide()
	pass # Replace with function body.


func _on_detection_body_entered(body):
	if body.name.match("Player"):
		in_range = true
		$Speak.text = "Rar!"
	else:
		pass

func _on_detection_body_exited(body):
	if body.name.match("Player"):
		in_range = false
		$Speak.text = "???"


func _on_hurtbox_area_entered(area):
	damage()
	hitflash()
	pass

func death():
	var scene = load("res://skel_death.tscn")
	var instance = scene.instantiate()
	add_child(instance)
	instance.position = parent_pos
	move_speed = 0
	$AnimatedSprite2D.hide()
	$Hurtbox.set_deferred("monitoring", false)
	$EnvCollision.set_deferred("disabled", true)
	await get_tree().create_timer(5).timeout
	queue_free()
