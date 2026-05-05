extends Node2D

var levelOfFruit = 0 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nextSize = getnextfruit()
	levelOfFruit = fruitExtra.resize(self,levelOfFruit,true)
@export var fruit_scence: PackedScene
var cooldown = 0
func getnextfruit():
	var rndm = RandomNumberGenerator.new()
	var weighted = PackedFloat32Array([100,50,25,12,6,3])
	var toTry = rndm.rand_weighted(weighted)
	levelOfFruit = toTry - 1
	var futuresize = Autoload.ogsize
	for i in randi_range(1,toTry):
		futuresize = fruitExtra.sizeAlg(futuresize)
	return floor(futuresize)
var nextSize
var baseY = 10
func _input(event: InputEvent) -> void:
	if(event.is_action("click") and Autoload.state == "playing" and event.pressed == false and Autoload.maxSpawnRate == 0):
		print(event.to_string())
		spawnFruit()
		print("spawn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Autoload.state == "playing" ):
		cooldown-=delta
		var mousePos = get_global_mouse_position()
		global_position = Vector2(float(mousePos[0]),10).clamp(Vector2(Autoload.clamps[0].x,baseY),Vector2(Autoload.clamps[1].x,baseY))
		if(Autoload.maxSpawnRate > 0):
			if(Input.is_action_pressed("click") and cooldown < 0):
				spawnFruit()
		
func spawnFruit():
	var fruitIns = fruit_scence.instantiate()
	#fruitIns.scale = Vector2(2,2)
	fruitIns.global_position = Vector2(global_position.x + randf_range(-5.0,5.0),10)
	#fruitIns.BaseSize = nextSize
	fruitIns.fruitLevel = levelOfFruit
	Autoload.spawn.emit(fruitIns)
	cooldown = Autoload.maxSpawnRate
	nextSize = getnextfruit()
	levelOfFruit = fruitExtra.resize(self,levelOfFruit,true)
