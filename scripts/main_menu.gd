extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.multiplayer_peer = null
	
	if OS.has_feature("dedicated_server"):
		get_tree().change_scene_to_file.call_deferred("res://scenes/multiplayer_menu.tscn")
		

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/mainarea.tscn")


func _on_close_pressed() -> void:
	get_tree().quit()


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/settings.tscn")


func _on_multiplayer_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/multiplayer_menu.tscn")


func _on_is_big_map_toggled(toggled_on: bool) -> void:
	Global.is_big_map_single = toggled_on
