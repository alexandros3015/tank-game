extends Control

var peer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.multiplayer_peer = null
	
	if OS.has_feature("dedicated_server"):
		host()
	
	multiplayer.connected_to_server.connect(_server_connected)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func host() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(6969, 2)
	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file.call_deferred("res://scenes/mainareaMULTIPLAER.tscn")

func join(ip: String) -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, 6969)
	multiplayer.multiplayer_peer = peer
	


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/mainarea.tscn")


func _on_close_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/settings.tscn")


func _on_connect_pressed() -> void:
	join($LineEdit.text)


func _on_host_pressed() -> void:
	host()

func _server_connected() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/mainareaMULTIPLAER.tscn")
