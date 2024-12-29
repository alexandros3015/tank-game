extends Area2D

const SPEED = 500.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var forward = Vector2(cos(rotation), sin(rotation))
	
	position += SPEED * delta * forward


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hurt1"):
		body.hurt1()
	elif body.has_method("hurt2"):
		body.hurt2()
	else:
		print("No hurt method found on: ", body)
	
	queue_free()


func _on_kill_bullet_timer_timeout() -> void:
	queue_free()
