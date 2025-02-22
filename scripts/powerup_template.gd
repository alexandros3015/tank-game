extends Area2D
class_name PowerupTemplate

@export var sprite: Texture2D
@export var powerup: Global.POWERUP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Tank:
		body.get_powerup(powerup)
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
