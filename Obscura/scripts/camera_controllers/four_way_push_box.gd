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
	
	var tpos = target.global_position
	var cpos = global_position
	var box_width = pushbox_bottom_right.x - pushbox_top_left.x 
	var box_height = pushbox_bottom_right.y - pushbox_top_left.y
	
	
	
	
	
	
	
	
	#boundary checks for pushbox
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
		
	super(delta)


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
