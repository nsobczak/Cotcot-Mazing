extends Spatial


#export(String) var jsonLevelFileName = "Level001.json"


func _ready():
	# Called when the node is added to the scene for the first time.
	var gridNode = find_node("Grid")


func _process(delta):
	# Called every frame. Delta is time since last frame.
	if	Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
	pass
