extends Camera

onready var _grid = get_parent()

export(bool) var followPlayer = true
export(String) var playerNodeName = "Player"

func _followPlayer():
	var player = get_parent().find_node(playerNodeName)
	if player != null:
		self.transform.origin = Vector3(player.transform.origin.x,\
			self.transform.origin.y, player.transform.origin.z)
	
func _ready():
	# init camera position
	var xGridCenter = _grid.getRealGridSize().x / 2
	var yGridCenter = _grid.getRealGridSize().y / 2
	self.transform.origin = Vector3(yGridCenter, self.transform.origin.y, xGridCenter)

func _process(delta):
	# Called every frame. Delta is time since last frame.
	if followPlayer:
		_followPlayer()
	pass
