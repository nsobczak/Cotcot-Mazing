extends Button

export(String) var sceneToOpen = "res://Assets/Levels/Level_Main.tscn"

func _ready():
	# Called when the node is added to the scene for the first time.
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _pressed():
	LevelSelection.changeLevelFileName(true)
	
	if LevelSelection.isFirstLevelSelected():
		#last level has just been completed
		get_tree().change_scene(Global.creditsScenePath)
		
	else:
		get_tree().change_scene(sceneToOpen)