extends Spatial

# class member variables go here, for example:


func _ready():
	# Called when the node is added to the scene for the first time.
	pass
	

func _process(delta):
	# Called every frame. Delta is time since last frame.
	if	Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
	pass
