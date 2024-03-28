extends Line2D

@onready var player: CharacterBody2D = %Player

# queue of trail points
var queue: Array[Vector2] = []
@export var MAX_QUEUE_LEN: int = 30
@export var trail_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if not Global.state == Global.STARTED:
		queue.clear()
		clear_points()
		return
	# relative pos from player
	var pos: Vector2 = player.global_position + player.transform.basis_xform(trail_offset)

	queue.push_front(pos)
	if queue.size() > MAX_QUEUE_LEN:
		queue.pop_back()

	clear_points()
	for p in queue:
		add_point(p)

