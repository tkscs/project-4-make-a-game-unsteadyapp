extends Node2D
#TODO: Add drag drop
#TODO: Support for polygons that interscect self

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoload.spawn.connect(add_children)
	Autoload.stateChange.emit()
	Autoload.gameOver.connect(gameO)

func add_children(child):
	add_child(child)
	move_child(child,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func gameO():
	Autoload.score = 0
	get_tree().call_group("fruit","queue_free")
	print("Game over")
	Autoload.state = "main"
	Autoload.stateChange.emit()
  
