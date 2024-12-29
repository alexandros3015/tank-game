extends Node

var spawn_locations
var numof_spawn_locations: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_locations = get_tree().get_nodes_in_group("powerup_spawn")
	numof_spawn_locations = spawn_locations.size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
