extends StaticBody2D

@export var collision_shape_path : NodePath
# Variable to hold the CollisionShape2D

# Load the enemy scene
var enemy_scene = preload("res://target.tscn")

# Create a timer
var timer = Timer.new()

# Assuming you have a CollisionShape2D as a child of your StaticBody2D

var extents = Vector2()

func _process(delta):
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	var collision_shape = get_node(collision_shape_path)
	print("FIRST COLLISION" +str(collision_shape))
	
	
	#
	## Get the global position of the CollisionShape2D
	#var global_position = collision_shape.global_position
	#print("FIRST POSITION" + str(global_position))
	## Get the shape of the CollisionShape2D
	#var shape = collision_shape.global_scale
	#print("FIRST GLOBAL" + str(shape))
	## Get the shape of the CollisionShape2D
	#var shape2 = collision_shape.shape
	#print("SHAPE2" + str(collision_shape.shape))
	## Get the extents of the shape
	#var extents = shape2.extents
	#print("Extents: " + str(extents))
#
	## Calculate the actual size of the CollisionShape2D in the scene
	#var size = extents * 2
	#print("size" + str(size))
	#
	var shape = collision_shape.shape
	extents = shape.extents
#
	## The min and max values are the negative and positive extents, respectively
	#var min = -shape
	#var max = shape
	#print("Min: " + str(min))
	#print("Max: " + str(max))
	# Set the timer to call the spawn function after 2 seconds
	timer.wait_time = 2
	timer.one_shot = false
	# Connect the timeout signal to the spawn method
	timer.connect("timeout", Callable(self, "spawn"))
	add_child(timer)
	timer.start()



# Function to spawn an enemy
func spawn():
	# Instance the enemy scene
	var enemy = enemy_scene.instantiate()
	
	# Add the enemy to the current scene
	get_parent().add_child(enemy)
	
	

	var random_x = randf_range(-extents.x , extents.x)
	var random_y = randf_range(-extents.y , extents.y)
	enemy.global_position = self.global_position + Vector2(random_x, random_y)
	
	#print("x position" + str(enemy.global_position.x))
	#print("y position" + str(enemy.global_position.y))
	
	
