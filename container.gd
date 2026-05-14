extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoload.stateChange.connect(statechange)
func statechange():
	if(Autoload.state == "playing" or Autoload.state == "campaign"):
		Autoload.clamps = [$clamp.position,$clamp2.position]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
