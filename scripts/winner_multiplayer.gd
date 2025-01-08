extends Label

var tstarted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func win_process():
	visible = true 
	
	disable_gameplay()
	
	$timer.start()
	
	tstarted = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !tstarted:
		var tanks = get_tree().get_nodes_in_group("tank")
		for i in range(0, tanks.size()):
			if tanks[i].hp <= 0:
				text = "PLAYER " + str(i+1) + " DIEDD LMAOOOO!!!!"
				win_process()

func disable_gameplay():
	for node in get_tree().get_nodes_in_group("tank"):
		node.set_process(false)
		node.set_physics_process(false)

func _on_timer_timeout() -> void:
	
	if OS.has_feature("dedicated_server"):
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
