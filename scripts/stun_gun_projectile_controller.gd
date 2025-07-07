extends Node2D

# Exported variables.
@export var speed: int				# Determines the speed of the projectile.
@export var maximum_distance: float # Determines the maximum distance the projectile can go from initial_position.
@export var damage: float			# Determines how much damage the projectile does.

# Hidden variables initialized on _ready.
@onready var direction: Vector2 	# Determines the direction that the projectile moves.

# Other variables
var initial_position: Vector2		# Stores the initial position of the projectile.

# Built-in Functions.
#####################

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction.normalized() * delta * speed

	if global_position.distance_to(initial_position) >= maximum_distance:
		run_behavior_on_death()

# Signal Connection Functions.
##############################
func _on_projectile_bounds_area_entered(area):
	run_behavior_on_death()
	if area.is_in_group('Hurtable'):
		area.get_parent().take_damage(damage)


func _on_projectile_bounds_body_entered(body):
	run_behavior_on_death()
	if body.get_parent().is_in_group('Hurtable'):
		body.get_parent().take_damage(damage)

# Programmer-Defined Functions.
###############################
func run_behavior_on_death():
	SignalBus.enable_player_shooting.emit()
	queue_free()
