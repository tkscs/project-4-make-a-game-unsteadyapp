class_name fruitExtra extends Node

const campaignLevels = [
	{"name":"Level 1","level":"""{"poly":[{"bounce":0.0,"collisionEvent":null,"friction":0.3,"polygon":["(1103.0, 430.0)","(559.0, 1100.0)","(569.0, 1109.0)","(1116.0, 439.0)"]},{"bounce":0.0,"collisionEvent":null,"friction":0.3,"polygon":["(561.0, 1094.0)","(23.0, 447.0)","(17.0, 453.0)","(552.0, 1116.0)"]}],"settings":{"expressionToWin":"score>100","gravity":2,"maxSpawnRate":0.4,"ogsize":1}}"""},
	#{"name":"Level 2","level":"""{"poly":[{"bounce":0.0,"collisionEvent":"winzone","friction":0.3,"polygon":["(994.0, 1008.0)","(1140.0, 991.0)","(1132.0, 1050.0)","(971.0, 1117.0)"]},{"bounce":0.0,"collisionEvent":"normal","friction":0.3,"polygon":["(1100.0, 995.0)","(639.0, 709.0)","(419.0, 519.0)","(407.0, 605.0)","(992.0, 986.0)"]},{"bounce":0.0,"collisionEvent":"normal","friction":0.3,"polygon":["(387.0, 1137.0)","(470.0, 1011.0)","(556.0, 1127.0)","(620.0, 1037.0)","(663.0, 1106.0)","(722.0, 1063.0)","(759.0, 1106.0)","(809.0, 1069.0)","(848.0, 1101.0)","(891.0, 1121.0)"]}],"settings":{"expressionToWin":"false","gravity":2,"maxSpawnRate":0.4,"ogsize":1}}"""},
	{"name":"Level 2", "level":"""{"poly":[{"bounce":0.0,"collisionEvent":null,"friction":0.3,"polygon":["(406.0, 1131.0)","(492.0, 998.0)","(565.0, 1120.0)","(636.0, 1016.0)","(657.0, 1093.0)","(705.0, 1073.0)","(762.0, 1104.0)","(817.0, 1061.0)","(865.0, 1109.0)","(922.0, 1056.0)","(954.0, 1090.0)","(953.0, 1140.0)"]},{"bounce":0.0,"collisionEvent":null,"friction":0.3,"polygon":["(1123.0, 987.0)","(685.0, 701.0)","(1124.0, 826.0)"]},{"bounce":0.0,"collisionEvent":"winzone","friction":0.3,"polygon":["(1123.0, 1034.0)","(957.0, 1131.0)","(943.0, 1101.0)","(945.0, 1101.0)","(921.0, 1070.0)"]}],"settings":{"expressionToWin":"false","gravity":2,"maxSpawnRate":0.4,"ogsize":1}}"""},
	{"name":"Spam", "level":""""poly":[{"bounce":0.0,"collisionEvent":null,"friction":0.3,"polygon":["(36.0, 1110.0)","(573.0, 467.0)","(579.0, 1114.0)"]}],"settings":{"expressionToWin":"score>5000","gravity":10.0,"maxSpawnRate":0.02,"ogsize":1.0}}]"""}]

#polygonIs.texture = 
##converts a fruit level to a size
static func levelToSize(level:int) -> float:
	var size = Autoload.ogsize
	for i in range(level):
		size = sizeAlg(size)
	return size
##Runs the current size algorithm
static func sizeAlg(size:float) -> float:
	return floor(size**1.02 + 1)
##Loop through a packed vector2 array and offset it by a vector2
static func offsetPackedVector2Array(arr:PackedVector2Array, offs: Vector2):
	var newArr:PackedVector2Array = arr
	for i in range(arr.size()): 
		newArr[i] = arr[i] + offs
	return newArr
##checks a polygon's circle similairty
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
##return an array of all of the passed in array of index 
static func subElement(index:int,arr:Array):
	var new = []
	for i in arr:
		new.append(i[index])
	return new
##load from a string and return the collision objects
static func loadFrom(textToAnalyse,ref):
	if(textToAnalyse != ""):
		var objFromUserString = JSON.parse_string(textToAnalyse)
		var allCollisionObj = []
		if(typeof(objFromUserString) == TYPE_DICTIONARY):
			for i in objFromUserString["poly"]:
				print(i)
				for j in range(i["polygon"].size()):
					i["polygon"][j] = str_to_var("Vector2" + i["polygon"][j] + "")
				allCollisionObj.append(fruitExtra.addNewPoly(i["polygon"],i["bounce"],i["friction"],i["collisionEvent"]))
			for j in objFromUserString["settings"]:
				if(j == "expressionToWin"):
					Autoload.set(j, objFromUserString["settings"][j])
				else:
					print(j)
					Autoload.set(j, float(objFromUserString["settings"][j]))
				#ref.set("Autoload." + j, float(objFromUserString["settings"][j]))
		return allCollisionObj
	return []
static func createSaveString(allCollisionObj):
	"""takes a list of all collision objects"""
	var worldSettings = {"gravity":Autoload.gravity,"expressionToWin":Autoload.expressionToWin,"ogsize":Autoload.ogsize,"maxSpawnRate":Autoload.maxSpawnRate}
	var poly = subElement(1,allCollisionObj).duplicate(true)
	#var endingPolys = []
	var polyref = subElement(0,allCollisionObj).duplicate(true)
	for i in range(polyref.size()):
		print(polyref[i])
		print(poly[i]["polygon"])
		var h = Array(offsetPackedVector2Array(poly[i]["polygon"],Vector2(polyref[i].global_position)))
		print(h,poly[i]["polygon"])
		poly[i]["polygon"] = h
		print(poly[i]["polygon"])
	return(JSON.stringify({"settings":worldSettings,"poly":poly}))
static func areaOfAirregularPolygon(polygon) -> float:
	"""Calculate the area of a irregular polygon
	polygon: takes a polygon"""
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
##resize a body and children based on fruit level
static func resize(body,level:int,onlyVisual:bool = false) -> int:
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
##makes a new polygon and return a array with a refrence and then a dictionary containing stats
static func addNewPoly(polygon,bounce,friction,collisionEvent):
	if(polygon.size() > 1):
		var staticBody
		var polygonIs
		#bouncepad
		if(collisionEvent == "bp"):
			staticBody = preload("res://bouncepad.tscn").instantiate()
			polygonIs = staticBody.get_child(1) as Polygon2D
			var image = preload("res://otherArt/bouncepadImageTwo.png")
			polygonIs.texture = image
		elif(collisionEvent == "fan"):
			staticBody = preload("res://bouncepad.tscn").instantiate()
			polygonIs = staticBody.get_child(1) as Polygon2D
			staticBody.mode = "fan"
			var image = preload("res://otherArt/fan.png")
			polygonIs.texture = image
			#polygonIs.texture = ImageTexture.create_from_image(image)
			polygonIs.uv = polygon # * Transform2D(Vector2(0.01,0),Vector2(0.01,0),Vector2(0,0))
			print(polygonIs.uv)
		else:
			staticBody = preload("res://obstacle.tscn").instantiate() as obstacle
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
static func isSimple(polygon) -> bool:
	"""check if a polygon intersects itself and return a boolean"""
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
