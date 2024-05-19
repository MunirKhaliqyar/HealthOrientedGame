extends CharacterBody2D
@export var player_speed: float = 2600.0
@export var backward_speed_multiplier: float = 0.5

var max_ammo: int = Globals.maxAmmo 
var is_reloading: bool = false
var is_swapping_mag: bool = false
var is_idle: bool = false


signal laser_shot_from_player
signal grenade_shot_from_player

# Reference to the AnimatedSprite2D node
@onready var animated_sprite: AnimatedSprite2D = $CollisionPolygon2D/PlayerAnimatedSprite2D

# Adjust animation speeds
@export var default_animation_speed: float = 1.5
@export var shoot_animation_speed: float = 0.8

# Frame index for manual animation control
var shoot_frame_index: int = 0
var is_shooting: bool = false

func _ready():
	# Set initial animation speeds
	animated_sprite.speed_scale = default_animation_speed
	

func _process(_delta):
	var percentage_reload = ( $AmmoSwapTimer.wait_time - $AmmoSwapTimer.time_left) / $AmmoSwapTimer.wait_time 
	Globals.reload_progress_grenade = percentage_reload * 100
	
	if (Globals.maxAmmo - Globals.ammoCount) < Globals.maxAmmo and not is_swapping_mag and not is_idle:
		$IdleTimer.start()
		is_idle = true
		
	if Input.is_action_just_pressed("primary") and not is_reloading and not is_swapping_mag:	
		$IdleTimer.stop()
		is_idle = false
		is_shooting = true
		Globals.ammoCount += 1
		print(Globals.ammoCount)
		if Globals.ammoCount < max_ammo:
			shoot_frame_index = 0
			animated_sprite.play("Shoot")
			animated_sprite.speed_scale = 0  # Stop the automatic animation playback
		
			# Shoot
			var guntip_position: Vector2 = $guntip.global_position
			var mouse_position: Vector2 = get_global_mouse_position()
			var guntip_direction: Vector2 =  (mouse_position - guntip_position).normalized()
		
			laser_shot_from_player.emit(guntip_position, guntip_direction)
			is_reloading = true
			$Timer.start()
		else:
			is_swapping_mag = true
			$AmmoSwapTimer.start()
		
	#if Input.is_action_just_pressed("secondary") and not can_grenade:
		# Shoot
		#var guntip_position: Vector2 = $guntip.global_position
		#var mouse_position: Vector2 = get_global_mouse_position()
		#var guntip_direction: Vector2 =  (mouse_position - guntip_position).normalized()
		#print(guntip_direction)
		#grenade_shot_from_player.emit(guntip_position, guntip_direction)
		#can_grenade = true
		#$Timer2.start()
		
func calculate_reload_time(): 
	var remaining_bullets = Globals.maxAmmo - Globals.ammoCount
	var reload_time = 1.8  # Default reload time
	var reload_speed_multiplier = 1.0  # Default multiplier

	# Check if remaining bullets are less than max ammo
	if remaining_bullets < Globals.maxAmmo:
		# Calculate reload speed multiplier
		reload_speed_multiplier = 1.0 - (remaining_bullets / float(Globals.maxAmmo))

	# Calculate reload time based on multiplier
	reload_time *= reload_speed_multiplier
	return reload_time


# Speed up the timer for automatic reload
func speed_up_reload_timer():
	var reload_time = calculate_reload_time()
	$AmmoSwapTimer.wait_time = reload_time
	
func _physics_process(_delta):
	look_at(get_global_mouse_position())

	# Here, we use Input.get_action_strength to get input in all four directions.
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var speed = player_speed
	
	# Calculate the facing direction and movement direction
	var facing_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	var movement_direction: Vector2 = direction.normalized()
	
	# Calculate the dot product
	var dot_product: float = facing_direction.dot(movement_direction)
	
	# If moving backwards, reduce the speed
	if dot_product < 0:
		speed *= backward_speed_multiplier
	
	velocity = direction * speed
	move_and_slide()

	# Manually control the shooting animation frame
	if is_shooting:
		animated_sprite.frame = shoot_frame_index
		shoot_frame_index += 1
		if shoot_frame_index >= animated_sprite.sprite_frames.get_frame_count("Shoot"):
			is_shooting = false
			animated_sprite.play("Default")
			animated_sprite.speed_scale = default_animation_speed
		return  # Skip the rest of the animation logic while shooting
	
	# Set the animation based on player movement and reloading status
	if direction.length() > 0:
		animated_sprite.play("Default")
		animated_sprite.speed_scale = default_animation_speed
	else:
		animated_sprite.play("Default")
		animated_sprite.speed_scale = default_animation_speed
	
func _on_timer_timeout():
	is_reloading = false
	# Ensure the default animation is played after reloading
	if not is_shooting:
		if Input.get_vector("left", "right", "up", "down").length() > 0:
			animated_sprite.play("Default")
			animated_sprite.speed_scale = default_animation_speed
		else:
			animated_sprite.play("Default")
			animated_sprite.speed_scale = default_animation_speed
	# Speed up reload timer
	speed_up_reload_timer()

func _on_timer_2_timeout():
	Globals.ammoCount = 0
	is_swapping_mag = false
	# Speed up reload timer
	speed_up_reload_timer()

func _on_timer_3_timeout():
	$AmmoSwapTimer.start()
	is_swapping_mag = true
