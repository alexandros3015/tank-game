extends Camera2D

@export var main_area : MainAreaMultiplayer

func _process(delta: float) -> void:
	
	if main_area.is_big_map && main_area.starting:
		var spectate_target = null
		
		for tank : MultiplayerTank in get_tree().get_nodes_in_group("tank"):
			if !tank.dead:
				spectate_target = tank
				break
		
		if spectate_target:
			global_position = spectate_target.global_position
