extends VBoxContainer

# class member variables go here, for example:

var _labelPickup
var _player

func _ready():
	_labelPickup = find_node("LabelPickup")
	_player = get_parent().find_node("Player")


func _process(delta):
	if _player != null:
		_labelPickup.text = "Pickups: {0}".format([_player.getPickupNumber()])