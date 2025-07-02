extends Node2D
class_name enemy_template

@export var max_health: float
@export var point_value: int

@onready var curr_health: float = max_health

var death_flag: bool = false
var hitboxes_to_disable_on_death: Array = []

func _ready() -> void:
	$AnimationPlayer.connect("animation_finished", _on_animation_player_animation_finished)

# Handles the enemy taking damage.
func take_damage(damage: float):
	curr_health -= damage
	for hitbox in hitboxes_to_disable_on_death:
		hitbox.set_deferred("disabled", true)
	check_for_death()

# Checks if the enemy's health is less than or equal to 0. Then should die.
func check_for_death():
	if curr_health <= 0:
		$AnimationPlayer.queue("Shared_Enemy_Animations/die")
	else:
		$AnimationPlayer.queue("Shared_Enemy_Animations/take_damage")

# Handles death behavior.
func die():
	SignalBus.change_score.emit(point_value)
	queue_free()
	
func _on_animation_player_animation_finished(anim_name: String):
	# If the death animation plays, then the enemy should die upon completion.
	if anim_name == "Shared_Enemy_Animations/die":
		die()
	# If the enemy only takes damage, re-enable the hitboxes.
	elif anim_name == "Shared_Enemy_Animations/take_damage":
		for hitbox in hitboxes_to_disable_on_death:
			hitbox.set_deferred("disabled", false)
