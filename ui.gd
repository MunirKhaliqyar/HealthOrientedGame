extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TargetCounter/HBoxContainer/Label.text = str(Globals.target_destroyed)
	$grenadeUI/HBoxContainer/ProgressBar.value = Globals.reload_progress_grenade

func _on_button_pressed():
	get_tree().quit()
