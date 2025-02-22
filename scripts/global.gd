extends Node

const SERVER_IP = "45.33.97.199"
var username = ""

enum POWERUP {
	SHIELD,
	SPEED,
	DAMAGE,
	RAILGUN,
	HEAL
}

var is_big_map_single: bool = false
var is_big_map_multi : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
