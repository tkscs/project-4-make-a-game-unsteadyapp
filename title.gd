extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoload.stateChange.connect(stateChange)
	Autoload.win.connect(win)
func stateChange():
	if(Autoload.state == "main"):
		show()
	else:
		hide()

func _on_play_pressed() -> void:
	Autoload.state = "playing"
	Autoload.stateChange.emit()


func _on_create_pressed() -> void:
	Autoload.state = "create"
	Autoload.stateChange.emit()
func win():
	$Win.text = "You Win!"


func _on_campaign_pressed() -> void:
	Autoload.state = "campaign"
	Autoload.stateChange.emit()
