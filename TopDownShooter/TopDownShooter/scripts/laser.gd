extends Area2D

@export var speed: float = 2500


# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
func _ready():
	$Sprite2D.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta):
	rotation = direction.angle()
	position += direction * delta * speed
	$Sprite2D.visible = true


func _on_timer_timeout():
	
	queue_free()
