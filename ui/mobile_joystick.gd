extends CanvasLayer

var move_vector = Vector2.ZERO
var joystick_active = false
var ongoing_drag = -1


func _input(event):
	if (
		event is InputEventScreenDrag
		or (event is InputEventScreenTouch and $TouchScreenButton.is_pressed())
	):
		if ongoing_drag == -1 or event.get_index() == ongoing_drag:
			move_vector = calculate_move_vector(event.position)
			joystick_active = true
			$Sprite2D.position = event.position
			limit_inner_circle(event.position)
			ongoing_drag = event.get_index()
	if event is InputEventScreenTouch and not event.pressed and event.get_index() == ongoing_drag:
		joystick_active = false
		$Sprite2D.position = Vector2(48, 137)
		ongoing_drag = -1


func calculate_move_vector(event_position):
	var texture_center = $TouchScreenButton.position + Vector2(34, 34)
	return (event_position - texture_center).normalized()


func get_value():
	return move_vector if joystick_active else Vector2.ZERO


func limit_inner_circle(event_position):
	var limit = 34
	var texture_center = $TouchScreenButton.position + Vector2(34, 34)
	if texture_center.distance_to(event_position) > limit:
		var limit_vector = move_vector * limit
		$Sprite2D.position = texture_center + limit_vector
	else:
		$Sprite2D.position = event_position
