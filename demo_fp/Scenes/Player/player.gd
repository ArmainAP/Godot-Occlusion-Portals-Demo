extends CharacterBody3D

@onready var gunRay := $Head/Camera3d/RayCast3d as RayCast3D
@onready var Cam := $Head/Camera3d as Camera3D
var mouseSensibility := 1200
const SPEED = 5.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	#Captures mouse and stops rgun from hitting yourself
	gunRay.add_exception(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _physics_process(delta : float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event : InputEvent) -> void:
	var mouse_event := event as InputEventMouseMotion
	if mouse_event:
		rotation.y -= mouse_event.relative.x / mouseSensibility
		Cam.rotation.x -= mouse_event.relative.y / mouseSensibility
		Cam.rotation.x = clamp(Cam.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
