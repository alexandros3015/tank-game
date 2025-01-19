extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the 
		
	

func _on_getout_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
