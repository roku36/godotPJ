extends HSlider


func _ready() -> void:
	self.value_changed.connect(_on_value_changed)

func _on_value_changed(val: float) -> void:
	Global.mouse_sensitivity = val
