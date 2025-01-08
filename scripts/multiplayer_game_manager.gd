extends Node

var dedserv = OS.has_feature("dedicated_server")

var players = {}
var peer

var lobbyscene = preload("res://scenes/lobby.tscn")

var lobbylist = []
var onlobby = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if dedserv: Global.altconnect = true
	
	peer = ENetMultiplayerPeer.new()
	peer.create_server(6969, 2)
	multiplayer.multiplayer_peer = peer
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _peer_connected(id: int = 1) -> void:
	players[id] = {"name": "player"}
	
	if has_node(str(id)):
		print("A player with ID", id, "already exists.")
		return
	
	lobbylist[onlobby] = lobbyscene.instantiate()
	var current_lobby = lobbylist[onlobby]
	
	# Generate a unique lobby ID
	var candidate_lobby_id = randi_range(1000, 9999)
	while candidate_lobby_id in [lobby.lobbyid for lobby in lobbylist]:
		candidate_lobby_id = randi_range(1000, 9999)

	current_lobby.lobbyid = candidate_lobby_id

	add_child(current_lobby)
