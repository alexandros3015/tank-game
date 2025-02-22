extends Node

var spawn_locations

var choices = [
	Global.POWERUP.SHIELD, 
	Global.POWERUP.SPEED,
	Global.POWERUP.DAMAGE,
	Global.POWERUP.RAILGUN,
	Global.POWERUP.HEAL
]

const powerup_template = preload("res://scenes/powerup_template.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_locations = get_tree().get_nodes_in_group("spawn_point")
	
	$spawn_timer.wait_time = randf_range(5, 20)
	$spawn_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	var powerup = powerup_template.instantiate()
	
	powerup.powerup = choices.pick_random()
	powerup.sprite = load("res://assets/rwcircle.png")
	
	add_child(powerup)
	var new_position = spawn_locations.pick_random().global_position

	var overlap = false
	for child in get_children():
		if child.global_position == new_position:
			overlap = true
			break

	if overlap:
		new_position = spawn_locations.pick_random().global_position
		for child in get_children():
			if child.global_position == new_position:
				new_position = spawn_locations.pick_random().global_position

	powerup.global_position = new_position
			
	
	
	$spawn_timer.wait_time = randf_range(5, 20)
	$spawn_timer.start()
