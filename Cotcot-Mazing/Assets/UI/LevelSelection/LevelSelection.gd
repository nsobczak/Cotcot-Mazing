extends Node

# class member variables go here, for example:
export(bool) var DEBUG = false

var _levels
var _currentLevelIdx = 0
var _levelName


#_______________________________________________________
func getLevelName():
	return self._levelName

func updateLevelName():
	_levelName = _levels[_currentLevelIdx].split('.')[0]
	if DEBUG:
		print("_levelName: {0}".format([_levelName]))


func updateCurrentLevel():
	Global.setLevelFileName(_levels[_currentLevelIdx])
	updateLevelName()


#_______________________________________________________
func _ready():
	_levels = Global.getLevelFileList()

	updateCurrentLevel()


func changeLevelFileName(increase = true):
	if DEBUG:
		print("changeLevelFileName | len(_levels) = {0} | _currentLevelIdx = {1}".format(\
			[len(_levels), _currentLevelIdx]))

	if increase:
		_currentLevelIdx += 1
		if (_currentLevelIdx >= len(_levels)):
			_currentLevelIdx = 0

	else:
		_currentLevelIdx -= 1
		if _currentLevelIdx < 0:
			_currentLevelIdx = len(_levels) - 1
			
	updateCurrentLevel()

func selectFirstLevel():
	_currentLevelIdx = 0
	updateCurrentLevel()
	
func isFirstLevelSelected():
	return _currentLevelIdx == 0