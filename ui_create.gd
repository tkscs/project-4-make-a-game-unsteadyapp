extends Node2D

var drawing = false
var polygon = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoload.stateChange.connect(stateChange)

func stateChange():
	if(Autoload.state == "create"):
		show()
	else:
		hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("click") and Autoload.state == "create"):
		if(drawing):
			var mousePos = get_viewport().get_mouse_position()
			polygon.append(mousePos)
			queue_redraw()
			print(mousePos)

func _on_button_pressed() -> void:
	if(Autoload.state == "create"):
		print("presssed")
		if(drawing == false):
			drawing = true
			polygon = []
		else:
			drawing = false
			print(polygon)
			if(polygon.size() > 1):
				var staticBody
				if($S/Bouncpad.button_pressed == true):
					staticBody = preload("res://bouncepad.tscn").instantiate()
				else:
					staticBody = preload("res://obstacle.tscn").instantiate()
					var physicsMaterialForObj = PhysicsMaterial.new()
					physicsMaterialForObj.bounce = $S/Bounce.value
					physicsMaterialForObj.friction = $S/Friction.value
					physicsMaterialForObj.rough = true
					staticBody.physics_material_override = physicsMaterialForObj
				var collisionShape = staticBody.get_child(0) as CollisionPolygon2D
				var polygonIs = staticBody.get_child(1) as Polygon2D
				var newOBJ = obj.new()
				if($S/Killzone.button_pressed == true):
					polygonIs.color = Color(0.368, 0.607, 0.884, 1.0)
					staticBody.add_to_group("kill")
				newOBJ.polyPoinnts = polygon
				polygonIs.polygon = polygon
				collisionShape.polygon = polygon
				polygon = []
				Autoload.spawn.emit(staticBody)
				queue_redraw()
				#queue_redraw()
func _draw() -> void:
	var color =Color(0.468, 0.583, 0.899, 1.0)
	var size= polygon.size()
	if(size== 1):
		draw_circle(polygon[0],2,color)
	elif(size == 2):
		draw_line(polygon[0],polygon[1],color)
	elif(size > 2):
		draw_polyline(polygon,color)


func _on_back_pressed() -> void:
	Autoload.state = "main"
	Autoload.stateChange.emit()


func _on_settings_pressed() -> void:
	if($S.visible == false):
		$S.show()
	else:
		$S.hide()




func _on_time_drag_ended(value_changed: bool) -> void:
	Autoload.maxSpawnRate = $S/Time.value


func _on_gravity_slider_drag_ended(value_changed: bool) -> void:
	Autoload.gravity = $S/GravitySlider.value
