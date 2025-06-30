extends Area2D
class_name EnemyHitbox

@export var damage: int
@onready var collision_shape: CollisionShape2D = get_child(0)

func _init() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(collision_shape != null)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_area_entered(area: Area2D):
	if area.get_parent().is_in_group('Player'):
		SignalBus.change_player_health.emit(-damage)
		SignalBus.move_player.emit(area.global_position - global_position)
