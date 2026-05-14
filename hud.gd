extends CanvasLayer

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if(Autoload.state == "playing" or Autoload.state == "campaign"):
		$Score.text = "Score: " + str(Autoload.score)
		$"Win condition".text ="Win condition: " + Autoload.expressionToWin


func _on_back_pressed() -> void:
	Autoload.state = "main"
	Autoload.gameOver.emit()
	Autoload.stateChange.emit()
