extends Node

signal stop_object()
signal change_player_health(delta: float)
signal move_player(direction: Vector2)
signal player_death()
signal change_score(delta: int)
signal change_chest_count(add: bool)
signal big_chest_collected()
signal disable_player_shooting()
signal enable_player_shooting()
signal end_game()
signal update_scene(destination_scene_enum: Globals.CurrentSceneEnum)
