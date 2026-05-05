extends Area2D
var mode = "bp"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#for i in get_overlapping_bodies():
		#if(i.is_in_group("fruit")):
			#var fruitRef = i as RigidBody2D
			#fruitRef.apply_force(Vector2(0,-1000))
			#print(i)
func _physics_process(delta: float) -> void:
	if(mode == "fan"):
		for i in get_overlapping_bodies():
			if(i.is_in_group("fruit")):
				var fruitRef = i as RigidBody2D
				fruitRef.apply_force(Vector2(0,-10000))
func _on_body_entered(body: Node2D) -> void:
	if(mode == "bp" and body.is_in_group("fruit")):
		body.linear_velocity.y =-1000
