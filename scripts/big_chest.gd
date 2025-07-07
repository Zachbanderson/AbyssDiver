extends CollectableTemplate


# Called when the node enters the scene tree for the first time.
func _ready():
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hitbox_area_entered(area):
	super(area)
	if area.get_parent().is_in_group('Player'):
		SignalBus.big_chest_collected.emit()
		SignalBus.disable_player_shooting.emit()
