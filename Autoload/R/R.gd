extends Node

var TriangulatedHexagon := preload("res://Assets/Model/TriangulatedPlane/TriangulatedHexagon.glb")
var TriangulatedPentagon := preload("res://Assets/Model/TriangulatedPlane/TriangulatedPentagon.glb")
var SimpleTriangular := preload("res://Assets/Model/SimplePlane/SimpleTriangle.glb")

var Scene_PlanetTerrain := preload("res://Assets/Scene/PlanetGenerator/PlanetTerrain/PlanetTerrain.tscn")
var Scene_Planet := preload("res://Assets/Scene/PlanetGenerator/Planet.tscn")

var planets_preload := {
	
}

var loaded_mods := {
	
}

var loaded_batch_objects := {
	
}

var terrains := {
	"@terrain::default" : preload("res://Assets/Scene/PlanetGenerator/PlanetTerrain/PlanetTerrain.gd")
}

var materials := {
	"@material::default" : preload("res://Assets/Material/default_material_for_terrain.tres")
}

var planets := {
	"@planet::default" : preload("res://Assets/Scene/PlanetGenerator/Planet.gd")
}

var liquid_areas := {
	"@liquid_area::default" : preload("res://Assets/Scene/PlanetGenerator/TerrainElement/TerrainResource/TerrainResourceLiquid/PlanetLiquidArea/PlanetLiquidArea.gd")
	
}

var planet_handlers := {
	"@planet_handler::copy_based_initial" : preload("res://Assets/Scene/PlanetGenerator/PlanetHandler/PH_CopyBasedInitial/PH_CopyBasedInitial.gd"),
	"@planet_handler::noise_based_height_level_modifier" : preload("res://Assets/Scene/PlanetGenerator/PlanetHandler/PH_NoiseBasedHeightLevelModifier/PH_NoiseBasedHeightLevelModifier.gd"),
	"@planet_handler::height_based_terrain_modifier" : preload("res://Assets/Scene/PlanetGenerator/PlanetHandler/PH_HeightBasedTerrainModifier/PH_HeightBasedTerrainModifier.gd"),
	"@planet_handler::area_based_liquid_generator" : preload("res://Assets/Scene/PlanetGenerator/PlanetHandler/PH_AreaBasedLiquidGenerator/PH_AreaBasedLiquidGenerator.gd"),
	"@planet_handler::element_based_terrain_modifier" : preload("res://Assets/Scene/PlanetGenerator/PlanetHandler/PH_ElementBasedTerrainModifier/PH_ElementBasedTerrainModifier.gd"),
	"@planet_handler::factor_based_placement_generator" : preload("res://Assets/Scene/PlanetGenerator/PlanetHandler/PH_FactorBasedPlacementGenerator/PH_FactorBasedPlacementGenerator.gd"),
}

var env_factors := {
	"@env_factor::default" : preload("res://Assets/Scene/PlanetGenerator/TerrainEnvironmentFactor/TerrainEnvironmentFactor.gd")
}

var env_factor_instances := {
	
}

var batch_objects := {
	
}

var elements := {
	"@element::default" : preload("res://Assets/Scene/PlanetGenerator/TerrainElement/TerrainElement.gd")
}

var elements_instances := {
}

var meshes := {
	"@mesh::default" : preload("res://Assets/Model/Test/Cube.res")
}

var scenes := {
	"@scene::default" : preload("res://Assets/Model/Test/Cube.glb")
}

var assets := {
	"@asset::building_material" : preload("res://Assets/Scene/Civilization/CivilizationAsset/CivilizationAssetBuildingMaterial.gd"),
	"@asset::food" : preload("res://Assets/Scene/Civilization/CivilizationAsset/CivilizationAssetFood.gd"),
	"@asset::labor_force" : preload("res://Assets/Scene/Civilization/CivilizationAsset/CivilizationAssetLaborForce.gd"),
	"@asset::research_point" : preload("res://Assets/Scene/Civilization/CivilizationAsset/CivilizationAssetResearchPoint.gd"),
}

var assets_instances := {
}

var cards := {
	"@card::default" : preload("res://Assets/Scene/Card/Card.gd")
}

func get_card(id : String) -> GDScript:
	if cards.get(id) != null:
		return cards.get(id)
	else:
		logger.error("Unable to find card(%s)" % id)
		return cards.get("@card::default")

func get_asset(id : String) -> GDScript:
	if assets.get(id) != null:
		return assets.get(id)
	else:
		logger.error("Unable to find asset(%s)" % id)
		return assets.get("@asset::default")

func new_batch_object(id : String):
	if loaded_batch_objects.has(id):
		return loaded_batch_objects[id].copy()
	else:
		if batch_objects.has(id):
			var new_object : BatchObject = batch_objects[id].instantiate()
			loaded_batch_objects[id] = new_object
			var copied : BatchObject = new_object.copy()
			return copied

func get_terrain(id : String) -> GDScript:
	if terrains.get(id) != null:
		return terrains.get(id)
	else:
		logger.error("Unable to find terrain(%s)" % id)
		return terrains.get("@terrain::default")

func get_material(id : String) -> Material:
	if materials.get(id) != null:
		return materials.get(id)
	else:
		logger.error("Unable to find material(%s)" % id)
		return materials.get("@material::default")

func get_liquid_area(id : String) -> GDScript:
	if liquid_areas.get(id) != null:
		return liquid_areas.get(id)
	else:
		logger.error("Unable to find liquid_area(%s)" % id)
		return liquid_areas.get("@liquid_area::default")

func get_planet(id : String) -> GDScript:
	if planets.get(id) != null:
		return planets.get(id)
	else:
		logger.error("Unable to find planet(%s)" % id)
		return planets.get("@planet::default")

func get_env_factor(id : String) -> GDScript:
	if env_factors.get(id) != null:
		return env_factors.get(id)
	else:
		logger.error("Unable to find env_factor(%s)" % id)
		return env_factors.get("@env_factor::default")

func get_env_factor_instance(id : String) -> TerrainEnvironmentFactor:
	if env_factor_instances.get(id) != null:
		return env_factor_instances.get(id)
	else:
		logger.error("Unable to find env_factor_instance(%s)" % id)
		return env_factor_instances.get("@env_factor::default")

func get_planet_handler(id : String) -> GDScript:
	if planet_handlers.get(id) != null:
		return planet_handlers.get(id)
	else:
		logger.error("Unable to find planet_handler(%s)" % id)
		return null

func get_element(id : String) -> GDScript:
	if elements.get(id) != null:
		return elements.get(id)
	else:
		logger.error("Unable to find element(%s)" % id)
		return elements.get("@element::default")

func get_element_instance(id : String) -> TerrainElement:
	if elements_instances.get(id) != null:
		return elements_instances.get(id)
	else:
		logger.error("Unable to find element_instance(%s)" % id)
		return elements_instances.get("@element::default")

func get_asset_instance(id : String) -> CivilizationAsset:
	if assets_instances.get(id) != null:
		return assets_instances.get(id)
	else:
		logger.error("Unable to find asset_instance(%s)" % id)
		return assets_instances.get("@asset::default")

func get_mesh(id : String):
	if meshes.get(id) != null:
		return meshes.get(id)
	else:
		logger.error("Unable to find mesh(%s)" % id)
		return meshes.get("@mesh::default")

func get_scene(id : String) -> PackedScene:
	if scenes.get(id) != null:
		return scenes.get(id)
	else:
		logger.error("Unable to find scene(%s)" % id)
		return scenes.get("@scene::default")

var default_material_for_terrain := preload("res://Assets/Material/default_material_for_terrain.tres")

var logger : Logger = LoggerManager.register_logger(self, "R")

func _ready():
	init_planets_preload(false, true)

func init_planets_preload(do_save := false, do_load := false):
	for _scale_level in range(1, 4):
		logger.debug("%s星球地形数据(规模%d)" % ["读取" if do_load else "重计算", _scale_level])
		var time_start : int = Time.get_ticks_msec()
		
		var new_planet : Planet = Scene_Planet.instantiate()
		new_planet.scale_level = _scale_level
		new_planet.init_grid()
		add_child(new_planet)
		for _polygon in new_planet.grid.polygons:
			var polygon : SphereGrid.Polygon = _polygon
			var new_terrain : PlanetTerrain = Scene_PlanetTerrain.instantiate()
			new_planet.add_terrain(new_terrain)
			new_terrain.polygon = polygon
			new_terrain.planet = new_planet
			new_terrain.polygon.terrain = new_terrain
		planets_preload[_scale_level] = new_planet
		
		
		if do_load:
			var file : FileAccess = FileAccess.open("res://Assets/ConstantData/PlanetData/PlanetData_%d.json" % _scale_level, FileAccess.READ)
			var content : String = file.get_as_text()
			var json := JSON.new()
			var error : int = json.parse(content)
			if error == OK:
				var data : Dictionary = json.data
				for t_data_i in data["t"].size():
					var t_data = data["t"][t_data_i]
					var terrain : PlanetTerrain = new_planet.terrains[t_data_i]
					for fi_data in t_data["fi"]:
						terrain.faces_idx.append(Vector3i(
							fi_data[0],
							fi_data[1],
							fi_data[2],
						))
				
					for v_data in t_data["v"]:
						terrain.add_vertex(Vector3(
							v_data["p"][0],
							v_data["p"][1],
							v_data["p"][2],
						))
				
				for t_data_i in data["t"].size():
					var t_data = data["t"][t_data_i]
					var terrain : PlanetTerrain = new_planet.terrains[t_data_i]
					
					for ntsfi in t_data["ntsfi"]:
						terrain.neighbour_to_self_faces_idx[new_planet.terrains[int(ntsfi)].polygon] = []
						for i in t_data["ntsfi"][ntsfi]:
							terrain.neighbour_to_self_faces_idx[new_planet.terrains[int(ntsfi)].polygon].append(i)
					
					for v_data_i in t_data["v"].size():
						var v_data = t_data["v"][v_data_i]
						if v_data.has("ov"):
							for ov_data in v_data["ov"]:
								var target_terrain : PlanetTerrain = new_planet.terrains[ov_data[0]]
								var target_vertex : PlanetTerrain.Vertex = target_terrain.vertexes[ov_data[1]]
								terrain.vertexes[v_data_i].overlap_vertexes.append(target_vertex)
			else:
				print("JSON Parse Error: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())
		else:
			for terrain in new_planet.terrains:
				terrain.init()
		
		if do_save:
			var data := {}
			data["sl"] = _scale_level
			data["t"] = []
			var c := 0
			for t in new_planet.terrains:
				data["t"].append({
					"ntsfi" : {},
					"v" : [],
					"fi" : [],
				})
				for n in t.neighbour_to_self_faces_idx:
					data["t"][c]["ntsfi"][n.idx] = t.neighbour_to_self_faces_idx[n]
				var cc := 0
				for v in t.vertexes:
					data["t"][c]["v"].append({
						"p" : [v.pos.x, v.pos.y, v.pos.z],
						"ov" : []
					})
					for vv in v.overlap_vertexes:
						data["t"][c]["v"][cc]["ov"].append([vv.terrain.idx, vv.idx])
					if data["t"][c]["v"][cc]["ov"].size() == 0:
						data["t"][c]["v"][cc].erase("ov")
					
					cc += 1
				
				for f in t.faces_idx:
					data["t"][c]["fi"].append([f.x, f.y, f.z])
				
				c += 1
			
			var json_string = JSON.stringify(data)
			var file : FileAccess = FileAccess.open("res://Assets/ConstantData/PlanetData/PlanetData_%d.json" % _scale_level, FileAccess.WRITE)
			file.store_string(json_string)
			file.close()
		var time_end : int = Time.get_ticks_msec()
		logger.debug("耗时:%dms" % (time_end - time_start))

func load_mod(mod_id : String):
	if loaded_mods.has(mod_id):
		logger.error("load mod error:repeat load(%s)" % mod_id)
		return
	
	var path : String = "res://Mod/%s/" % mod_id
	if !DirAccess.dir_exists_absolute(path):
		logger.error("load mod error:no such path(%s)" % mod_id)
		return
	
	var dir := DirAccess.open(path)
	if !dir.file_exists("Mod.gd"):
		logger.error("load mod error:no such Mod.gd(%s)" % mod_id)
		return
	
	var mod_gd : Object = load(path + "Mod.gd").new()
	for t_id in mod_gd.terrains:
		terrains[t_id] = load(mod_gd.terrains[t_id])
	for m_id in mod_gd.materials:
		materials[m_id] = load(mod_gd.materials[m_id])
	for p_id in mod_gd.planets:
		planets[p_id] = load(mod_gd.planets[p_id])
	for l_id in mod_gd.liquid_areas:
		liquid_areas[l_id] = load(mod_gd.liquid_areas[l_id])
	for p_id in mod_gd.planet_handlers:
		planet_handlers[p_id] = load(mod_gd.planet_handlers[p_id])
	for e_id in mod_gd.elements:
		elements[e_id] = load(mod_gd.elements[e_id])
		elements_instances[e_id] = elements[e_id].new()
	for e_id in mod_gd.env_factors:
		env_factors[e_id] = load(mod_gd.env_factors[e_id])
	for m_id in mod_gd.meshes:
		meshes[m_id] = load(mod_gd.meshes[m_id])
	for s_id in mod_gd.scenes:
		scenes[s_id] = load(mod_gd.scenes[s_id])
	for b_id in mod_gd.batch_objects:
		batch_objects[b_id] = load(mod_gd.batch_objects[b_id])
	for a_id in mod_gd.assets:
		assets[a_id] = load(mod_gd.assets[a_id])
	for c_id in mod_gd.cards:
		cards[c_id] = load(mod_gd.cards[c_id])
	
	for i in mod_gd.translations:
		TranslationServer.add_translation(load(i))
	
	for i in env_factors:
		env_factor_instances[i] = env_factors[i].new()
	
	for i in assets:
		assets_instances[i] = assets[i].new()
	
	loaded_mods[mod_id] = mod_gd
	pass
