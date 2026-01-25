extends Node2D

@export var damage : int = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Attack:
		pass
	elif body is Player:
		body.invincible_timeout.connect(body_hit)
		body_hit(body)
	return
	

func body_hit(player: Player):
	player.get_body_damage(damage)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is not Player:
		return
	stop_body_hit(body)
	
func stop_body_hit(player: Player):
	player.invincible_timeout.disconnect(body_hit)
