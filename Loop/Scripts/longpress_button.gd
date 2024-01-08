extends Button

@export var click_duration_threshold: float = 0.5

signal long_pressed
signal long_released
var __signal_sent: bool = false
var __last_duration: float = -1
var __current_duration: float = 0

func _process(delta: float) -> void:
	if is_pressed():
		__current_duration += delta

	else:
	# Emit the signal only once
		if __signal_sent:
			long_released.emit()
	
		__signal_sent = false
		__current_duration = 0.0

	_update_button()

func _update_button() -> void:
	if __last_duration != __current_duration:
		__last_duration = __current_duration

	if __last_duration > click_duration_threshold and not __signal_sent:
		__signal_sent = true
		long_pressed.emit()

	var value: float = 1.0 - clamp(__last_duration / click_duration_threshold, 0.0, 1.0)

	self.material.set_shader_parameter("loading", value)
