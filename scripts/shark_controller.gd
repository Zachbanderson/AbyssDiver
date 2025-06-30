extends enemy_template

# Exported variables.
@export var velocity: float		= 30.0	# Determines the speed of the shark.

# Hidden variables initialized on _ready.
@onready var sprite: AnimatedSprite2D = $Sprite

# Other variables.
var direction: int = 1

# Godot-defined functions.
##########################

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	hitboxes_to_disable_on_death.append($Hitbox/HitboxShape)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $RayCastRight.is_colliding():
		direction = -1
		sprite.flip_h = false
	if $RayCastLeft.is_colliding():
		direction = 1
		sprite.flip_h = true
	position.x += velocity * delta * direction
