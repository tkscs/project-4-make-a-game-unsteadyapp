extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Autoload.state == "playing"):
		$Score.text = "Score: " + str(Autoload.score)


func _on_back_pressed() -> void:
	Autoload.state = "main"
	Autoload.gameOver.emit()
	Autoload.stateChange.emit()
