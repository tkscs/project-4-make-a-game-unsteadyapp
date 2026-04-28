class_name global extends Node
signal spawn(child)
var ogsize = 1
var score = 0
signal stateChange
var allCircle = true
var state = "main"
signal gameOver
var gravity = 2
var maxSpawnRate:float = 0.4
var clamps = [Vector2(0,0),Vector2(0,0)]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
