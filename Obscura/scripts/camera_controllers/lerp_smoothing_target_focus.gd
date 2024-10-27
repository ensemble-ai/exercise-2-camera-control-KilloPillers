class_name LerpSmoothingTargetFocus
extends CameraControllerBase

@export var lead_speed:float
@export var catchup_delay_duration:float
@export var catchup_speed:float
@export var leash_distance:float

var was_target_moving: bool = false
var timer: float = 0

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var target_move_vector: Vector3 = target.velocity.normalized()
	var target_speed: float = target.velocity.length()
	var true_lead_speed: float = max(lead_speed, target_speed)
	
	if target.velocity.is_equal_approx(Vector3.ZERO):
		if was_target_moving:
			timer = 0.0
		else:
			timer += delta
		if timer >= catchup_delay_duration:
			global_position = global_position.move_toward(target.position, catchup_speed)
		was_target_moving = false
	else:
		timer = 0.0
		was_target_moving = true
		
		var target_position = target.position + target_move_vector * leash_distance
		global_position = global_position.move_toward(target_position, true_lead_speed)
	
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
