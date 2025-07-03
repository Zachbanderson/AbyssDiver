extends enemy_template

# Exported variables.
@export var idle_velocity: float		= 20.0	# Determines the speed of the anglerfish when idle.
@export var pursuit_velocity: float		= 40.0	# Determines the speed of the anglerfish when in pursuit.
@export var player: CharacterBody2D

# Hidden variables initialized on _ready.
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

# Other variables.
##################

# Determines the direction the anglerfish is facing.
var direction: int = 1
var velocity: float

# Enum that handles the state of the anglerfish.
enum State {
	IDLE,
	PURSUIT
}

# Current state.
var current_state: State

# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = State.IDLE
	velocity = idle_velocity
	super()
	hitboxes_to_disable_on_death.append($EnemyHitbox/EnemyHitboxShape)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# print('Current state is ' + str(current_state))
	if current_state == State.IDLE:
		if $RayCastRight.is_colliding():
			scale.x *= -1
			direction = -1 if scale.x < 0 else 1
		position.x += velocity * delta * direction
	if current_state == State.PURSUIT:
		# Find the direction to the player and point the anglerfish in that direction.
		var direction_to_target: Vector2 = player.global_position - global_position
		direction_to_target = direction_to_target.normalized()
		
		# Move the angler fish towards the player.
		global_position += velocity * direction_to_target * delta

# Called when the player enters the anglerfish's FOV.
func _on_fov_area_entered(area):
	if area.get_parent().is_in_group('Player'):
		current_state = State.PURSUIT
		velocity = pursuit_velocity
		player = area.get_parent() 

# Called when the player leaves the anglerfish's FOV.
func _on_fov_area_exited(area):
	if area.get_parent().is_in_group('Player'):
		current_state = State.IDLE
		velocity = idle_velocity
