extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$p1info.text = "Bullets: " + str(Global.bullets1) + "\nHP: " + str(Global.hp1)
	$p2info.text = "Bullets: " + str(Global.bullets2) + "\nHP: " + str(Global.hp2)
	

func _on_getout_pressed() -> void:
	Global.restore_state()
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	


func _on_edging_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/edging.tscn")
