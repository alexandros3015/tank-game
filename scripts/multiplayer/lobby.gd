extends Panel

var lobbyid: int
var players = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$idtext.text = "ID: " + str(lobbyid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$playerlist.text = "Players: " + str(players)
