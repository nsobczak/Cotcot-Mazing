extends Spatial

# class member variables go here, for example:
export(Vector3) var rotationAngles = Vector3(40, 40, 0)

var _value = 1


func getValue():
	return self._value

func setValue(newValue):
	self._value = newValue

func _ready():
	# Called when the node is added to the scene for the first time.
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	rotate_x(deg2rad(rotationAngles.x * delta))
	rotate_y(deg2rad(rotationAngles.y * delta))
	rotate_z(deg2rad(rotationAngles.z * delta))

