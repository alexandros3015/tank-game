extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$p1info.text = ""
	$p2info.text = ""
	
	var tanks = get_tree().get_nodes_in_group("tank")
	for i in range(0, tanks.size()):
		var tank = tanks[i]
		if i % 2: 
			$p2info.text += "Tank: %s\nHealth: %s\nBullets: %s" % [i+1, tank.hp, tank.bullets]
		else:
			$p1info.text += "Tank: %s\nHealth: %s\nBullets: %s" % [i+1, tank.hp, tank.bullets]
		
	

func _on_getout_pressed() -> void:
	Global.restore_state()
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
