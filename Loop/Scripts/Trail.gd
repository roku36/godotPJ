extends Line2D

@onready var player: CharacterBody2D = %Player

var queue: Array[Vector2] = []
@export var MAX_QUEUE_LEN: int = 30
@export var trail_offset: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not Global.state == Global.STARTED:
		queue.clear()
		clear_points()
		return
	# get relatively 100 left from player positiion using player.rotation
	# var pos: Vector2 = player.global_position
	var pos: Vector2 = player.global_position + player.transform.basis_xform(trail_offset)
	# var pos: Vector2 = player.global_transform.basis_xform(Vector2(20, 50))
	# var pos: Vector2 = player.get_global_transform().basis_xform(Vector2(20, 50))

	queue.push_front(pos)
	if queue.size() > MAX_QUEUE_LEN:
		queue.pop_back()

	clear_points()
	for p in queue:
		add_point(p)

