extends Button

export(bool) var openLevel = true
export(bool) var startAtFirstLevel = false

var _sceneToOpen

func _ready():
	if openLevel:
		_sceneToOpen = Global.mainLevelPath
	else:
		_sceneToOpen = Global.mainMenuPath

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _pressed ():
	if startAtFirstLevel:
		LevelSelection.selectFirstLevel()
	
	get_tree().change_scene(_sceneToOpen)