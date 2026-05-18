class_name obstacle extends StaticBody2D
var LineColor: Color
var held = false
var offsetClick = Vector2(0,0)
var mouseOn = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$poly/Line.default_color = LineColor
	$poly/Line.points = $poly.polygon + PackedVector2Array([$poly.polygon[0]])
	await get_tree().create_timer(0.3).timeout
	print("call")
	Autoload.stateChange.connect(stateChange)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

#TODO: fix bug where first clicked never works
#TODO add deletion of selection
func stateChange():
	if(Autoload.state != "create"):
		held = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Autoload.state == "create"):
		#if(mouseOn):
			#if(Input.is_action_just_pressed("clickActual") and Autoload.drawing == false):
				#held = true
				#offsetClick = get_global_mouse_position()
				##offsetClick = ogPoly[0] - get_global_mouse_position()
				##offset -= get_global_mouse_position()
		#if(Input.is_action_just_released("clickActual") or Autoload.drawing == true):
			#print("gone")
			##offset += offsetClick
			#held = false
			##global_position += offsetClick
		if(held):
			if(Input.is_action_pressed("clickActual") == false):
				#previousOffsets += get_global_mouse_position() - offsetClick
				held = false
				mouseOn = true
			else:
				global_position = get_global_mouse_position() + offsetClick
		print(global_position)
			#offset = offsetClick + get_global_mouse_position() + ogPoly[0]
#offset = offsetClick + get_global_mouse_position() + ogPoly[0]
		#for i in range($collision.polygon.size()):
			#$collision.polygon[i] = ogPoly[i] + offset - ogPoly[0]
		#for i in range($poly.polygon.size()):
			#$poly.polygon[i] = ogPoly[i] + offset - ogPoly[0]

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event is InputEventMouseButton):
		if(event.button_index == MOUSE_BUTTON_LEFT):
			if(event.pressed):
				print("pressed")
				if(mouseOn and Autoload.state == "create" and Autoload.drawing == false):
					offsetClick = global_position - get_global_mouse_position() #global_position +
					print(offsetClick)
					held = true
					global_position = get_global_mouse_position() + offsetClick# - previousOffsets
					print(global_position)
			else:
				#previousOffsets += get_global_mouse_position() - offsetClick
				held = false
				mouseOn = true
				print("realse")
				print(global_position)
func _on_mouse_entered() -> void:
	if(held == false):
		mouseOn = true
	print("now active")


func _on_mouse_exited() -> void:
	if(held == true):
		mouseOn = false
	print("mouse exited")
