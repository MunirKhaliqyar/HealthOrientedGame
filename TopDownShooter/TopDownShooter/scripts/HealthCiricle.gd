extends Node2D

@export var healthBonus: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.collision_layer == 1:
		if (Globals.health + healthBonus) > 100:
			Globals.health = 100
		else:
			Globals.health += healthBonus
	queue_free()
