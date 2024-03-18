extends Node2D


var target_scene = preload("res://TopDownShooter/TopDownShooter/Scenes/target_2.tscn")


var grenade_scene: PackedScene = preload("res://TopDownShooter/TopDownShooter/Scenes/grenade.tscn")
	
	
var laser_scene: PackedScene = preload("res://TopDownShooter/TopDownShooter/Scenes/laser.tscn")
var menu_scene = preload("res://TopDownShooter/TopDownShooter/Scenes/pause_menu.tscn")
var is_menu_open = false

func _process(delta):
	if Input.is_action_pressed("pauseMenu") and not get_tree().paused:
		print("aawd")
		is_menu_open = true
		get_tree().paused = true
		var menu = menu_scene.instantiate()
		add_child(menu)
		

func _on_scout_laser_shot_from_player(guntip_position, guntip_direction):
	print("asd")
	var laser = laser_scene.instantiate() as Area2D # Replace with function body.
	#1position
	laser.position = guntip_position
	laser.direction = guntip_direction
	$Projectiles.add_child(laser)
	#2speed/direction



func _on_target_6_spawn_new_target():
	print("signal received")
	var new_target = target_scene.instantiate() as Area2D
	new_target.spawn_new_target.connect(_on_target_6_spawn_new_target)
	var random_position = Vector2 (randf_range (-7500,7500), randf_range (-7500,7500))
	new_target.position = random_position
# Add the node to the scene tree
	$".".add_child(new_target)


func _on_scout_grenade_shot_from_player(guntip_position, guntip_direction):
	print("signal received grenade") 
	var grenade = grenade_scene.instantiate() as RigidBody2D
	grenade.position = guntip_position
	#grenade.direction = guntip_direction
	var launch_force: float = 2500
	grenade.apply_impulse(guntip_direction*launch_force)
	$Projectiles.add_child(grenade)
	# Replace with function body.
