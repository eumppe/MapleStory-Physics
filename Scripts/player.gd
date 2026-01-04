extends CharacterBody2D


const SPEED = 200.0
const MOVE_ACCEL = 1600
const JUMP_VELOCITY = -700.0
const GRAVITY = 2100

const GROUND_FRICTION : float = 0.9
const AIR_FRICTION : float = 0.05

@onready var ground_scanner: RayCast2D = $GroundScanner

func get_friction() -> float:
	if is_on_floor():
		return GROUND_FRICTION
	else:
		return AIR_FRICTION

func clamp_accel(linear_velocity:float, accel:float, max_velocity:float) -> float:
	return clamp(linear_velocity+accel,-max_velocity,max_velocity) - linear_velocity

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("key_left", "key_right")
	# Add the gravity.
	if is_on_floor():
		
		# Handle jump.
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			if direction:
				if sign(velocity.x)!=sign(direction):
					velocity.x += direction * SPEED * get_friction()

		# Default Friction
		
		if abs(velocity.x)>SPEED:
			velocity.x -= clamp((velocity.x-SPEED*sign(velocity.x)) * get_friction(),-SPEED,SPEED)*delta*60

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if direction:
			velocity.x += clamp_accel(velocity.x, direction * MOVE_ACCEL * get_friction() * delta, SPEED) 
		else:
			if abs(velocity.x)>0:
				var ff = sign(velocity.x) * MOVE_ACCEL * get_friction() * delta
				velocity.x -= ff
				if abs(velocity.x) < ff:
					velocity.x = 0
	
	else:
		if Input.is_action_just_pressed("jump"):
			if abs(velocity.x) < SPEED + 500:
				velocity.x += clamp_accel(velocity.x, 500*direction, SPEED+500)
			if abs(velocity.y) < SPEED + 200:
				velocity.y -= 200
		velocity += GRAVITY * delta * Vector2.DOWN
	print(velocity.x)
	move_and_slide()
