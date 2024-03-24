extends CharacterBody2D
#Idle movement isn't working, nor are animations while chasing. Probably need to adjust the animations like an animation player tree
#Chasing is at least working.
@export var move_speed : float = 50
@export var direction : Vector2 = Vector2(0,1)

@onready var sprite = $AnimatedSprite2D
@onready var player = get_tree().current_scene.get_node("Player")
@onready var target_position = null
var in_range = false
@onready var player_position = player.position

func _physics_process(_delta):
	move()

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


func move():
	velocity = move_speed * direction
	if in_range == false:
		patrol()
	else:
		chase()

func _on_hurtbox_area_entered(area):
	hitflash()
	pass

func hitflash():
	var x = 0
	while (x < 5):
		sprite.hide()
		await get_tree().create_timer(0.3).timeout
		sprite.show()
		await get_tree().create_timer(0.3).timeout
		x += 1
	pass

func _on_area_2d_body_entered(body):
	sprite.hide()
	pass # Replace with function body.

func patrol():
	velocity = direction
	$Timer.start()
	_on_timer_timeout()
	pass

func chase():
	player_position = player.position
	direction = position.direction_to(player_position)

func _on_timer_timeout():
	if direction == Vector2(0,1):
		direction = Vector2(0,-1)
	else:
		direction = Vector2(0,1)
	$Timer.start()


func _on_detection_body_entered(body):
	if body.name.match("Player"):
		in_range = true
		$Speak.text = "Rar!"
	else:
		pass # Replace with function body.

func _on_detection_body_exited(body):
	if body.name.match("Player"):
		in_range = false
		$Speak.text = "???"
