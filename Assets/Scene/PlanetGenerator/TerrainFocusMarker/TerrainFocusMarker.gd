extends Node3D
class_name TerrainFocusMarker

enum Status{
	NORMAL = 0,
	VIVID = 1,
	SURGE = 2,
}
var status := Status.NORMAL
func change_status(_status):
	status = _status
	match status:
		Status.NORMAL:
			_AnimationPlayer.play("RESET")
		Status.VIVID:
			_AnimationPlayer.play("breathe")
		Status.SURGE:
			_AnimationPlayer.play("surge")

var enabled := false

@onready var _MeshInstance3D = $MeshInstance3D
@onready var _MeshInstance3D2 = $MeshInstance3D2
@onready var _AnimationPlayer = $AnimationPlayer
@onready var mesh : ArrayMesh = _MeshInstance3D.mesh
var mdt := MeshDataTool.new()
var terrain : PlanetTerrain
var corners := [
	[0, 1, 2, 3],
	[8, 9, 10],
	[14, 15, 16],
	[20, 21, 22],
	[26, 27, 28],
	[32, 33, 34],
]
var corners_high := [
	[4, 5, 6, 7],
	[11, 12, 13],
	[17, 18, 19],
	[23, 24, 25],
	[29, 30, 31],
	[35, 36, 37],
]
var inners := [
	[38, 39, 40, 41],
	[46, 47, 48],
	[52, 53, 54],
	[58, 59, 60],
	[64, 65, 66],
	[70, 71, 72],
]
var inners_high := [
	[42, 43, 44, 45],
	[49, 50, 51],
	[55, 56, 57],
	[61, 62, 63],
	[67, 68, 69],
	[73, 74, 75],
]

func _ready():
	#mdt.create_from_surface(mesh, 0)
	pass

func set_terrain(_terrain : PlanetTerrain):
	if _terrain != terrain:
		terrain = _terrain
		update_mdt()

func change_status_normal():
	change_status(Status.NORMAL)

func change_status_vivid():
	change_status(Status.VIVID)

func change_status_surge():
	change_status(Status.SURGE)

func update_mdt():
	mdt.create_from_surface(mesh, 0)
	
	var offset := Vector3()
	if terrain.has_liquid():
		var r : float = terrain.planet.radius_rate
		var delta_height_level = terrain.get_liquid().liquid_area.height_level - terrain.height_level
		#offset = a - b
		offset = terrain.get_center().normalized() * delta_height_level * terrain.planet.HEIGHT_EACH_LEVEL
		#offset *= 1.1
	
	var center : Vector3 = terrain.get_center() + offset
	
	var tran := Transform3D(
		Basis(terrain.get_axis_x(), terrain.polygon.normal, terrain.polygon.normal.cross(terrain.get_axis_x())),
		center
	)
	_MeshInstance3D.material_override.set_shader_parameter("transform", tran)
	
	_MeshInstance3D2.position = terrain.get_center()
	
	var vertexes : Array = terrain.get_corner_vertexes_via_round(0)
	for v_idx in vertexes.size():
		var new_pos : Vector3 = vertexes[v_idx].pos + vertexes[v_idx].pos.normalized() * 0.02
		#new_pos -= center
		for i in corners[v_idx]:
			mdt.set_vertex(i, new_pos)
		for i in corners_high[v_idx]:
			mdt.set_vertex(i, new_pos + 2 * terrain.polygon.normal)
		var new_pos_inner : Vector3 = new_pos + (terrain.get_center() - vertexes[v_idx].pos) * 0.01
		for i in inners[v_idx]:
			mdt.set_vertex(i, new_pos_inner)
		for i in inners_high[v_idx]:
			mdt.set_vertex(i, new_pos_inner + 2 * terrain.polygon.normal)
	if vertexes.size() == 5:
		for i in corners[5].size():
			mdt.set_vertex(corners[5][i], mdt.get_vertex(corners[4][i]))
		for i in corners_high[5].size():
			mdt.set_vertex(corners_high[5][i], mdt.get_vertex(corners_high[4][i]))
		for i in inners[5].size():
			mdt.set_vertex(inners[5][i], mdt.get_vertex(inners[4][i]))
		for i in inners_high[5].size():
			mdt.set_vertex(inners_high[5][i], mdt.get_vertex(inners_high[4][i]))
	var new_mesh := ArrayMesh.new()
	mdt.commit_to_surface(new_mesh)
	$MeshInstance3D.mesh = new_mesh

func enable():
	enabled = true
	show()

func disable():
	enabled = false
	hide()

func set_and_enable(_terrain : PlanetTerrain):
	set_terrain(_terrain)
	enable()
	change_status_vivid()
