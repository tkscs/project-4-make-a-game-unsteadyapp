class_name global extends Node
signal spawn(child)
var ogsize = 1
var score = 0
signal stateChange
var allCircle = true
var state = "main"
signal gameOver
signal win
var gravity = 2
var expressionToWin = "false"
var maxSpawnRate:float = 0.4
var clamps = [Vector2(0,0),Vector2(0,0)]
