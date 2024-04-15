extends PlanetHandler
class_name PH_NoiseBasedHeightLevelModifier

var color_ramp : Gradient
var noise : FastNoiseLite
var noise_image : Image
var noise_texture : NoiseTexture2D
var texture_rect : TextureRect

@export_range(32, 1024, 1)
var noise_rect_size := 512 # 噪声图尺寸
@export_range(0, 1, 0.01)
var flat_level := 0.5 # 平的程度，越高表示星球倾向于生成大面积的高原/海底平原等
@export_range(0, 0.5, 0.01)
var threshold_decrease := 0.1 # 降低海拔的阈值
@export_range(0.5, 1, 0.01)
var threshold_increase := 0.9 # 抬高海拔的阈值
@export_range(0, 1, 0.01)
var height_level := 0.5 # 高耸程度，越高表示星球倾向于高海拔（高山会更常见）
@export_range(1, 3, 1)
var modification_strength := 2 # 海拔修改强度

var grid : SphereGrid

var max_height := 0
var min_height := 0

var logger := LoggerManager.register_logger(self, "PH_NoiseBasedHeightLevelModifier")

func _init():
	self.id = "@planet_handler::noise_based_height_level_modifier"

func _ready():
	texture_rect = preload("res://Assets/Scene/PlanetGenerator/PlanetHandler/PH_NoiseBasedHeightLevelModifier/NoiseTexture.tscn").instantiate()
	add_child(texture_rect)
	noise_texture = texture_rect.texture
	color_ramp = noise_texture.color_ramp
	noise = noise_texture.noise

func handle_async():
	await super.handle_async()
	
	logger.debug("处理模块：基于噪声，修改海拔等级并更新网格")
	var time_start : int = Time.get_ticks_msec()
	
	texture_rect.texture.width = noise_rect_size
	texture_rect.texture.height = noise_rect_size
	noise.seed = planet.rander_for_generation.seed
	color_ramp.set_offset(0, 0.4 * flat_level)
	color_ramp.set_offset(2, 1 - 0.4 * flat_level)
	color_ramp.set_offset(1, color_ramp.get_offset(0) + (color_ramp.get_offset(2) - color_ramp.get_offset(0)) * (1 - height_level))
	
	var polygon_count : int = planet.grid.polygon_count
	
	noise_texture = texture_rect.texture
	await noise_texture.changed
	noise_image = noise_texture.get_image()
	
	var region_size := Vector2i(noise_rect_size / sqrt(polygon_count), noise_rect_size / sqrt(polygon_count))
	for i in polygon_count:
		var uv : Vector2 = planet.grid.polygons[i].uv
		var pos := Vector2i(noise_rect_size * uv.x, noise_rect_size * uv.y) - region_size / 2
		var region := Rect2i(
			pos,
			region_size
		)
		var pixel := 0.0
		for t in 10:
			var r : int = planet.rander_for_generation.randi_range(0, region_size.x * region_size.y - 1)
			var x = clamp(pos.x + r % region_size.x, 0, noise_rect_size - 1)
			var y = clamp(pos.y + r / region_size.x, 0, noise_rect_size - 1)
			pixel += noise_image.get_pixel(x, y).r
		pixel /= 10
		
		if pixel >= threshold_decrease && pixel <= threshold_increase:
			continue
		
		var modification_type := 0
		if pixel > threshold_increase:
			modification_type = 1
		else:
			modification_type = -1
		
		var center_terrain : PlanetTerrain = planet.grid.polygons[i].terrain
		var visited := [center_terrain]
		var queue := [center_terrain]
		for c in modification_strength:
			var temp := []
			while !queue.is_empty():
				var t : PlanetTerrain = queue.back()
				queue.pop_back()
				if modification_type > 0:
					t.height_level += modification_strength - c
				else:
					t.height_level -= modification_strength - c
				#for vertex in t.vertexes:
					#var vec : Vector2i = vertex.overlap_vertex
					#var overlap_terrain = planet.terrains[vec.x]
					#var overlap_vertex = overlap_terrain.vertexes[vec.y]
					#overlap_vertex.height_level = t.height_level
				for n in t.polygon.neighbours:
					if !visited.has(n.terrain):
						temp.push_back(n.terrain)
			queue = temp
	
	planet.update_mesh_data()
	
	var time_end : int = Time.get_ticks_msec()
	logger.debug("耗时:%dms" % (time_end - time_start))

