extends Area2D
var mode = "bp"
var held = false
var offsetClick = Vector2(0,0)
var mouseOn = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoload.stateChange.connect(stateChange)
	await get_tree().create_timer(0.3).timeout
	print("call")
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
func stateChange():
	if(Autoload.state != "create"):
		held = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Autoload.state == "create"):
		if(held):
			if(Input.is_action_pressed("clickActual") == false):
				#previousOffsets += get_global_mouse_position() - offsetClick
				held = false
				mouseOn = true
			else:
				global_position = get_global_mouse_position() + offsetClick
		print(global_position)

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#for i in get_overlapping_bodies():
		#if(i.is_in_group("fruit")):
			#var fruitRef = i as RigidBody2D
			#fruitRef.apply_force(Vector2(0,-1000))
			#print(i)
func _physics_process(delta: float) -> void:
	if(mode == "fan"):
		for i in get_overlapping_bodies():
			if(i.is_in_group("fruit")):
				var fruitRef = i as RigidBody2D
				fruitRef.apply_force(Vector2(0,-10000))
func _on_body_entered(body: Node2D) -> void:
	if(mode == "bp" and body.is_in_group("fruit")):
		body.linear_velocity.y =-1000
