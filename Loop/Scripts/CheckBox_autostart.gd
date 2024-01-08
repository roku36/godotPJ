extends CheckBox

func _on_toggled(toggled_on: bool) -> void:
	Global.auto_start = toggled_on
