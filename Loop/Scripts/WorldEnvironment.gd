extends WorldEnvironment

# make export group of gradients
@export var gradients: Array[Gradient]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_env_gradient(stage_num: int):
	self.environment.adjustment_color_correction.gradient = gradients[stage_num]
