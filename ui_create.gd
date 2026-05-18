extends Node2D
#var allCollisionObj = []
var allData = {}
var polygon = []
const radiusOf = 10
var eventColl
const mapOf = ["normal","killzone","bp","fan","winzone"]
var buttonIsPressed = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoload.stateChange.connect(stateChange)
func stateChange():
	if(Autoload.state == "create"):
		show()
	else:
		if(Autoload.state == "campaign"):
			Autoload.levelInDevelopment = fruitExtra.createSaveString(Autoload.allCollisionObj)
			resetAllPoly()
			
			Autoload.allCollisionObj = fruitExtra.loadFrom(fruitExtra.campaignLevels[min(fruitExtra.campaignLevels.size()-1,Autoload.campaginLevel)]["level"],self)
		else:
			resetAllPoly()
			Autoload.allCollisionObj = fruitExtra.loadFrom(Autoload.levelInDevelopment,self)
		hide()
var timerReset = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func resetAllPoly() -> void:
	for i in fruitExtra.subElement(0,Autoload.allCollisionObj):
		i.queue_free()
	Autoload.allCollisionObj = []
func _process(delta: float) -> void:
	if(Autoload.state == "create"):
		if(Autoload.drawing):
			$"Cancel Polygon".show()
		else:
			$"Cancel Polygon".hide()
		if(buttonIsPressed):
				timerReset += delta
				if(timerReset > 1):
					timerReset = 0
					resetAllPoly()
		else:
			timerReset  = 0
		if(Input.is_action_just_pressed("click")):
			if(Autoload.drawing):
				var mousePos = get_viewport().get_mouse_position()
				if(polygon.size() < 1):
					polygon.append(mousePos)
					queue_redraw()
				elif(mousePos.distance_to(polygon[0])>radiusOf):
					polygon.append(mousePos)
					queue_redraw()
				else:
					_on_button_pressed()
		if(Input.is_action_just_pressed("clickActual")):
			var listOfRefToCLickables = [$S/load,$S/WinCon]
			var clickedOff = true
			for i in listOfRefToCLickables:
				if(i.get_global_rect().has_point(get_viewport().get_mouse_position())):
					clickedOff = false
					break
			if clickedOff:
				$S/load.release_focus()
				$S/WinCon.release_focus()
#TODO: GLobal Values don't match with Sliders 
func _on_button_pressed() -> void:
	if(Autoload.state == "create"):
		if(Autoload.drawing == false):
			Autoload.drawing = true
			for i in $S.get_children():
				if("disable" in i):
					i.disable = true
			$S.hide()
			polygon = []
		else:
			if(polygon.size() > 2):
				Autoload.drawing = false
				Autoload.allCollisionObj.append(fruitExtra.addNewPoly(polygon,$S/Bounce.value,$S/Friction.value,eventColl))
			print(fruitExtra.isSimple(polygon))
			for i in $S.get_children():
				if("disable" in i):
					i.disable = false
			$S.show()
			polygon = []
			Autoload.levelInDevelopment = fruitExtra.createSaveString(Autoload.allCollisionObj)
			queue_redraw()
			#queue_redraw()
func _draw() -> void:
	var color =Color(0.468, 0.583, 0.899, 1.0)
	var size= polygon.size()
	if(polygon.size() > 0):
		draw_circle(polygon[0],radiusOf,Color(0.5,0.5,0.5,0.5),true)
	if(size== 1):
		draw_circle(polygon[0],2,color)
	elif(size == 2):
		draw_line(polygon[0],polygon[1],color)
	elif(size > 2):
		draw_polyline(polygon,color)
		


func _on_back_pressed() -> void:
	cancelDrawing()
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


func _on_base_size_drag_ended(value_changed: bool) -> void:
	Autoload.ogsize = $S/BaseSize.value


func _on_reset_button_down() -> void:
	buttonIsPressed = true



func _on_reset_button_up() -> void:
	buttonIsPressed = false


func _on_save_toggled(toggled_on: bool) -> void:
	var childrenOf = $S/save.get_children()
	var tocall
	if(toggled_on):
		
		#var worldSettings = {"gravity":Autoload.gravity,"expressionToWin":Autoload.expressionToWin,"ogsize":Autoload.ogsize,"maxSpawnRate":Autoload.maxSpawnRate}
		#$S/save/saveText.text = JSON.stringify({"settings":worldSettings,"poly":subElement(1,allCollisionObj)})
		$S/save/saveText.text = fruitExtra.createSaveString(Autoload.allCollisionObj)
		tocall = "show"
	else:
		tocall = "hide"
	for i in childrenOf:
		i.call(tocall)

func _on_load_pressed() -> void:
	var textToAnalyse = $S/load.text 
	if(textToAnalyse!= ""):
		Autoload.allCollisionObj += fruitExtra.loadFrom(textToAnalyse,self)

func _on_collision_item_selected(index: int) -> void:
	eventColl = mapOf[index]

func _on_win_con_text_changed() -> void:
	var fruitLevel = 1
	var score = 100
	var newExp = Expression.new()
	newExp.parse($S/WinCon.text,["score","fruitLevel"])
	var result = newExp.execute([score,fruitLevel])
	if(newExp.has_execute_failed()):
		$S/WinCon/label.text = "Error"
	else:
		print(result)
		if(typeof(result) == TYPE_BOOL):
			$S/WinCon/label.text = "Success"
			Autoload.expressionToWin = $S/WinCon.text
		else:
			$S/WinCon/label.text = "Error"

func _on_cancel_polygon_pressed() -> void:
	cancelDrawing()
func cancelDrawing() -> void:
	polygon = []
	Autoload.drawing = false
	queue_redraw()
	for i in $S.get_children():
		if("disable" in i):
			i.disable = false
		$S.show()
		polygon = []
		queue_redraw()
