extends ColorRect
@onready var camera_2d: Camera2D = $"../Camera2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# self.material.set_shader_param("rectPos", self.position)
	# self.material.set("shader_param/rectPos", -camera_2d.position.floor())
	print(camera_2d.position)
	
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = false if self.visible else true
