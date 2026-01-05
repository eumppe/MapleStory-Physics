extends CharacterBody2D

#TODO
const SPEED = 300.0
const FRICTION_POW = 200.0
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

var face = 1
var djc = 0
var maxdj = 2
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("key_left", "key_right")
	if direction:
			face = direction
	
	if direction:
			velocity.x += clamp_accel(velocity.x, direction * MOVE_ACCEL * get_friction() * delta, SPEED) 
	else:
		if abs(velocity.x)>0:
			var ff = sign(velocity.x) * MOVE_ACCEL * get_friction() * delta
			velocity.x -= ff
			if abs(velocity.x) < ff:
				velocity.x = 0
	
	# Add the gravity.
	if is_on_floor():
		djc=0
		# Handle jump.
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			if direction:
				if sign(velocity.x)!=sign(direction):
					velocity.x += direction * SPEED * get_friction()

		# Default Friction
		
		if abs(velocity.x)>SPEED:
			velocity.x -= clamp((velocity.x-FRICTION_POW*sign(velocity.x)) * get_friction(),-SPEED,SPEED)*delta*60

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
	
	else:
		var dj_speed=SPEED+300
		var dj_acc=SPEED+300
		var dj_up_speed=SPEED+300
		var dj_up_acc=SPEED+300
		if djc<maxdj and Input.is_action_just_pressed("jump"):
			djc+=1
			if abs(velocity.x) < SPEED + 500:
				velocity.x += clamp_accel(velocity.x, dj_acc*face, dj_speed)
			if abs(velocity.y) < SPEED + 200:
				velocity.y -= 200
		velocity += GRAVITY * delta * Vector2.DOWN
	print(velocity.x)
	move_and_slide()
