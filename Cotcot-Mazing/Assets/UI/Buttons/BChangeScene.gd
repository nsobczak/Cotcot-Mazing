extends Button

export(String) var sceneToOpen = "res://Assets/Levels/Level_Main.tscn"
export(bool) var startAtFirstLevel = false

func _ready():
	# Called when the node is added to the scene for the first time.
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _pressed ():
	if startAtFirstLevel:
		LevelSelection.selectFirstLevel()
	
	get_tree().change_scene(sceneToOpen)