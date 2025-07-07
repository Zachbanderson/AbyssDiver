extends Node2D

@export var total_score: int = 0

@onready var empty_smallchest_texture: CompressedTexture2D = preload("res://assets/SmallChestHolderUIEmpty.png")
@onready var filled_smallchest_texture: CompressedTexture2D = preload("res://assets/SmallChestHolderUIFilled.png")
@onready var empty_bigchest_texture: CompressedTexture2D = preload("res://assets/BigChestHolderUIEmpty.png")
@onready var filled_bigchest_texture: CompressedTexture2D = preload("res://assets/BigChestHolderUIFilled.png")
@onready var rightHUD_access = $MainCamera/RightHUD
@onready var leftHUD_access = $MainCamera/LeftHUD
@onready var score_display: Label = rightHUD_access.get_node_or_null("ScoreDisplay")
@onready var health_bar: TextureProgressBar = leftHUD_access.get_node_or_null("HealthBar")
@onready var chest_list: Array = leftHUD_access.get_node_or_null("CenterContainer").get_node_or_null("ChestHolder").get_children()
@onready var level_end_active_flag = false

var index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.change_score.connect(_on_score_changed)
	SignalBus.change_player_health.connect(_on_player_health_changed)
	SignalBus.change_chest_count.connect(_on_chest_count_changed)
	SignalBus.big_chest_collected.connect(_on_big_chest_collected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# TODO: Remove before release
	if Input.is_action_just_pressed('debug_speed_time_up'):
		Engine.time_scale = 2
	if Input.is_action_just_pressed("debug_restore_time"):
		Engine.time_scale = 1

func _on_level_end_area_entered(area):
	if level_end_active_flag:
		SignalBus.end_game.emit()
		SignalBus.stop_object.emit()
		$MainCamera/Top/TopShape.set_deferred('disabled', true)

func _on_big_chest_collected():
	leftHUD_access.get_node_or_null("CenterContainer").get_node_or_null("BigChestHolder").texture = filled_bigchest_texture
	level_end_active_flag = true

func _on_chest_count_changed(increment: bool):
	# If increment is true, then add a treasure chest to the UI.
	if increment:
		chest_list[index].texture = filled_smallchest_texture
		index = clamp(index + 1, 0, chest_list.size())
	else:
		index = clamp(index - 1, 0, chest_list.size())
		chest_list[index].texture = empty_smallchest_texture

func _on_score_changed(delta: int):
	total_score += delta
	score_display.text = str(total_score)
	
func _on_player_health_changed(delta: float):
	health_bar.value += delta
