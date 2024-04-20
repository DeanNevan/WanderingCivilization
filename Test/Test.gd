extends Node3D

@onready var _SpinBoxScaleLevel = $VBoxContainer/HBoxContainer/SpinBoxScaleLevel
@onready var _SpinBoxResourceRichness = $VBoxContainer/HBoxContainer2/SpinBoxResourceRichness
@onready var _SpinBoxModificationStrength = $VBoxContainer/HBoxContainer3/SpinBoxModificationStrength
@onready var _SpinBoxFlatLevel = $VBoxContainer/HBoxContainer4/SpinBoxFlatLevel
@onready var _SpinBoxHeightLevel = $VBoxContainer/HBoxContainer5/SpinBoxHeightLevel
@onready var _SpinBoxThresholdDecrease = $VBoxContainer/HBoxContainer6/SpinBoxThresholdDecrease
@onready var _SpinBoxThresholdIncrease = $VBoxContainer/HBoxContainer7/SpinBoxThresholdIncrease
@onready var _LineEditRandomSeed = $VBoxContainer/HBoxContainer8/LineEditRandomSeed
@onready var _PlanetGame = $PlanetGame
@onready var _CardHandUI = $CardHandUI
@onready var _CardElementConfirmation = $CardElementConfirmation
@onready var _ListCivilizationAssetItem = $MarginContainer/MarginContainer/ListCivilizationAssetItem

var Scene_planet := preload("res://Assets/Scene/PlanetGenerator/Planet.tscn")

var logger : Logger = LoggerManager.register_logger(self, "Test")

var planet : Planet
var civilization : Civilization

func _ready():
	_CardElementConfirmation.disable()
	
	_CardElementConfirmation.confirmed.connect(_on_card_hand_confirmed)
	
	_CardHandUI.card_selected.connect(_on_hand_card_selected)
	_CardHandUI.card_unselected.connect(_on_hand_card_unselected)
	
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
	_CardHandUI.clear()
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
	_PlanetGame.set_planet(planet)
	
	planet.terrain_selected.connect(_on_terrain_selected)
	planet.terrain_unselected.connect(_on_terrain_unselected)
	
	civilization = Civilization.new()
	civilization.set_planet(planet)
	civilization.init()
	#civilization.asset_manager.add_asset("@asset::building_material", 10)
	#civilization.asset_manager.add_asset("@asset::labor_force", 2)
	
	_CardHandUI.set_civilization(civilization)
	
	for i in _ListCivilizationAssetItem.get_children():
		i.set_civilization(civilization)
		i.init()
	
	var new_card : Card = R.get_card("@card:main:building_lumbering").new()
	new_card.add_to_hand(civilization)
	new_card.init()
	
	var new_card2 : Card = R.get_card("@card:main:building_lumbering").new()
	new_card2.add_to_hand(civilization)
	new_card2.init()
	
	
	
	_CardHandUI.add_card(new_card)
	_CardHandUI.add_card(new_card2)
	

func _on_input(_sig : String, e : InputEventAction):
	if e is InputEventSingleScreenTap:
		pass
	pass

func update_card_confirmation():
	var selected_card : Card = _CardHandUI.get_selected_card()
	var selected_terrain : PlanetTerrain = planet.get_selected_terrain()
	if !is_instance_valid(selected_card) || !is_instance_valid(selected_terrain):
		_CardElementConfirmation.disable()
	elif selected_card is CardElement:
		_CardElementConfirmation.set_card(selected_card)
		_CardElementConfirmation.set_terrain(selected_terrain)
		_CardElementConfirmation.init()
		_CardElementConfirmation.enable()

func _on_hand_card_selected(_card : Card):
	update_card_confirmation()
	pass

func _on_hand_card_unselected(_card : Card):
	update_card_confirmation()
	pass

func _on_terrain_selected(_terrain : PlanetTerrain):
	update_card_confirmation()
	pass

func _on_terrain_unselected(_terrain : PlanetTerrain):
	update_card_confirmation()
	pass


func _on_button_add_building_material_pressed():
	if is_instance_valid(civilization):
		civilization.asset_manager.add_asset("@asset::building_material", 1)
	pass # Replace with function body.


func _on_button_add_labor_force_pressed():
	if is_instance_valid(civilization):
		civilization.asset_manager.add_asset("@asset::labor_force", 1)
	pass # Replace with function body.


func _on_button_add_food_pressed():
	if is_instance_valid(civilization):
		civilization.asset_manager.add_asset("@asset::food", 1)
	pass # Replace with function body.


func _on_button_add_research_point_pressed():
	if is_instance_valid(civilization):
		civilization.asset_manager.add_asset("@asset::research_point", 1)
	pass # Replace with function body.

func _on_card_hand_confirmed(card : CardElement, terrain : PlanetTerrain):
	_CardElementConfirmation.disable()
	if is_instance_valid(civilization):
		_CardHandUI.remove_card(card)
		civilization.card_hand.remove_card(card)
		terrain.add_element(card.element_instance)
	pass
