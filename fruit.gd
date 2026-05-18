extends RigidBody2D

#var BaseSize:int
var fruitLevel = 1
#(4piA)/(p^2)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fruitLevel = fruitExtra.resize(self,fruitLevel - 1,false)
	gravity_scale = Autoload.gravity
	#var childref = $Visual.get_child(fruitLevel) as Sprite2D
	#var texture = childref.texture.get_image()
	#var bm = BitMap.new()
	#bm.create_from_image_alpha(texture)
	#print("size:" + str(bm.opaque_to_polygons(Rect2(Vector2.ZERO,bm.get_size())).size()))
	#var Poly = bm.opaque_to_polygons(Rect2(Vector2.ZERO,bm.get_size()),10)[0] as PackedVector2Array
	#Poly = fruitExtra.offsetPackedVector2Array(Poly,-texture.get_size()/2)
	#print("area: " + str(fruitExtra.areaOfAirregularPolygon(Poly)))
	#print("perimiter: " + str(fruitExtra.permOfApolygon(Poly)))
	#var Q = fruitExtra.similarityToCircle(Poly)
	#print("Q: " + str(Q))
	#var collisionRef
	#if(Q > 0.88):
		#$Polygon2D.queue_free()
		#var circleColl = CollisionShape2D.new()
		#var circle = CircleShape2D.new()
		#circle.radius = 50
		#circleColl.shape = circle
		##circleColl.global_scale = Vector2(100,100)
		#add_child(circleColl)
		#move_child(circleColl,1)
		#collisionRef = circleColl
		#print("made")
	#else:
		#collisionRef = $Polygon2Df
		#collisionRef.polygon = Poly
	##$Polygon2D.polygon = Geometry2D.merge_polygons(bm.opaque_to_polygons(Rect2(Vector2.ZERO,bm.get_size())))
	#collisionRef.global_scale = childref.global_scale
	#$Polygon2D.position =  childref.position

func _on_body_entered(body: Node) -> void:
	checkForMerges(self,body)
	if(body.is_in_group("kill")):
		Autoload.gameOver.emit()
	elif(body.is_in_group("win")):
		Autoload.win.emit()
		Autoload.gameOver.emit()
func checkWin(body):
	var newExp = Expression.new()
	newExp.parse(Autoload.expressionToWin,["score","fruitLevel"])
	var result = newExp.execute([Autoload.score,body.fruitLevel])
	if(newExp.has_execute_failed()):
		print("Error")
	else:
		if(typeof(result) == TYPE_BOOL):
			if(result):
				Autoload.win.emit()
				Autoload.gameOver.emit()
				
		else:
			print("error")
func checkForMerges(origin:Node,body: Node) -> void:
	if(body.is_in_group("fruit") and origin.is_in_group("fruit")):
		#var collisionShapeOther = body.get_child(1)
		##var othervisual = body.get_child(0)
		#var selfCollision = origin.get_child(1)
		##var selfvisual = origin.get_child(0)
		if(body.fruitLevel == origin.fruitLevel):
			if(origin.is_queued_for_deletion() == false and body.is_queued_for_deletion() == false):
				#if(origin.linear_velocity>body.linear_velocity):
				if(origin.global_position.y < body.global_position.y):
					origin.fruitLevel = fruitExtra.resize(origin,origin.fruitLevel)
					Autoload.score += origin.fruitLevel
					var collidedbodies = origin.get_colliding_bodies()
					for i in collidedbodies:
						checkForMerges(self,i)
					origin.linear_velocity = Vector2.ZERO
					body.queue_free()
					checkWin(origin)
				else:
					body.fruitLevel = fruitExtra.resize(body,body.fruitLevel)
					Autoload.score+=body.fruitLevel
					body.linear_velocity = Vector2.ZERO
					var collidedbodies = body.get_colliding_bodies()
					for i in collidedbodies:
						checkForMerges(body,i)
					checkWin(body)
					origin.queue_free()
