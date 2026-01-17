extends StaticBody2D

@export var down_jumpable : bool = true

func ground_jump():
	if not down_jumpable:
		return
	set_collision_mask_value(2, false)
	set_collision_layer_value(1, false)
	
func revert_mask():
	set_collision_mask_value(2, true)
	set_collision_layer_value(1, true)
