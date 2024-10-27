class_name PositionLockLerpSmooth
extends CameraControllerBase

@export var follow_speed:float
@export var catchup_speed:float
@export var leash_distance:float

# This camera does exactly what the spec sheet ask
# but it fucking sucks and is not like SMB


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var _xz_target_position = Vector2(target.position.x, target.position.z)
	var _xz_position = Vector2(position.x, position.z)
	
	var distance_to_target = _xz_target_position.distance_to(_xz_position)
	var direction_to_target = (_xz_target_position - _xz_position).normalized()
	
	if distance_to_target >= leash_distance:
		global_position.x = _xz_target_position.x - (direction_to_target * leash_distance).x
		global_position.z = _xz_target_position.y - (direction_to_target * leash_distance).y
	
	if target.velocity.is_equal_approx(Vector3.ZERO):
		global_position = global_position.move_toward(target.position, catchup_speed)
	else:
		global_position = global_position.move_toward(target.position, follow_speed)
	
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -5
	var right:float = 5
	var top:float = -5
	var bottom:float = 5
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# Left to right
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))
	
	# Top to bottom
	immediate_mesh.surface_add_vertex(Vector3(0, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))
	
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
