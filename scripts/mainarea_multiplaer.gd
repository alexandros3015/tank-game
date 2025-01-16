extends Node2D

var spawn_positions: Array
var players = {}

var tank = preload("res://scenes/tank_multiplaeer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_positions = [$spawn_point1, $spawn_point2, $spawn_point3, $spawn_point4]
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	
	if multiplayer.is_server() and !OS.has_feature("dedicated_server"):
		_on_peer_connected()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_peer_connected(id: int = 1):
	if !multiplayer.is_server(): return
	
	players[id] = {"name": "player"}
	
	if has_node(str(id)):
		print("A player with ID", id, "already exists.")
		return
	
	var player: MultiplayerTank = tank.instantiate()
	
	
	player.name = str(id)
	player.set_multiplayer_authority(id)
	
	
	add_child(player)
	
	var choice = spawn_positions.pick_random()
	
	player.server_set_position.rpc_id(id, choice.position)
	spawn_positions.remove_at(spawn_positions.find(choice))
	
	if spawn_positions == []:
		spawn_positions = [$spawn_point1, $spawn_point2, $spawn_point3, $spawn_point4]

func _on_peer_disconnected(id: int = 1):
	if multiplayer.is_server():
		players.erase(id)
		get_node(str(id)).queue_free()
		
		if players.size() == 0:
			get_tree().quit()
		
	elif id == 1: 
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _exit_tree() -> void:
	multiplayer.multiplayer_peer.close()
