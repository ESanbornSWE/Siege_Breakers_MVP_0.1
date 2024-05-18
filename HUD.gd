extends CanvasLayer


signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$Message_Timer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $Message_Timer.timeout

	await get_tree().create_timer(1.0).timeout
	$Start_Button.show()

func update_score(score):
	$Score_Label.text = str(score)

func _on_start_button_pressed():
	$Start_Button.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
