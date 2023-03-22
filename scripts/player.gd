extends CharacterBody3D

@export var speed = 5
@export var dash_multiplier = 2
@export var fall_acceleration = 55
@export var jump_impulse = 10

var target_velocity = Vector3.ZERO

func _ready():
	Input.add_joy_mapping("030000005e040000e002000003090000,8BitDo SN30 Pro Plus,platform:Mac OS X,a:b0,b:b1,x:b2,y:b3,back:b6,guide:b10,start:b7,leftstick:b8,rightstick:b9,leftshoulder:b4,rightshoulder:b5,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a3,righty:a4,lefttrigger:a2,righttrigger:a5,", true)

func _process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		look_at_smooth($Pivot, position + direction, 0.1)
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - ( fall_acceleration * delta )

	#Jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	#Dash
	if Input.is_action_pressed("dash"):
		target_velocity.x = target_velocity.x * dash_multiplier
		target_velocity.z = target_velocity.z * dash_multiplier

	velocity = target_velocity
	move_and_slide()
	
	
## https://docs.godotengine.org/ja/stable/tutorials/3d/using_transforms.html
## https://www.reddit.com/r/godot/comments/yc5bwh/how_to_tweeninterpolate_look_at_method/
func look_at_smooth(subject: Node3D, target_point: Vector3, dulation: float):

	var dummy = Node3D.new()
	add_child(dummy)

	dummy.global_transform.origin = subject.global_transform.origin
	dummy.look_at(target_point, Vector3.UP)

	var from = Quaternion(subject.transform.basis)
	var to = Quaternion(dummy.transform.basis)
	var c = from.slerp(to, dulation)
	subject.transform.basis = Basis(c)
	
	dummy.queue_free()
