extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://TopDownShooter/TopDownShooter/Scenes/target_practice.tscn")
	


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://TopDownShooter/TopDownShooter/Scenes/main_menu.tscn")
	

func _on_quit_button_pressed():
	get_tree().quit()


func _on_option_button_pressed():
	get_tree().change_scene_to_file("res://TopDownShooter/TopDownShooter/Scenes/option_menu.tscn")



