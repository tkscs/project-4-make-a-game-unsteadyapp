class_name fruitExtra extends Node
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
static func areaOfAirregularPolygon(polygon) -> float:
	var arrayOfTriIndices = Geometry2D.triangulate_polygon(polygon)
	var triangeAreas = []
	var totalArea = 0
	print(arrayOfTriIndices.size())
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
	print("level: "+ str(level))
	var scaleTo = levelToSize(level)
	visual.scale = Vector2(0.187*floor(scaleTo),0.187*floor(scaleTo))
	print(scaleTo)
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
		print(level)
		var texture = childref.texture.get_image()
		var bm = BitMap.new()
		bm.create_from_image_alpha(texture)
		print("size:" + str(bm.opaque_to_polygons(Rect2(Vector2.ZERO,bm.get_size())).size()))
		var Poly = bm.opaque_to_polygons(Rect2(Vector2.ZERO,bm.get_size()),10)[0] as PackedVector2Array
		Poly = fruitExtra.offsetPackedVector2Array(Poly,-texture.get_size()/2)
		print("area: " + str(fruitExtra.areaOfAirregularPolygon(Poly)))
		print("perimiter: " + str(fruitExtra.permOfApolygon(Poly)))
		var Q = similarityToCircle(Poly)
		print("Q: " + str(Q))
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
			print("made")
		else:
			body.get_child(1).queue_free()
			collisionRef = CollisionPolygon2D.new()
			collisionRef.polygon = Poly
			body.call_deferred("add_child",collisionRef)
			body.call_deferred("move_child",collisionRef,1)
			collisionRef.global_scale = childref.global_scale
		#$Polygon2D.polygon = Geometry2D.merge_polygons(bm.opaque_to_polygons(Rect2(Vector2.ZERO,bm.get_size())))
	return level+1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
