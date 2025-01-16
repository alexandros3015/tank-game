extends ItemList


var servers = {}

func _ready() -> void:
	if OS.has_feature("dedicated_server"): return
	
	load_servers()

func load_servers():
	$HTTPRequest.request("http://%s:8080/servers" % [Global.SERVER_IP])


func _on_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == 1:
		connect_to_server(servers[index])


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == OK:
		if response_code == 200:
			clear()
			servers = {}
			
			var json_body = JSON.parse_string(body.get_string_from_utf8())
			
			for server in json_body.servers:
				var id = add_item("%s; Max people: %s" % [server["name"], server["max_player"]])
				servers[id] = server["port"]
			
			
	await get_tree().create_timer(5, false).timeout
	load_servers()


func connect_to_server(port : int):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(Global.SERVER_IP, port)
	multiplayer.multiplayer_peer = peer
	
	get_tree().change_scene_to_file.call_deferred("res://scenes/mainareaMULTIPLAER.tscn")
