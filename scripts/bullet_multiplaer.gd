extends Area2D

var boomsprite = preload("res://assets/boom.png")
var doing_owie = false

const SPEED = 500.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !multiplayer.is_server(): return
	if !doing_owie:
		var forward = Vector2(cos(rotation), sin(rotation))
		
		position += SPEED * delta * forward


func _on_body_entered(body: Node2D) -> void:
	if !multiplayer.is_server(): return
	
	if !doing_owie:
		if body is MultiplayerTank:
			body.hurt.rpc_id(body.name.to_int())
			owie.rpc()
		else:
			print("No hurt method found on: ", body)
			queue_free()
	

@rpc("authority", "call_local")
func owie() -> void:
	doing_owie = true
	$circle.scale = Vector2(.2, .2)
	rotation_degrees = 0
	$circle.texture = boomsprite
	$owie_timer.start()

func _on_kill_bullet_timer_timeout() -> void:
	if !multiplayer.is_server(): return
	queue_free()


func _on_owie_timer_timeout() -> void:
	if !multiplayer.is_server(): return
	queue_free()
