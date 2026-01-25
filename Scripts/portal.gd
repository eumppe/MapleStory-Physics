extends Node2D
class_name Portal

@export var spwan_index: int = 0
@export var next_map: String
@export var next_spwan_index: int


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.up_pressed.connect(_take_portal)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.up_pressed.disconnect(_take_portal)

func _take_portal():
	SceneSwitcher.switch_scene(next_map, next_spwan_index)
