extends HSlider

@export var bus_name: String
var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	self.value_changed.connect(_on_value_changed)

	self.value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index),
	)

func _on_value_changed(val: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(val))
