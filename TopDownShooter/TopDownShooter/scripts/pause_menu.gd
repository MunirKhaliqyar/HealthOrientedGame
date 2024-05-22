extends CanvasLayer

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://TopDownShooter/TopDownShooter/Scenes/main_menu.tscn")

func _on_resume_pressed():
	get_tree().paused = false
	queue_free()
