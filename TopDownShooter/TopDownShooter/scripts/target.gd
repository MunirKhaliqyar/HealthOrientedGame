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
		queue_free()#destroying target
		Globals.target_destroyed += 1
		Globals.playerXp += xpOnKill
		if Globals.playerXp >= Globals.xpForNextLevel:
			Globals.playerLevel += 1
			Globals.playerXp = 0
			Globals.xpForNextLevel += 25
			Globals.health = 100
	if area.collision_layer == 2:
		var bounce_direction = -velocity.normalized()
		var bounce_distance = bounce_strength + 100
		var bounce_duration = 0.8  # Adjust as necessary
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
		
