extends CharacterBody2D
@export var player_speed: float = 5500.0

var is_reloading :bool = false
var can_grenade: bool = false

signal laser_shot_from_player

signal grenade_shot_from_player
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _process(_delta):
	if Input.is_action_just_pressed("primary") and not is_reloading:
		#shoot
		var guntip_position: Vector2 = $guntip.global_position
		#print(guntip_position)
		var mouse_position: Vector2 = get_global_mouse_position()
		#print(mouse)
		var guntip_direction: Vector2 =  (mouse_position - guntip_position).normalized()
		
		laser_shot_from_player.emit(guntip_position, guntip_direction)
		is_reloading = true
		$Timer.start()
		
	if Input.is_action_just_pressed("secondary") and not can_grenade:
		#shoot
		
		#print("asdasd")
		var guntip_position: Vector2 = $guntip.global_position
		#print(guntip_position)
		var mouse_position: Vector2 = get_global_mouse_position()
		#print(mouse)
		var guntip_direction: Vector2 =  (mouse_position - guntip_position).normalized()
		print(guntip_direction)
		grenade_shot_from_player.emit(guntip_position, guntip_direction)
		can_grenade = true
		$Timer2.start()
		
	
	var percentage_reload = ( $Timer2.wait_time - $Timer2.time_left)/$Timer2.wait_time 
	
	Globals.reload_progress_grenade = percentage_reload*100
	
	
		
		
func _physics_process(_delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
	look_at(get_global_mouse_position())

# Here, we use Input.get_action_strength to get input in all four directions.
	var direction: Vector2 = Input.get_vector("left","right","up","down")
	velocity = direction * player_speed
	

	# Handle Jump.
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.


	move_and_slide()



func _on_timer_timeout():
	is_reloading = false # Replace with function body.


func _on_timer_2_timeout():
	can_grenade = false # Replace with function body.
