extends StaticBody2D

func ground_jump():
	set_collision_mask_value(2, false)
	set_collision_layer_value(1, false)
	print("asd")
	
func revert_mask():
	set_collision_mask_value(2, true)
	set_collision_layer_value(1, true)
	print("qweqwe")
