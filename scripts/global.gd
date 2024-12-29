extends Node

var bullets1 = 10
var bullets2 = 10

var hp1 = 20
var hp2 = 20
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func restore_state():
	bullets1 = 10
	bullets2 = 10

	hp1 = 20
	hp2 = 20
