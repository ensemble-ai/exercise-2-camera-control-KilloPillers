class_name AutoScroll
extends CameraControllerBase


@export var top_left:Vector2
@export var bottom_right:Vector2
@export var autoscroll_speed:Vector3

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()

	# Move the camera
	global_position += autoscroll_speed
	
	# Store position variables
	var tpos = target.global_position
	var cpos = global_position
	
	
	# Player is to the left of the camera viewport
	if tpos.x - target.WIDTH / 2 < cpos.x + top_left.x:
		target.global_position.x = cpos.x + top_left.x + (target.WIDTH / 2)
		
	# Player is to the right of the camera viewport
	if tpos.x + target.WIDTH / 2> cpos.x + bottom_right.x:
		target.global_position.x = cpos.x + bottom_right.x - (target.WIDTH / 2)
		
	# Player is to the top of the camera viewport 
	if tpos.z - target.HEIGHT / 2 < cpos.z + top_left.y:
		target.global_position.z = cpos.z + top_left.y + (target.HEIGHT / 2)
	
	# Player is to the bottom of the camera viewport
	if tpos.z + target.HEIGHT / 2 > cpos.z + bottom_right.y:
		target.global_position.z = cpos.z + bottom_right.y - (target.HEIGHT / 2)
		
	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = top_left.x
	var right:float = bottom_right.x
	var top:float = top_left.y
	var bottom:float = bottom_right.y
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	# top right to bottom right
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	# bottom right to bottom left
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	# bottom left to top left
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	# top left to top right
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()

	
