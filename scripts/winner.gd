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
		if Global.hp1 <= 0:
			text = "PLAYER 2 WINS!!!"
			win_process()
		elif Global.hp2 <= 0:
			text = "PLAYER 1 WINS!!!"
			win_process()

func disable_gameplay():
	for node in get_tree().get_nodes_in_group("gameplay"):
		node.set_process(false)
		node.set_physics_process(false)

func _on_timer_timeout() -> void:
	
	Global.restore_state()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
