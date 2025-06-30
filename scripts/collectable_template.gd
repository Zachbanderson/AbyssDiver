extends Node2D
class_name CollectableTemplate

@export var point_value: int

func _ready():
	$Hitbox.connect("area_entered", _on_hitbox_area_entered)
	
func _on_hitbox_area_entered(area):
	SignalBus.change_score.emit(point_value)
	queue_free()
