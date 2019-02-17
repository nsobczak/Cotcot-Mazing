extends Button

var _sceneToShow 

func _ready():
	# Called when the node is added to the scene for the first time.
	_sceneToShow = get_parent().find_node("EltLevelSelection")
	self.visible = true
	_sceneToShow.visible = false

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _pressed ():
	self.visible = false
	_sceneToShow.visible = true