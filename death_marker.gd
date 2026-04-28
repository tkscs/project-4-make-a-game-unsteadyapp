extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var time = 0
var bodiesTouching = null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Autoload.state == "playing"):
		var bodies  = get_overlapping_bodies()
		if(bodies.size() >0):
			#if(body in bodies):
				time+=delta
				if(time>2):
					time = 0
					print("hello")
					Autoload.gameOver.emit()
			#elif(bodiesTouching == []):
				#bodiesTouching
		else:
			time = 0
			bodiesTouching = []
