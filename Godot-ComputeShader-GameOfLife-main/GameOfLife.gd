extends TextureRect

var rd: RenderingDevice
var shader_file: RDShaderFile = preload("res://gol.glsl")
var shader: RID
var texture_read: RID
var texture_write: RID
var uniform_set: RID
var pipeline: RID
var read_data: PackedByteArray
var write_data: PackedByteArray
var image_size: Vector2i
var image_format := Image.FORMAT_RGBA8
@onready var fps_label = $fpsLabel

@export var ring_curve: Curve
@export var ring_range: int = 10 

func _ready() -> void:
	generate_ring()

	# We will be using our own RenderingDevice to handle the compute commands
	rd = RenderingServer.create_local_rendering_device()
	if not rd:
		set_process(false)
		print("Compute shaders are not available")
		return

	# Create shader and pipeline
	var shader_spirv := shader_file.get_spirv()
	shader = rd.shader_create_from_spirv(shader_spirv)
	pipeline = rd.compute_pipeline_create(shader)

	var og_image := self.texture.get_image()
	og_image.convert(image_format)
	image_size = og_image.get_size()

	# Data for compute shaders has to come as an array of bytes
	# Initialize read data
	read_data = og_image.get_data()

	var tex_read_format := RDTextureFormat.new()
	tex_read_format.width = image_size.x
	tex_read_format.height = image_size.y
	tex_read_format.depth = 4
	tex_read_format.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	tex_read_format.usage_bits = (
		RenderingDevice.TEXTURE_USAGE_STORAGE_BIT
		| RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT
	)
	var tex_view := RDTextureView.new()
	texture_read = rd.texture_create(tex_read_format, tex_view, [read_data])

	# Create uniform set using the read texture
	var read_uniform := RDUniform.new()
	read_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	read_uniform.binding = 0
	read_uniform.add_id(texture_read)

	# Initialize write data
	write_data = PackedByteArray()
	write_data.resize(read_data.size())

	var tex_write_format := RDTextureFormat.new()
	tex_write_format.width = image_size.x
	tex_write_format.height = image_size.y
	tex_write_format.depth = 4
	tex_write_format.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	tex_write_format.usage_bits = (
		RenderingDevice.TEXTURE_USAGE_STORAGE_BIT
		| RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT
		| RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	)
	texture_write = rd.texture_create(tex_write_format, tex_view, [write_data])

	# Create uniform set using the write texture
	var write_uniform := RDUniform.new()
	write_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	write_uniform.binding = 1
	write_uniform.add_id(texture_write)

	var ring_uniform := RDUniform.new()
	ring_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	ring_uniform.binding = 2
	ring_uniform.add_id(texture_read)

	uniform_set = rd.uniform_set_create([read_uniform, write_uniform, ring_uniform], shader, 0)

func generate_ring() -> void:
	var texSize: int = ring_range * 2 + 1
	var img: Image = Image.create(texSize, texSize, false, Image.FORMAT_L8)

	for x in range(0, texSize):
		for y in range(0, texSize):
			var dx: float = x -ring_range
			var dy: float = y -ring_range
			var distance: float = sqrt(dx * dx + dy * dy)
			if distance <=ring_range:
				var t: float = distance /ring_range
				var value: float = ring_curve.sample_baked(t)
				var color_val: int = int(value * 255)
				img.set_pixel(x, y, Color8(color_val, color_val, color_val))

	img.save_png("res://ring_texture.png")
	# var path = str("file://", ProjectSettings.globalize_path("user://"))
	# OS.shell_open(path)
	print("saved!!")
	

# func _on_timer_timeout() -> void:
func _process(delta):
	fps_label.text = str(Engine.get_frames_per_second())
	compute(delta)


func compute(delta) -> void:
	rd.texture_update(texture_read, 0, read_data)
	# Start compute list to start recording our compute commands
	var compute_list := rd.compute_list_begin()
	# Bind the pipeline, this tells the GPU what shader to use
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	# Binds the uniform set with the data we want to give our shader
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, image_size.x, image_size.y, 1)
	rd.compute_list_end()	# Tell the GPU we are done with this compute task
	rd.submit()	# Force the GPU to start our commands
	rd.sync()	# Force the CPU to wait for the GPU to finish with the recorded commands

	# Now we can grab our data from the texture
	read_data = rd.texture_get_data(texture_write, 0)
	var image := Image.create_from_data(image_size.x, image_size.y, false, image_format, read_data)
	texture = ImageTexture.create_from_image(image)

