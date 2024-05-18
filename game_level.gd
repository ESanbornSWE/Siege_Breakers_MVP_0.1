extends Node2D

@export var mob_scene: PackedScene
var score = 0


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	
	mob.add_to_group("Mobs")
	mob.connect("mob_death", _on_mob_death)
	# Choose a random location on Path2D.
	var mob_spawn_location = $Mob_Path/Mob_Follow
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position

	$Mob_Parent.add_child(mob)


func _on_start_timer_timeout():
	$Mob_Timer.start()
	$Start_Timer.start()


func new_game():
	$HUD.update_score(0)
	$Player.position = Vector2(288, 288)
	$Player.reset()
	$HUD.show_message("Get Ready")
	score = 0
	$HUD.update_score(score)
	$Start_Timer.start()
	
func game_over():
	$HUD.show_game_over()
	await get_tree().create_timer(5).timeout
	get_tree().call_group("Mobs", "queue_free")
	$Mob_Timer.stop()
	$Start_Timer.stop()
	
func _on_mob_death():
	score += 5
	$HUD.update_score(score)

	

func _on_hud_start_game():
	new_game()


func _on_player_player_death():
	game_over()
