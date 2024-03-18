extends Area2D

signal spawn_new_target

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_body_entered(_body):
	$Sprite2D.self_modulate = Color(1,1,1,.5) # Replace with function body.
	$Timer.start()


func _on_timer_timeout():
	spawn_new_target.emit()
	queue_free()#pass # Replace with function body.
