extends Control

var peer
var is_big_map = false
var should_big_map = false

const main_area = preload("res://scenes/mainareaMULTIPLAER.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.multiplayer_peer = null
	
	if OS.has_feature("dedicated_server"):
		
		var args = get_cmd_args()
		print("args: ", args)
		var port = 6969
		if args.has("port"):
			port = args["port"]
		
		var max_clients = 3
		if args.has("max_clients"):
			max_clients = args["max_clients"]
			
		var is_big_map = false
		if args.has("big_map"):
			is_big_map = args['big_map']
		
		print("hosting on port ", port)
		host(port, max_clients, is_big_map)
	
	multiplayer.connected_to_server.connect(_server_connected)
	
	var file = FileAccess.open("user:///username.txt", FileAccess.READ)
	
	if file:
		Global.username = file.get_as_text()
		$username.text = file.get_as_text()
		file.close()
	
	

func host(port = 6969, max_clients = 2, is_big_mape: bool = true) -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port, max_clients)
	multiplayer.multiplayer_peer = peer
	
	var mainarea = main_area.instantiate()
	mainarea.is_big_map = is_big_mape
	
	get_tree().root.add_child(mainarea)
	queue_free()
	

func host_but_like_not():
	var usrname: String
	if $username.text == "":
		usrname = OS.get_environment("USERNAME")
	else:
		usrname = $username.text
		
	var max_clients: int = $max_clients.value
	
	$HTTPRequest.request("http://%s:8080/new" % [Global.SERVER_IP], [], HTTPClient.METHOD_POST, JSON.stringify({
		"name": name.strip_edges() + "'s Server",
		"max_players": max_clients,
		"public": 1,
		"big_map": 1 if should_big_map else 0
	}))



func join(ip: String, port : int = 6969) -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer





func _on_close_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/settings.tscn")


func _on_connect_pressed() -> void:
	join($LineEdit.text)


func _on_host_pressed() -> void:
	host_but_like_not()


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result == OK:
		if response_code == 200:
			var json_body = JSON.parse_string(body.get_string_from_utf8())
			
			join(Global.SERVER_IP, json_body["port"])


func _server_connected() -> void:
	
	get_tree().change_scene_to_file.call_deferred("res://scenes/mainareaMULTIPLAER.tscn")

func get_cmd_args() -> Dictionary:
	var result = {}
	var args = OS.get_cmdline_args()
	var i = 0
	
	while i < args.size():
		var arg = args[i]
		
		# Skip the executable path if present
		if i == 0 and not arg.begins_with("-"):
			i += 1
			continue
			
		if arg.begins_with("--") or arg.begins_with("-"):
			var key = arg.trim_prefix("--").trim_prefix("-")
			
			# Check if there's a value after the key
			if i + 1 < args.size() and not args[i + 1].begins_with("-"):
				var value = args[i + 1]
				
				# Try to convert numeric values
				if value.is_valid_int():
					value = value.to_int()
				elif value.is_valid_float():
					value = value.to_float()
				
				result[key] = value
				i += 2
			else:
				# Handle flags without values
				result[key] = true
				i += 1
		else:
			# Handle standalone arguments
			result["arg" + str(i)] = arg
			i += 1
			
	return result


func _on_username_text_changed(new_text: String) -> void:
	var file = FileAccess.open("user:///username.txt", FileAccess.WRITE)
	
	file.store_string($username.text)
	file.close()
	
	Global.username = $username.text


func _on_check_box_toggled(toggled_on: bool) -> void:
	should_big_map = toggled_on
