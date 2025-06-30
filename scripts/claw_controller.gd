extends Node2D

var STATE: String = 'IDLE'
var max_scale: float = 5.0
var max_position: float = 36.0
var speed: float = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	if STATE == 'SHOOTING':
		scale = scale.lerp(Vector2(max_scale, 1), speed * delta)
		position = position.lerp(Vector2(max_position, 1), speed * delta)
		if scale.x == max_scale:
			STATE = 'RETRACTING'
	if STATE == 'RETRACTING':
		scale = scale.lerp(Vector2(.1, 1), speed * delta)
		if scale.x == .1:
			STATE = 'IDLE'
		

func shoot():
	print("Shooting")
	STATE = 'SHOOTING'
	while STATE != 'IDLE':
		await get_tree().create_timer(.1).timeout
	print("Done shooting")
