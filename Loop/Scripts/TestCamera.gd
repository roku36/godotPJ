extends Camera2D

@export var node1_path: NodePath
@export var node2_path: NodePath
@onready var debug_label: Label = %DebugLabel

var node1: Node
var node2: Node

var margin: float = 400 

func _ready() -> void:
	node1 = get_node(node1_path)
	node2 = get_node(node2_path)

func _process(_delta: float) -> void:
	var position1: Vector2 = global_transform.affine_inverse() * node1.global_transform.origin
	var position2: Vector2 = global_transform.affine_inverse() * node2.global_transform.origin

	var distance: Vector2 = abs(position1 - position2) + Vector2(margin, margin)

	var screen_size: Vector2 = get_viewport_rect().size
	var zoom_level: float = min(screen_size.x/ distance.x, screen_size.y/ distance.y)

	zoom = Vector2(zoom_level, zoom_level)

	debug_label.text = "%04f, %04f" % [position1.x, position2.x]
	global_position = (node1.global_position + node2.global_position) / 2
