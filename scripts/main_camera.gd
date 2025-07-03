extends Camera2D

@export var down_speed: float = 20.0
@export var up_speed: float = 30.0

var move_direction: int = 0
var movement_speed: float
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.stop_object.connect(_on_stop_object)
	SignalBus.player_death.connect(_on_player_death)
	SignalBus.big_chest_collected.connect(_on_big_chest_collected)
	movement_speed = down_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += movement_speed * move_direction * delta


func _on_timer_timeout():
	move_direction = 1

func _on_stop_object():
	move_direction = 0

func _on_player_death():
	move_direction = 0
	
func _on_big_chest_collected():
	move_direction = -1
	movement_speed = up_speed
