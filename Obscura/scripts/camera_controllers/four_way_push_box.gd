class_name FourWayPushBox
extends CameraControllerBase

@export var push_ratio:float
@export var pushbox_top_left:Vector2
@export var pushbox_bottom_right:Vector2
@export var speedup_zone_top_left:Vector2
@export var speedup_zone_bottom_right:Vector2

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
		
	if draw_camera_logic:
		draw_logic()
		
	super(delta)
	

# had to use phyics process here so that the camera was smooth
func _physics_process(delta: float) -> void:
	if !current:
		return
	
	var tpos = target.global_position
	var cpos = global_position
	
	var box_width = pushbox_bottom_right.x - pushbox_top_left.x 
	var box_height = pushbox_bottom_right.y - pushbox_top_left.y
	
	var su_box_width = speedup_zone_bottom_right.x - speedup_zone_top_left.x 
	var su_box_height = speedup_zone_bottom_right.y - speedup_zone_top_left.y
	
	#boundary checks for pushbox
	
	var su_diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - su_box_width / 2.0)
	var su_diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + su_box_width / 2.0)
	var su_diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - su_box_height / 2.0)
	var su_diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + su_box_height / 2.0)


	if su_diff_between_left_edges < 0:
		if target.velocity.x < 0 or is_zero_approx(target.velocity.x):
				global_position.z += target.velocity.z * push_ratio
				global_position.x += target.velocity.x * push_ratio
		#right
	elif su_diff_between_right_edges > 0:
		if target.velocity.x > 0 or is_zero_approx(target.velocity.x):
				global_position.z += target.velocity.z * push_ratio
				global_position.x += target.velocity.x * push_ratio
		#top
	elif su_diff_between_top_edges < 0:
		if target.velocity.z < 0 or is_zero_approx(target.velocity.z):
				global_position.z += target.velocity.z * push_ratio
				global_position.x += target.velocity.x * push_ratio
		#bottom
	elif su_diff_between_bottom_edges > 0:
		if target.velocity.z > 0 or is_zero_approx(target.velocity.z):
				global_position.z += target.velocity.z * push_ratio
				global_position.x += target.velocity.x * push_ratio
	
	tpos = target.global_position
	cpos = global_position
	
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)

	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges

	#right
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges

	#top
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges

	#bottom
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var pb_left:float = pushbox_top_left.x
	var pb_right:float = pushbox_bottom_right.x
	var pb_top:float = pushbox_top_left.y
	var pb_bottom:float = pushbox_bottom_right.y
	
	var su_left:float = speedup_zone_top_left.x
	var su_right:float = speedup_zone_bottom_right.x
	var su_top:float = speedup_zone_top_left.y
	var su_bottom:float = speedup_zone_bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# top right to bottom right
	immediate_mesh.surface_add_vertex(Vector3(pb_right, 0, pb_top))
	immediate_mesh.surface_add_vertex(Vector3(pb_right, 0, pb_bottom))
	
	# bottom right to bottom left
	immediate_mesh.surface_add_vertex(Vector3(pb_right, 0, pb_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pb_left, 0, pb_bottom))
	
	# bottom left to top left
	immediate_mesh.surface_add_vertex(Vector3(pb_left, 0, pb_bottom))
	immediate_mesh.surface_add_vertex(Vector3(pb_left, 0, pb_top))
	
	# top left to top right
	immediate_mesh.surface_add_vertex(Vector3(pb_left, 0, pb_top))
	immediate_mesh.surface_add_vertex(Vector3(pb_right, 0, pb_top))
	
	# top right to bottom right
	immediate_mesh.surface_add_vertex(Vector3(su_right, 0, su_top))
	immediate_mesh.surface_add_vertex(Vector3(su_right, 0, su_bottom))
	
	# bottom right to bottom left
	immediate_mesh.surface_add_vertex(Vector3(su_right, 0, su_bottom))
	immediate_mesh.surface_add_vertex(Vector3(su_left, 0, su_bottom))
	
	# bottom left to top left
	immediate_mesh.surface_add_vertex(Vector3(su_left, 0, su_bottom))
	immediate_mesh.surface_add_vertex(Vector3(su_left, 0, su_top))
	
	# top left to top right
	immediate_mesh.surface_add_vertex(Vector3(su_left, 0, su_top))
	immediate_mesh.surface_add_vertex(Vector3(su_right, 0, su_top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
