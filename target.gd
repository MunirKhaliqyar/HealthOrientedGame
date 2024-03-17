extends Area2D

var sprites = [
	"res://Sprites/NoBG/1.png",
	"res://Sprites/NoBG/2.png",
	"res://Sprites/NoBG/3.png",
	"res://Sprites/NoBG/4.png",
	"res://Sprites/NoBG/5.png",
	"res://Sprites/NoBG/6.png",
	"res://Sprites/NoBG/7.png",
	"res://Sprites/NoBG/8.png"
]



var velocity = Vector2()
var speed = 200  # Change this to the desired speed
# Called when the node enters the scene tree for the first time.
func _ready():
		# Select a random sprite
	var sprite_path = sprites[randi() % sprites.size()]

	# Load the sprite path into a Texture object 
	var sprite = load(sprite_path)

	# Set the texture of the Sprite2D node
	$Sprite2D.texture = sprite
	# Replace with function body.
	print("READY")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var player = get_tree().get_nodes_in_group("Scout")[0]
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed 
	global_position += velocity * _delta
	#print("Target" + str(global_position))
	


func _on_area_entered(area):
	area.queue_free() #destroying laser
	print("Area entered, freeing target")
	queue_free()#destroying target
	Globals.target_destroyed += 1
