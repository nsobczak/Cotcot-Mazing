extends Button

export(String) var BLabel = "Credits"
export(String) var BCreator = "Creator: nsobczak"

func _ready():
	# Called when the node is added to the scene for the first time.
	pass

func _pressed ():
	if self.text == BLabel:
		self.text = BCreator
	else:
		self.text = BLabel