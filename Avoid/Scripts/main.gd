extends Node2D

var blobs : Array = []
@onready var blob_box: ColorRect = $blobBox

func _ready():
	# Set the shader parameters initially.
	update_shader()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# Add the click position to the list of blobs.
		var pos = get_local_mouse_position() / get_viewport_rect().size
		blobs.append(pos)
		
		# Update the shader parameters.
		update_shader()

func update_shader():
	# Get the shader material.
	var material = blob_box.get_material()
	
	# Set the blob positions.
	for i in range(blobs.size()):
		material.set_shader_param("blobs[%d]" % i, blobs[i])
