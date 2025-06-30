extends Area2D

@export var point_value: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$Animations.play('spin')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if(area.get_parent().is_in_group('Player')):
		SignalBus.change_score.emit(point_value)
		queue_free()
