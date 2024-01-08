extends CanvasLayer
@onready var panel: Panel = $Panel

func _ready() -> void:
	pass


func _on_texture_button_toggled(toggled_on: bool) -> void:
	# if on, animate forwward, else animate back
	var tween: Tween = create_tween()
	if toggled_on:
		tween.tween_property(panel, "position", Vector2(0,0), 0.2)
	else:
		tween.tween_property(panel, "position", Vector2(-panel.size.x,0), 0.2)
