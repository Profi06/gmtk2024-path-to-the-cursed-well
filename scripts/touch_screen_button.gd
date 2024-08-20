extends Control

@export
var action: String = ""
@export
var icon: CompressedTexture2D :
	set(val):
		icon = val
		%Icon.texture = icon
var moveable := false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate = Color.WHITE if Input.is_action_pressed(action) else Color.LIGHT_GRAY
	if moveable and Input.is_action_pressed(action):
		var diff = Input.get_vector("controller_move_ui_left", "controller_move_ui_right", 
				"controller_move_ui_up", "controller_move_ui_down") * 400.0 * delta
		if valid_test(Rect2(position + diff, size)) or not valid_test(Rect2(position, size)):
			position += diff

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and $Button.button_pressed and moveable:
		if valid_test(Rect2(position + event.relative, size)) or not valid_test(Rect2(position, size)):
			position += event.relative
	elif event.is_action_pressed("input_moveable"):
		moveable = true
	elif event.is_action_released("input_moveable"):
		moveable = false


func _on_button_button_down() -> void:
	input(true)


func _on_button_button_up() -> void:
	input(false)

func input(pressed: bool):
	if moveable:
		return
	var event = InputEventAction.new()
	event.action = action
	event.pressed = pressed
	Input.parse_input_event(event)

func valid_test(rect: Rect2) -> bool:
	if not get_viewport_rect().encloses(rect):
		return false
	for sib in get_parent().get_children():
		if sib != self and rect.intersects(Rect2(sib.position, sib.size)):
			return false
	return true
