extends Node2D
class_name MainAreaMultiplayer

var spawn_positions: Array
var players = {}

@export var is_big_map = true

const BIGMAP = preload("res://scenes/thicc_main_area_multiplayer.tscn")
const SMALLMAP = preload("res://scenes/main_area_template.tscn")

@export var starting = false
var tank = preload("res://scenes/tank_multiplaeer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if multiplayer.is_server():
		if is_big_map:
			var bigmap = BIGMAP.instantiate()
			add_child(bigmap)
		else:
			var smallmap = SMALLMAP.instantiate()
			add_child(smallmap)
	
	spawn_positions = get_tree().get_nodes_in_group("spawn_point")
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
	
	if starting: return
	show_ready.rpc_id(id)
	
	

func _on_peer_disconnected(id: int = 1):
	if multiplayer.is_server():
		players.erase(id)
		if get_node_or_null(str(id)): 
			get_node(str(id)).queue_free()
		
		if players.size() == 0:
			get_tree().quit()
		
	elif id == 1: 
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _exit_tree() -> void:
	if multiplayer.has_multiplayer_peer():
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
			spawn_positions = get_tree().get_nodes_in_group("spawn_point")
		
		if is_big_map:
			disable_camera.rpc_id(id)

@rpc("any_peer","call_local")
func disable_camera():
	$camera.enabled = false

@rpc("any_peer","call_local")
func enable_camera():
	$camera.enabled = true

@rpc("authority", "call_local")
func prepare() -> void:
	$HUD/ready.disabled = true
	$ready_timer.start()
	$"321".play()
	

@rpc("any_peer", "call_local")
func ready(ready: bool) -> void:
	if starting: return
	players[multiplayer.get_remote_sender_id()].ready = ready
		
		
	var is_everyone_ready = true
	for i in players:
		if players[i].ready == false: 
			is_everyone_ready = false
			break
			
	if is_everyone_ready:
		starting = true
		prepare.rpc()
	

func _on_ready_toggled(toggled_on: bool) -> void:
	ready.rpc_id(1, toggled_on)


func _on_ready_timer_timeout() -> void:
	$HUD/ready.hide()

	if multiplayer.is_server(): spawn_players()

@rpc("any_peer", "call_local")
func show_ready() -> void:
	$HUD/ready.show()
