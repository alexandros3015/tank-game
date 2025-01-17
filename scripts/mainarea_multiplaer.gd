extends Node2D

var spawn_positions: Array
var players = {}

var starting = false
var tank = preload("res://scenes/tank_multiplaeer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_positions = [$spawn_point1, $spawn_point2, $spawn_point3, $spawn_point4]
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	
	
	if multiplayer.is_server() and !OS.has_feature("dedicated_server"):
		_on_peer_connected()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if starting: $HUD/ready.text = str(ceil($ready_timer.time_left))

func _on_peer_connected(id: int = 1):
	if !multiplayer.is_server(): return
	
	players[id] = {
		"name": "player",
		"ready": false
	}
	
	if has_node(str(id)):
		print("A player with ID", id, "already exists.")
		return
	
	

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

func spawn_players() -> void:
	for id in players:
		var player: MultiplayerTank = tank.instantiate()
	
	
		player.name = str(id)
		player.set_multiplayer_authority(id)
		
		
		add_child(player)
		
		var choice = spawn_positions.pick_random()
		
		player.server_set_position.rpc_id(id, choice.position)
		spawn_positions.remove_at(spawn_positions.find(choice))
		
		if spawn_positions == []:
			spawn_positions = [$spawn_point1, $spawn_point2, $spawn_point3, $spawn_point4]

@rpc("authority", "call_local")
func prepare() -> void:
	$HUD/ready.disabled = true
	
	starting = true
	$ready_timer.start()
	
	

@rpc("any_peer", "call_local")
func ready(ready: bool) -> void:
	players[multiplayer.get_remote_sender_id()].ready = ready
	
	
	var is_everyone_ready = true
	for i in players:
		if players[i].ready == false: 
			is_everyone_ready = false
			break
			
	if is_everyone_ready:
		prepare.rpc()
		

func _on_ready_toggled(toggled_on: bool) -> void:
	ready.rpc_id(1, toggled_on)


func _on_ready_timer_timeout() -> void:
	$HUD/ready.visible = false

	if multiplayer.is_server(): spawn_players()
