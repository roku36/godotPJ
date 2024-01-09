extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.value_changed.connect(_on_value_changed)

func _on_value_changed(val: float) -> void:
	Global.mouse_sensitivity = val
