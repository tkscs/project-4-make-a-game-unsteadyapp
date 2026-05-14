class_name fruitExtra extends Node



#polygonIs.texture = 
static func levelToSize(level:int):
	var size = Autoload.ogsize
	for i in range(level):
		size = sizeAlg(size)
	return size
static func sizeAlg(size:float) -> float:
	return floor(size**1.02 + 1)
static func offsetPackedVector2Array(arr:PackedVector2Array, offs: Vector2):
	var newArr:PackedVector2Array = arr
	for i in range(arr.size()):
		newArr[i] = arr[i] + offs
	return newArr
static func similarityToCircle(polygon:PackedVector2Array):
	var perim = permOfApolygon(polygon)
	var area = areaOfAirregularPolygon(polygon)
	var Q = 4*PI*area/(perim**2)
	return Q
static func permOfApolygon(polygon:PackedVector2Array):
	#polygon.
	var dist = 0
	for i in range(polygon.size()):
		dist += polygon[i].distance_to(polygon[(i+1)%polygon.size()])
	return dist
static func subElement(index,arr):
	var new = []
	for i in arr:
		new.append(i[index])
	return new
static func loadFrom(textToAnalyse,ref):
	var objFromUserString = JSON.parse_string(textToAnalyse)
	var allCollisionObj = []
	if(typeof(objFromUserString) == TYPE_DICTIONARY):
		for i in objFromUserString["poly"]:
			print(i)
			for j in range(i["polygon"].size()):
				print(i["polygon"][j])
				i["polygon"][j] = str_to_var("Vector2" + i["polygon"][j] + "")
			allCollisionObj.append(fruitExtra.addNewPoly(i["polygon"],i["bounce"],i["friction"],i["collisionEvent"]))
		for j in objFromUserString["settings"]:
			ref.set("Autoload." + j, float(objFromUserString["settings"][j]))
	return allCollisionObj
static func createSaveString(allCollisionObj):
	var worldSettings = {"gravity":Autoload.gravity,"expressionToWin":Autoload.expressionToWin,"ogsize":Autoload.ogsize,"maxSpawnRate":Autoload.maxSpawnRate}
	return(JSON.stringify({"settings":worldSettings,"poly":subElement(1,allCollisionObj)}))
static func areaOfAirregularPolygon(polygon) -> float:
	var arrayOfTriIndices = Geometry2D.triangulate_polygon(polygon)
	var triangeAreas = []
	var totalArea = 0
	@warning_ignore("integer_division")
	for i in range(arrayOfTriIndices.size()/3):
		var xone = polygon[arrayOfTriIndices[i*3]][0]
		var xtwo = polygon[arrayOfTriIndices[i*3+1]][0]
		var xthree = polygon[arrayOfTriIndices[i*3+2]][0]
		var yone = polygon[arrayOfTriIndices[i*3]][1]
		var ytwo = polygon[arrayOfTriIndices[i*3+1]][1]
		var ythree = polygon[arrayOfTriIndices[i*3+2]][1]
		#var vectBetwOneAndTwo = abs(polygon[i] - polygon[i+1]) as Vector2
		#var vectBetwTwoAndThree = abs(polygon[i+1] - polygon[i+2]) as Vector2
		#var vectBetwOneAndThree = abs(polygon[i] - polygon[i+2]) as Vector2
		var sumed = 0.5*abs(xone*(ytwo-ythree) + xtwo*(ythree-yone) + xthree*(yone-ytwo))
		totalArea += sumed
		triangeAreas.append(sumed)
	return totalArea
static func resize(body,level:int,onlyVisual:bool = false):
	var visual = body.get_child(0) as Sprite2D
	var scaleTo = levelToSize(level)
	visual.scale = Vector2(0.187*floor(scaleTo),0.187*floor(scaleTo))
	visual.self_modulate = Color.from_hsv(float(floor(scaleTo))/10,1,1)
	var diffrentCostumes = visual.get_children() as Array[Sprite2D]
	for i in range(diffrentCostumes.size()):
		if(i != (level)%diffrentCostumes.size()):
			diffrentCostumes[i].visible = false
		else:
			diffrentCostumes[i].visible = true
	if(not onlyVisual):
		#body.get_child(1).scale = Vector2(floor(scaleTo),floor(scaleTo))
		var ogChild = body.get_child(0) as Sprite2D
		var childref = ogChild.get_child(level%ogChild.get_children().size()) as Sprite2D
		var texture = childref.texture.get_image()
		var bm = BitMap.new()
		bm.create_from_image_alpha(texture)
		var Poly = bm.opaque_to_polygons(Rect2(Vector2.ZERO,bm.get_size()),10)[0] as PackedVector2Array
		Poly = fruitExtra.offsetPackedVector2Array(Poly,-texture.get_size()/2)
		var Q = similarityToCircle(Poly)
		var collisionRef
		if(Q > 0.9 or (Autoload.allCircle == true and not (level == 2 or level == 3) )):
			body.get_child(1).queue_free()
			var circleColl = CollisionShape2D.new()
			var circle = CircleShape2D.new()
			circle.radius = 9.06 * scaleTo
			circleColl.shape = circle
			#circleColl.global_scale = Vector2(100,100)
			body.call_deferred("add_child",circleColl)
			body.call_deferred("move_child",circleColl,1)
			collisionRef = circleColl
			#collisionRef.scale = scaleTo
		else:
			body.get_child(1).queue_free()
			collisionRef = CollisionPolygon2D.new()
			collisionRef.polygon = Poly
			body.call_deferred("add_child",collisionRef)
			body.call_deferred("move_child",collisionRef,1)
			collisionRef.global_scale = childref.global_scale
		#$Polygon2D.polygon = Geometry2D.merge_polygons(bm.opaque_to_polygons(Rect2(Vector2.ZERO,bm.get_size())))
	return level + 1
# Called when the node enters the scene tree for the first time.
static func addNewPoly(polygon,bounce,friction,collisionEvent):
	if(polygon.size() > 1):
		var staticBody
		var polygonIs
		if(collisionEvent == "bp"):
			staticBody = preload("res://bouncepad.tscn").instantiate()
			polygonIs = staticBody.get_child(1) as Polygon2D
		elif(collisionEvent == "fan"):
			staticBody = preload("res://bouncepad.tscn").instantiate()
			polygonIs = staticBody.get_child(1) as Polygon2D
			staticBody.mode = "fan"
			var image = load("res://fruits/fan.png")
			#polygonIs.texture = ImageTexture.create_from_image(image)
			polygonIs.uv = polygon # * Transform2D(Vector2(0.01,0),Vector2(0.01,0),Vector2(0,0))
			print(polygonIs.uv)
		else:
			staticBody = preload("res://obstacle.tscn").instantiate()
			polygonIs = staticBody.get_child(1) as Polygon2D
			var line = polygonIs.get_child(0) as Line2D
			line.modulate = Color.from_hsv(bounce,friction,1)
			var physicsMaterialForObj = PhysicsMaterial.new()
			physicsMaterialForObj.bounce = bounce
			physicsMaterialForObj.friction = friction
			physicsMaterialForObj.rough = true
			staticBody.physics_material_override = physicsMaterialForObj
		var collisionShape = staticBody.get_child(0) as CollisionPolygon2D
		var newOBJ = obj.new()
		if(collisionEvent == "killzone"):
			polygonIs.color = Color(0.984, 0.055, 0.0, 1.0)
			staticBody.add_to_group("kill")
		elif(collisionEvent == "winzone"):
			polygonIs.color = Color(0.0, 0.718, 0.194, 1.0)
			staticBody.add_to_group("win")
		newOBJ.polyPoinnts = polygon
		polygonIs.polygon = polygon
		collisionShape.polygon = polygon
		Autoload.spawn.emit(staticBody)
		return [staticBody,{"polygon":polygon,"bounce":bounce,"friction":friction,"collisionEvent":collisionEvent}]
static func isSimple(polygon):
	for i in range(polygon.size()-1):
		var p1 = polygon[i%polygon.size()]
		var p2 = polygon[(i+1)%polygon.size()]
		for j in range(polygon.size()-1):
			var p1a = polygon[j%polygon.size()]
			var p2a = polygon[(j+1)%polygon.size()]
			if(p1 != p1a and p2 != p2a and p1 != p2a and p2 != p1a):
				var intersect = Geometry2D.segment_intersects_segment(p1,p2,p1a,p2a)
				if intersect != null:
					return false
	return true
