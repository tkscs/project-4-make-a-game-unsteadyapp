extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoload.stateChange.connect(stateChange)
	Autoload.win.connect(win)
func stateChange():
	if(Autoload.state == "main"):
		show()

func _on_play_pressed() -> void:
	Autoload.state = "playing"
	Autoload.stateChange.emit()
	hide()


func _on_create_pressed() -> void:
	Autoload.state = "create"
	Autoload.stateChange.emit()
	hide()

func win():
	$Win.text = "You Win!"
