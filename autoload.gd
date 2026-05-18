class_name global extends Node
signal spawn(child)
var drawing = false
var ogsize = 1
var score = 0
var allCollisionObj = []
signal stateChange
var allCircle = true
var state = "main"
var levelInDevelopment := ""
signal gameOver
signal win
var gravity = 2
var expressionToWin = "false"
var maxSpawnRate:float = 0.4
var clamps = [Vector2(0,0),Vector2(0,0)]
var campaginLevel = 0
