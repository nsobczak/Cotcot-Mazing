extends HSlider

export(bool) var DEBUG = false

var _masterBusIndex

func _ready():
	_masterBusIndex = AudioServer.get_bus_index("Master")

func _process(delta):
	# Called every frame. Delta is time since last frame.
	if AudioServer.is_bus_mute(self._masterBusIndex):
		self.value = self.min_value
	else:
		self.value = AudioServer.get_bus_volume_db(self._masterBusIndex)


func _on_VolumeSlider_value_changed(value):
	if value <= self.min_value:
		if DEBUG:
			print("mute volume")
		AudioServer.set_bus_mute(_masterBusIndex, true)
	else:
		if DEBUG:
			print("unmute volume")
		AudioServer.set_bus_mute(_masterBusIndex, false)
		AudioServer.set_bus_volume_db(_masterBusIndex, value)
