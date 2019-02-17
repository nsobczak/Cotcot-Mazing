extends Node

# class member variables go here, for example:
export(String) var _jsonLevelsPath = "res://Assets/Levels/JsonLevels"
export(String) var _jsonLevelFileName = "Level001.json"

func _ready():
	# Called when the node is added to the scene for the first time.
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