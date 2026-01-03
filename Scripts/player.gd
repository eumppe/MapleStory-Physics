extends CharacterBody2D


const SPEED = 160.0
const FRICTION_CONST = 100
const JUMP_VELOCITY = -700.0
const GRAVITY = 2100

@onready var ground_scanner: RayCast2D = $GroundScanner


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if is_on_floor():
		
		var ground = ground_scanner.get_collider()
		ground.get
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("key_left", "key_right")
		if direction:
			if abs(velocity.x)<SPEED:
				velocity.x += direction * SPEED * delta
			if abs(velocity.x)>=SPEED:
				velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	else:
		
		velocity += GRAVITY * delta * Vector2.DOWN

	move_and_slide()
