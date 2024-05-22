extends Area2D

var sprites = [
	"res://TopDownShooter/TopDownShooter/Sprites/NoBG/1.png",
	"res://TopDownShooter/TopDownShooter/Sprites/NoBG/2.png",
	"res://TopDownShooter/TopDownShooter/Sprites/NoBG/3.png",
	"res://TopDownShooter/TopDownShooter/Sprites/NoBG/4.png",
	"res://TopDownShooter/TopDownShooter/Sprites/NoBG/5.png",
	"res://TopDownShooter/TopDownShooter/Sprites/NoBG/6.png",
	"res://TopDownShooter/TopDownShooter/Sprites/NoBG/7.png",
	"res://TopDownShooter/TopDownShooter/Sprites/NoBG/8.png"
]
# Assuming you have a Timer node as a child of your node
@export var xpOnKill = 10
# Load the explosion scene
@onready var ExplosionScene = preload("res://TopDownShooter/TopDownShooter/Scenes/explosion.tscn")
# Load explosion sound
@onready var ExplosionSound = preload("res://TopDownShooter/TopDownShooter/audio/explosion-6055.mp3")

var bounce_strength = 200 
var direction = Vector2() 
var velocity = Vector2()
var speed = 200  # Change this to the desired speed
#var tween 
# Called when the node enters the scene tree for the first time.
func _ready():
	#tween = get_tree().create_tween().bind_node(self)
		# Select a random sprite
	var sprite_path = sprites[randi() % sprites.size()]
	# Load the sprite path into a Texture object 
	var sprite = load(sprite_path)
	# Set the texture of the Sprite2D node
	$Sprite2D.texture = sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var player = get_tree().get_nodes_in_group("Scout")[0]
	direction = (player.global_position - global_position).normalized()	
	velocity = direction * speed 
	global_position += velocity * _delta
	#print("Target" + str(global_position))

func _on_area_entered(area):
	if area.collision_layer == 4:
		area.queue_free() #destroying laser
		die()
		Globals.target_destroyed += 1
		Globals.playerXp += xpOnKill
		if Globals.playerXp >= Globals.xpForNextLevel:
			Globals.playerLevel += 1
			if Globals.spawnDelay > 0.5:
				Globals.spawnDelay -= 0.5
			elif Globals.spawnDelay <= 0.5:
				if Globals.spawnDelay > 0.1:
					Globals.spawnDelay -= 0.1
			
			print(Globals.spawnDelay)
			Globals.playerXp = 0
			Globals.xpForNextLevel += 25
			Globals.health = 100
	if area.collision_layer == 2:
		var bounce_direction = -velocity.normalized()
		var bounce_distance = bounce_strength + 100 
		var bounce_duration = 0.2  # Adjust as necessary
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property(self, "global_position", global_position + bounce_direction * bounce_distance, bounce_duration)

func _on_body_entered(body):
	if body.collision_layer == 1:
		Globals.health -= 10
		var bounce_direction = -velocity.normalized()
		var bounce_distance = bounce_strength
		var bounce_duration = 0.2  # Adjust as necessary
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property(self, "global_position", global_position + bounce_direction * bounce_distance, bounce_duration)
		
func die():
	#Instantiate the explosion
	var explosion = ExplosionScene.instantiate()
	#Set the explosion position to the enemy's position
	explosion.global_position = global_position
	#Add the explosion to the scene
	get_tree().root.add_child(explosion)
	#Emit the particles
	explosion.emitting = true
	
	#Create and configure the explosion sound player
	var explosion_sound_player = AudioStreamPlayer.new()
	explosion_sound_player.stream = ExplosionSound
	explosion_sound_player.volume_db = -20
	get_tree().root.add_child(explosion_sound_player)
	explosion_sound_player.play()
	
	# Schedule to stop the sound after a short duration (e.g., 0.5 seconds)
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 1.5
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()
	add_child(timer)
	
	# Pass the explosion_sound_player to the timer timeout function
	explosion_sound_player.set_meta("to_be_stopped", true)
	timer.set_meta("sound_player", explosion_sound_player)
	
	#Remove the enemy
	queue_free()
