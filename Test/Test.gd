extends Node3D

@onready var _SpinBoxScaleLevel = $VBoxContainer/HBoxContainer/SpinBoxScaleLevel
@onready var _SpinBoxResourceRichness = $VBoxContainer/HBoxContainer2/SpinBoxResourceRichness
@onready var _SpinBoxModificationStrength = $VBoxContainer/HBoxContainer3/SpinBoxModificationStrength
@onready var _SpinBoxFlatLevel = $VBoxContainer/HBoxContainer4/SpinBoxFlatLevel
@onready var _SpinBoxHeightLevel = $VBoxContainer/HBoxContainer5/SpinBoxHeightLevel
@onready var _SpinBoxThresholdDecrease = $VBoxContainer/HBoxContainer6/SpinBoxThresholdDecrease
@onready var _SpinBoxThresholdIncrease = $VBoxContainer/HBoxContainer7/SpinBoxThresholdIncrease
@onready var _LineEditRandomSeed = $VBoxContainer/HBoxContainer8/LineEditRandomSeed

var Scene_planet := preload("res://Assets/Scene/PlanetGenerator/Planet.tscn")

var logger : Logger = LoggerManager.register_logger(self, "Test")

var planet : Planet

func _ready():
	InputManager.connect("any_gesture", _on_input)
	#$Node.change_script(load("res://Test/Node.gd"))
	
	R.load_mod("main")
	
	planet = Scene_planet.instantiate()
	planet.set_script(R.get_planet("@planet:main:earthlike"))
	add_child(planet)
	planet.scale_level = 1
	await planet.generate_async()
	planet.queue_free()
	
	#for i in 5:
		#var _planet = Scene_planet.instantiate()
		#_planet.set_script(R.get_planet("@planet:main:earthlike"))
		#add_child(_planet)
		#_planet.scale_level = 3
		#await _planet.generate_async()
		#_planet.position = Vector3(i * 12, 0, 0)
	
	#var mul : MultiMesh = $MultiMeshInstance3D.multimesh
	#mul.set_instance_transform(0, Transform3D(Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK), Vector3(0, 0, 0)))
	#mul.set_instance_transform(1, Transform3D(Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK), Vector3(0, 1, 0)))
	#mul.set_instance_transform(2, Transform3D(Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK), Vector3(1, 0, 0)))
	#mul.set_instance_transform(3, Transform3D(Basis(Vector3.RIGHT, Vector3.UP, Vector3.BACK), Vector3(1, 1, 0)))
	#await get_tree().create_timer(3).timeout
	#mul.set_instance_transform(1, Transform3D())

func _process(_delta):
	pass
	if Input.is_action_just_pressed("key_1"):
		var a = R.new_batch_object("@batch:main:lotus")
		add_child(a)
		#$VoxelGI.call_deferred("bake")
	if Input.is_action_just_pressed("key_2"):
		if is_instance_valid(planet):
			planet._TerrainsMeshInstance.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC
			for a in planet.liquid_areas:
				a.mesh_instance.gi_mode = GeometryInstance3D.GI_MODE_DYNAMIC
	if Input.is_action_just_pressed("key_3"):
		if is_instance_valid(planet):
			planet._TerrainsMeshInstance.gi_mode = GeometryInstance3D.GI_MODE_STATIC
			for a in planet.liquid_areas:
				a.mesh_instance.gi_mode = GeometryInstance3D.GI_MODE_STATIC

func _on_button_generate_pressed():
	if is_instance_valid(planet):
		planet.queue_free()
	planet = Scene_planet.instantiate()
	planet.set_script(R.get_planet("@planet:main:earthlike"))
	add_child(planet)
	
	if _LineEditRandomSeed.text.length() == 0:
		planet.rander_for_generation.seed = int(Time.get_unix_time_from_system())
	else:
		planet.rander_for_generation.seed = hash(_LineEditRandomSeed.text)
	
	planet.scale_level = _SpinBoxScaleLevel.value
	planet.resource_richness = _SpinBoxResourceRichness.value
	var handler : PlanetHandler = planet.find_handler_by_id("@planet_handler::noise_based_height_level_modifier")
	handler.flat_level = _SpinBoxFlatLevel.value
	handler.threshold_decrease = _SpinBoxThresholdDecrease.value
	handler.threshold_increase = _SpinBoxThresholdIncrease.value
	handler.height_level = _SpinBoxHeightLevel.value
	handler.modification_strength = _SpinBoxModificationStrength.value
	await planet.generate_async()
	planet.init_interaction()
	
	#$WorldEnvironment.environment.volumetric_fog_enabled = false
	
	#$WorldEnvironment.environment.volumetric_fog_enabled = true
	pass # Replace with function body.

func _on_input(_sig : String, e : InputEventAction):
	if e is InputEventSingleScreenTap:
		pass
	pass
