extends Node

# class member variables go here, for example:
export(String) var _jsonLevelsPath = "res://Assets/Levels/JsonLevels"
export(String) var _jsonLevelFileName = "Level001.json"

export(String) var mainMenuPath = "res://Assets/Levels/MainMenu.tscn"
export(String) var mainLevelPath = "res://Assets/Levels/Level_Main.tscn"
export(String) var creditsScenePath = "res://Assets/UI/Screens/ScreenCredits.tscn"

export(String) var groundScenePath = "res://Assets/GridSystem/Cell/EmptyCell"
export(String) var groundSceneName = "GroundMesh.tscn"
export(String) var wallScenePath = "res://Assets/World/Walls"
export(String) var wallSceneName = "BasicCube.tscn"
export(String) var pickupScenePath = "res://Assets/World/Pickups"
export(String) var pickupSceneName = "Pickup.tscn"

var _masterVolume = 1.0

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func getLevelsPath():
	return self._jsonLevelsPath

func getLevelFileName():
	return self._jsonLevelFileName

func setLevelFileName(newFileName):
	self._jsonLevelFileName = newFileName


func getMasterVolume():
	return self._masterVolume

func setMasterVolume(newValue):
	
	self._masterVolume = newValue




func list_files_in_directory(path):
    var files = []
    var dir = Directory.new()
    dir.open(path)
    dir.list_dir_begin()

    while true:
        var file = dir.get_next()
        if file == "":
            break
        elif not file.begins_with("."):
            files.append(file)

    dir.list_dir_end()
    return files

func getLevelFileList():
	return list_files_in_directory(_jsonLevelsPath)