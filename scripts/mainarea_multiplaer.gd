extends Node2D

var players = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	OS.has_feature("dedicated_server")
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	
	if multiplayer.is_server():
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
	
	var player = load("res://scenes/tank_multiplaeer.tscn").instantiate()
	
	player.name = str(id)
	player.set_multiplayer_authority(id)
	add_child(player)
	
	player.position = Vector2(-364, 0)
	
	

func _on_peer_disconnected(id: int = 1):
	
	
	if multiplayer.is_server():
		players.erase(id)
		get_node(str(id)).queue_free()
	elif id == 1: 
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
		

func _exit_tree() -> void:
	multiplayer.multiplayer_peer.close()
