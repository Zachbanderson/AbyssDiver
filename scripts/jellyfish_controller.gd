extends enemy_template

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	hitboxes_to_disable_on_death.append_array([$HeadHitbox/HeadHitboxShape, $TentacleHitbox/TentacleHitboxShape])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
