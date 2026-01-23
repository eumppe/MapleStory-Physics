extends CharacterBody2D

signal down_jump_ended

#TODO
const SPEED = 300.0
const FRICTION_POW = 200.0
const MOVE_ACCEL = 1600

const JUMP_VELOCITY = -700.0
const GRAVITY = 2100

const GROUND_FRICTION : float = 0.95
const AIR_FRICTION : float = 0.05

@onready var ground_scanner: ShapeCast2D = $GroundScanner


func get_friction() -> float:
	if is_on_floor():
		return GROUND_FRICTION
	else:
		return AIR_FRICTION

func clamp_accel(linear_velocity:float, accel:float, max_velocity:float) -> float:
	if accel>0:
		if linear_velocity>max_velocity:
			return 0
		return min(linear_velocity+accel,max_velocity) - linear_velocity
	else:
		if linear_velocity<-max_velocity:
			return 0
		return max(linear_velocity+accel,-max_velocity) - linear_velocity
		
func air_jump():
	var dj_speed=SPEED+500
	var dj_acc=SPEED+500
	var dj_up_speed=500
	var dj_up_acc=500
	if air_jump_count<max_air_jump:
		end_down_jump()
		air_jump_count+=1
		velocity.x += clamp_accel(velocity.x, dj_acc*face, dj_speed)
		velocity.y += clamp_accel(velocity.y, -dj_up_acc, dj_up_speed)
	
func up_jump():
	if air_jump_count < max_air_jump and up_jump_count < max_up_jump:
		end_down_jump()
		air_jump_count+=1
		up_jump_count +=1
		velocity.y += clamp_accel(velocity.y, -1200, 1200)
		
func end_down_jump():
	down_jump_ended.emit()
	for dict in down_jump_ended.get_connections():
		down_jump_ended.disconnect(dict.callable)

var face = 1
var air_jump_count = 0
var max_air_jump = 2
var up_jump_count = 0
var max_up_jump = 1
func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("key_left", "key_right")
	if direction:
			face = direction
			velocity.x += clamp_accel(velocity.x, direction * MOVE_ACCEL * get_friction() * delta, SPEED) 
	else:
		if abs(velocity.x)>0:
			var ff = sign(velocity.x) * MOVE_ACCEL * get_friction() * delta
			velocity.x -= ff
			if abs(velocity.x) < ff:
				velocity.x = 0
	
	# Add the gravity.
	if is_on_floor():
		end_down_jump()
		
		air_jump_count=0
		up_jump_count=0
		# Handle jump.
		if Input.is_action_pressed("jump"):
			if Input.is_action_pressed("key_down"):
				var ground = ground_scanner.get_collider(0)
				if ground.down_jumpable:
					velocity.y += -130
					ground.ground_jump()
					down_jump_ended.connect(ground.revert_mask)
			else:
				velocity.y += JUMP_VELOCITY
				
				if direction:
					if sign(velocity.x)!=sign(direction):
						velocity.x += direction * SPEED * get_friction()

		# Default Friction
		
		if abs(velocity.x)>SPEED:
			velocity.x -= clamp((velocity.x-FRICTION_POW*sign(velocity.x)) * get_friction(),-SPEED,SPEED)*delta*60

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
	
	else:
		
		
		if Input.is_action_just_pressed("jump"):
			if Input.is_action_pressed("key_up"):
				up_jump()
			else:
				air_jump()
		velocity += GRAVITY * delta * Vector2.DOWN
	move_and_slide()
