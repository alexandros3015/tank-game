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
		var alive_tanks: Array
		
		for tank in tanks:
			if not tank.dead:
				alive_tanks.append(tank)
		
		
		
		if alive_tanks.size() == 1 and tanks.size() > 1:
			text = str(alive_tanks[0].username.text) + " WINS!!!"
			
			win_process()
func disable_gameplay():
	pass

func _on_timer_timeout() -> void:
	
	if OS.has_feature("dedicated_server"):
		get_tree().quit()
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
