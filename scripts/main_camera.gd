extends Camera2D

@export var down_speed: int = 20

var move_direction: int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.stop_object.connect(_on_stop_object)
	SignalBus.player_death.connect(_on_player_death)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += down_speed * move_direction * delta


func _on_timer_timeout():
	move_direction = 1

func _on_stop_object():
	move_direction = 0

func _on_player_death():
	move_direction = 0
