extends KinematicBody

const UP = Vector3(0, -1, 0)

var gravity = 2.45
var jump = 1
var capncrunch = Vector3()

var speed = 2.5
var acceleration = 5

var mouse_sensitivity = 0.1

var direction = Vector3()
var velocity = Vector3()

onready var pivot = $Pivot
onready var rayCast = $Pivot/RayCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	rayCast.add_exception(self)
	Global.hp = 100
	
	damage(1)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x, deg2rad(-90), deg2rad(90))
	
func _process(delta):
	
	if self.translation.y <= -3.5:
		self.translation = Vector3(0,0,0)
		fall()
	
	direction = Vector3()
	
	if Input.is_action_pressed("Forward") or Input.is_action_pressed("Back") or Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
		$Mesh/AnimationTree.set("parameters/Blend/blend_amount", 1)
	if not Input.is_action_pressed("Forward") and not Input.is_action_pressed("Back") and not Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		$Mesh/AnimationTree.set("parameters/Blend/blend_amount", 0)
	
	if Input.is_action_pressed("Forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("Back"):
		direction += transform.basis.z
	if Input.is_action_pressed("Left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("Right"):
		direction += transform.basis.x
		
	capncrunch.y -= gravity * delta
	
	move_and_slide(capncrunch, Vector3.UP)
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		capncrunch.y = jump
	
	direction = direction.normalized()
	velocity = direction * speed
	velocity.linear_interpolate(velocity, acceleration * delta)
	move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_just_pressed("Shoot"):
		get_node("/root/GamePlay/Audios/Gun").play()
		if rayCast.is_colliding():
			var target = rayCast.get_collider()
			print(target.name)
			if target.is_in_group("Enemy"):
				target.die()
				
func fall():
	get_tree().change_scene("res://Scenes/End.tscn")
	
func damage(val):
	Global.hp -= val
	if Global.hp <= 0:
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	damage(1)
	t.queue_free()
	
