extends CharacterBody2D

# Exported variables.
# Player movement variables
@export var speed: float = 100.0
@export var downward_force: float = 40.0
@export var fire_timeout_seconds: float = 1.5
@export var max_health: float = 100
@export var stun_gun_projectile: PackedScene

# Hidden variables initialized on _ready.
@onready var spawn_point: Marker2D = $SpawnPoint
@onready var index: int = 1

# Map to store animations for quick lookups.
@onready var animation_map: Array = [	{ 	animation = 'Up-Left',
											marker_position = Vector2(-10, -8)
											}, 
										{	animation = 'Up',
											marker_position = Vector2(0, -8)
											},
										{	animation = 'Up-Right',
											marker_position = Vector2(10, -8)
											},
										{	animation = 'Right',
											marker_position = Vector2(10, 0)
											},
										{	animation = 'Down-Right',
											marker_position = Vector2(10, 8)
											},
										{	animation = 'Down',
											marker_position = Vector2(0, 8)
											},
										{	animation = 'Down-Left',
											marker_position = Vector2(-10, 8)
											},
										{	animation = 'Left',
											marker_position = Vector2(-10, 0)
											}
										]

# Storing the direction that the player is facing.
var direction: Vector2
var additional_impulse: Vector2 = Vector2.ZERO
var curr_health: float = max_health

func _ready():
	SignalBus.change_player_health.connect(_on_player_health_changed)
	SignalBus.move_player.connect(_on_player_moved)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Handle movement input.
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")

	# Normalize input to prevent faster diagonal movement.
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		direction = input_vector
		# There are 8 possible directions and 8 possible animations to play.
		# Instead of performing 8 different if cases, we will transform the direction
		# into an enum that corresponds with a certain animation.
		#########################################################
		
		# The normalized vector represents a point on a unit circle. Taking the arctangent
		# of this point gives us the angle from the x axis. Multiplying it by 180 / PI converts
		# the results from radians to degrees to make it easier to work with, dividing it 
		# by 45 gives us a range from -3 to 4 (-135 / 45 to 180 / 45), and adding 3 converts the
		# range to go from 0 to 7 for an easy lookup in the array.
		index = atan2(input_vector.y, input_vector.x) * 180 / PI / 45 + 3

	$Animations.play(animation_map[index].animation)
	$SpawnPoint.position = animation_map[index].marker_position
	
	# Apply movement.
	velocity = input_vector * speed
	
	# Apply any additional impluses from knockback.
	velocity += additional_impulse
	
	# Apply downward force.
	velocity.y += downward_force

	# Move the character.
	move_and_slide()
	
	additional_impulse = lerp(additional_impulse, Vector2.ZERO, 0.1)
	
func _process(delta) -> void:
	# Check for shooting input.
	if Input.is_action_just_pressed("shoot"):
		var projectile: Node = stun_gun_projectile.instantiate()
		projectile.position = spawn_point.global_position
		projectile.direction = direction
		owner.add_child(projectile)
	
	# Check if the player is being crushed by the camera and an object.
	if $CrushDetectionDown.is_colliding() and $CrushDetectionUp.is_colliding():
		die()

# Function called whenever player is dealt damage.
func _on_player_health_changed(delta) -> void:
	# If the player's health decreases.
	if delta < 0:
		SignalBus.change_chest_count.emit(false)
	curr_health += delta
	if curr_health <= 0:
		die()
	
# Function called whenever player gets forcibly moved.
func _on_player_moved(direction) -> void:
	additional_impulse = direction.normalized() * 150
	
# Function called when player dies.
func die() -> void:
	$AnimationPlayer.play("die")
	SignalBus.player_death.emit()
