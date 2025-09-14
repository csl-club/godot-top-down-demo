extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var dash_speed = 900
var isDashing = false

@onready var pivot = $Marker2D


@export var bulletScene : PackedScene
@export var bulletSpeed = 900


func _physics_process(delta: float) -> void:
	# Add the gravity.

	# Handle jump.
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	if isDashing:
		velocity = direction * dash_speed
	else:
		velocity = direction * SPEED
	if Input.is_action_just_pressed("dash"):
		isDashing = true
		DashTimer()
		
	if Input.is_action_just_pressed("shoot"):
		fire()
		
	look_at(get_global_mouse_position())

	move_and_slide()
	
func DashTimer():
	if isDashing:
		await get_tree().create_timer(0.2).timeout
		isDashing = false
		
func fire():
	var bullet = bulletScene.instantiate()
	bullet.global_position = pivot.global_position
	bullet.rotation_degrees = rotation_degrees
	#bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.apply_impulse(Vector2(bulletSpeed, 0).rotated(rotation), Vector2())
	get_parent().add_child(bullet)
	await get_tree().create_timer(5).timeout
	bullet.queue_free()
