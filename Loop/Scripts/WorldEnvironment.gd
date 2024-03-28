extends WorldEnvironment

# export group of gradients
@export var gradients: Array[Gradient]
func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

func change_env_gradient(stage_num: int) -> void:
	self.environment.adjustment_color_correction.gradient = gradients[stage_num]
