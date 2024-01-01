extends ColorRect
# @onready var h_slider: HSlider = $"../HSlider"

var rotation_ratio: float = 0.0
var rotation_spd: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# rotation_ration is loop from 0 to 1
	# rotation_spd = h_slider.value
	rotation_ratio = fmod(rotation_ratio + delta * rotation_spd, 1.0)
	self.material.set_shader_parameter("rot_ratio", rotation_ratio)
	self.material.set_shader_parameter("rot_spd", rotation_spd)
