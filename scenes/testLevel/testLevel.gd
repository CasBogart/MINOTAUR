extends TileMapLayer

var player = preload("res://entities/player/player.tscn") # find player file and preload

func _ready():
	# instatiate player at this location
	player_inst(Vector2(0,0))

func player_inst(pos):
	# get an instance of the preload
	var playinst = player.instantiate()
	# set position to input pos
	playinst.position = pos
	# add as child
	add_child(playinst)
