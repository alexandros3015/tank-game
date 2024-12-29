extends Control

@onready var resolution_option: OptionButton = $resolution_option

var resolution: Vector2i

var resolution_dict: Dictionary = {
	"640x480": Vector2i(640, 480),
	"800x600": Vector2i(800, 600),
	"1024x768": Vector2i(1024, 768),
	"1280x720": Vector2i(1280, 720),
	"1366x768": Vector2i(1366, 768),
	"1600x900": Vector2i(1600, 900),
	"1920x1080": Vector2i(1920, 1080),
	"2560x1440": Vector2i(2560, 1440),
	"3200x1800": Vector2i(3200, 1800),
	"3840x2160": Vector2i(3840, 2160),
	"4096x2160": Vector2i(4096, 2160)
}

func _ready() -> void:
	# Populate resolution dropdown
	for name in resolution_dict.keys():
		resolution_option.add_item(name)

	# Set default resolution to 1920x1080
	resolution = resolution_dict["1920x1080"]
	resolution_option.select(5)

func _on_resolution_option_item_selected(index: int) -> void:
	# Change window size based on resolution
	var selected = resolution_option.get_item_text(index)
	resolution = resolution_dict.get(selected, Vector2i(1920, 1080))
	DisplayServer.window_set_size(resolution)
	print("New window size: ", resolution)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	# Toggle between fullscreen and windowed
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		print("Fullscreen mode enabled")
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(resolution)
		print("Windowed mode with resolution: ", resolution)

func _on_back_pressed() -> void:
	# Return to main menu
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
