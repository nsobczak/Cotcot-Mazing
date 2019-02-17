extends Spatial

onready var _grid = get_parent()

var oldGridCellCoord
var currentGridCellCoord


#_________________________________________________________________________________________
func _ready():
	# Called when the node is added to the scene for the first time.
	#set_process_input(true)
	pass


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	pass


#_________________________________________________________________________________________
func updateCurrentCell(newCell):
	self.oldGridCellCoord = self.currentGridCellCoord
	self.currentGridCellCoord = newCell

