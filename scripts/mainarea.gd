extends Node2D

var spawn_positions: Array
@onready var sub_viewport1: SubViewport = $bigmapsplitscreen/HBoxContainer/tank_1view/SubViewport
@onready var sub_viewport2: SubViewport = $bigmapsplitscreen/HBoxContainer/tank_2view/SubViewport

const BIGMAP = preload("res://scenes/thicc_main_area_multiplayer.tscn")
const SMALLMAP = preload("res://scenes/main_area_template.tscn")

var tank = preload("res://scenes/tank1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	if Global.is_big_map_single:
		$camera.enabled = false
		var bigmap = BIGMAP.instantiate()
		sub_viewport1.add_child(bigmap)
		
		var world = sub_viewport1.find_world_2d()
		sub_viewport2.world_2d = world
	else:
		var smallmap = SMALLMAP.instantiate()
		add_child(smallmap)
		$bigmapsplitscreen.queue_free()
	
	spawn_positions = get_tree().get_nodes_in_group("spawn_point")
	
	spawn_players()
	



func spawn_players() -> void:
	for id in [1, 2]:
		var player: Tank = tank.instantiate()
	
		
		if id == 1:
			player.go_forward = "1forward"
			player.backward = "1backward"
			player.turn_base_right = "1tright"
			player.turn_base_left = "1tleft"
			player.turn_barrel_right = "1tbright"
			player.turn_barrel_left = "1tbleft"
			player.fire = "1fire"
		
		if id == 2:
			player.go_forward = "2forward"
			player.backward = "2backward"
			player.turn_base_right = "2tleft"
			player.turn_base_left = "2tright"
			player.turn_barrel_right = "2tbleft"
			player.turn_barrel_left = "2tbright"
			player.fire = "2fire"
	
		player.name = "Player "+str(id)
		
		var choice = spawn_positions.pick_random()
		
		player.position = choice.position
		spawn_positions.remove_at(spawn_positions.find(choice))
		
		if spawn_positions == []:
			spawn_positions = get_tree().get_nodes_in_group("spawn_point")
		
		if Global.is_big_map_single:
			if id == 1:
				sub_viewport1.add_child(player)
			elif id == 2:
				sub_viewport2.add_child(player)
		else:
			add_child(player)
		
