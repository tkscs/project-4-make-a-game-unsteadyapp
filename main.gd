extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoload.spawn.connect(add_children)
	Autoload.stateChange.emit()
	Autoload.gameOver.connect(gameO)

func add_children(child):
	add_child(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func gameO():
	Autoload.score = 0
	get_tree().call_group("fruit","queue_free")
	Autoload.state = "main"
	Autoload.stateChange.emit()
	print("hello")

  
