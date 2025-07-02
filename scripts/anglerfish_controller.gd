extends enemy_template

# Exported variables.
@export var velocity: float		= 20.0	# Determines the speed of the anglerfish.
@export var player: CharacterBody2D

# Hidden variables initialized on _ready.
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

# Other variables.
##################

# Determines the direction the anglerfish is facing.
var direction: int = 1

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
	super()
	hitboxes_to_disable_on_death.append($EnemyHitbox/EnemyHitboxShape)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state == State.IDLE:
		if $RayCastRight.is_colliding():
			scale.x *= -1
			direction = -1 if scale.x < 0 else 1
		position.x += velocity * delta * direction
	#if current_state == State.PURSUIT:
		#navigation_agent_2d.target_position = 


func _on_fov_area_entered(area):
	if area.is_in_group('Player'):
		current_state == State.PURSUIT


func _on_fov_area_exited(area):
	if area.is_in_group('Player'):
		current_state == State.IDLE
