extends CanvasLayer


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	# if clicked, make unvisible
	if Input.is_action_just_pressed("click"):
		visible = false
	


func _on_texture_button_pressed() -> void:
		self.visible = true
