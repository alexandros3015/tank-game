extends Area2D

var boomsprite = preload("res://assets/boom.png")
var doing_owie = false

const SPEED = 500.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !doing_owie:
		var forward = Vector2(cos(rotation), sin(rotation))
		
		position += SPEED * delta * forward


func _on_body_entered(body: Node2D) -> void:
	if !doing_owie:
		if body is Tank:
			body.hurt()
			owie()
		else:
			queue_free()
		
	
	
func owie() -> void:
	doing_owie = true
	$circle.scale = Vector2(.2, .2)
	rotation_degrees = 0
	$circle.texture = boomsprite
	$boom.play()
	$owie_timer.start()

func _on_kill_bullet_timer_timeout() -> void:
	queue_free()


func _on_owie_timer_timeout() -> void:
	queue_free()
