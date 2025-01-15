extends Control

var peer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		get_tree().change_scene_to_file("res://scenes/multiplayer/multiplayer_game_manager.tscn")
	multiplayer.multiplayer_peer = null
	
	multiplayer.connected_to_server.connect(_server_connected)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func host() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Global.mainip, 6969)
	multiplayer.multiplayer_peer = peer

func join(ip: String) -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, 6969)
	multiplayer.multiplayer_peer = peer
	


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/singleplayer/mainarea.tscn")


func _on_close_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/settings.tscn")


func _on_connect_pressed() -> void:
	join($LineEdit.text)


func _on_host_pressed() -> void:
	host()

func _server_connected() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/multiplayer/mainareaMULTIPLAER.tscn")
