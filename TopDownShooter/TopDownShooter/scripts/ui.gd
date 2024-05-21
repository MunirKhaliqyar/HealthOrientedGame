extends CanvasLayer

var red_texture = preload("res://TopDownShooter/TopDownShooter/ui/progress_bar/progress3.png")
var yellow_texture = preload("res://TopDownShooter/TopDownShooter/ui/progress_bar/progress2.png")
var green_texture = preload("res://TopDownShooter/TopDownShooter/ui/progress_bar/progress.png")
var orange_texture = preload("res://TopDownShooter/TopDownShooter/ui/progress_bar/progress4.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TargetCounter/HBoxContainer/Label.text = "Kill:" + str(Globals.target_destroyed)
	$grenadeUI/HBoxContainer/ProgressBar.value = Globals.reload_progress_grenade
	$grenadeUI/HBoxContainer/TextureProgressBar.value = Globals.health
	var xpPercentage = (Globals.playerXp * 100) / Globals.xpForNextLevel
	$XpProgressBar.value = xpPercentage
	$XpProgressBar/Level.text = str(Globals.playerLevel)
	$grenadeUI/HBoxContainer/ProgressBar/AmmoCount.text = str(Globals.maxAmmo - Globals.ammoCount)
	if Globals.health < 30:
		$grenadeUI/HBoxContainer/TextureProgressBar.set_progress_texture(red_texture)
	elif Globals.health < 55:
		$grenadeUI/HBoxContainer/TextureProgressBar.set_progress_texture(orange_texture)
	elif Globals.health < 80:
		$grenadeUI/HBoxContainer/TextureProgressBar.set_progress_texture(yellow_texture)
	else:
		$grenadeUI/HBoxContainer/TextureProgressBar.set_progress_texture(green_texture)
func _on_button_pressed():
	get_tree().quit()
