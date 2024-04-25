extends Node3D
class_name PlanetGame

@onready var _CardHandUI = $GUI/CardHandUI
@onready var _CardElementConfirmation = $GUI/CardElementConfirmation
@onready var _TerritoryDisplayer = $TerritoryDisplayer
@onready var _LabelTurnCount = $GUI/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/ListCivilizationAssetItem/MarginContainer/HBoxContainer/LabelTurnCount
@onready var _ButtonEndPlayerTurn = $GUI/MarginContainer/VBoxContainer/ButtonEndPlayerTurn
@onready var _TerrainSelectionMenu = $GUI/TerrainSelectionMenu

@onready var _civilization_asset_items := [
	$GUI/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/ListCivilizationAssetItem/VBoxContainer/MainCivilizationAssetItem,
	$GUI/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/ListCivilizationAssetItem/VBoxContainer2/MainCivilizationAssetItem2,
	$GUI/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/ListCivilizationAssetItem/VBoxContainer3/MainCivilizationAssetItem3,
	$GUI/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/ListCivilizationAssetItem/VBoxContainer4/MainCivilizationAssetItem4,
]

@onready var _OrbitCamera = $CameraOrigin/OrbitCamera
@onready var _TurnManager : TurnManager = $TurnManager

var civilizations := []

var Scene_planet := preload("res://Assets/Scene/PlanetGenerator/Planet.tscn")

var logger : Logger = LoggerManager.register_logger(self, "Test")

var planet : Planet

	
var civilization_player : Civilization:
	set(_civilization_player):
		civilization_player = _civilization_player
		if !civilization_player.is_connected("turn_started", _on_civilization_player_turn_started):
			civilization_player.connect("turn_started", _on_civilization_player_turn_started)
		if !civilization_player.is_connected("turn_ended", _on_civilization_player_turn_ended):
			civilization_player.connect("turn_ended", _on_civilization_player_turn_ended)

func _ready():
	_on_civilization_player_turn_ended(null)
	
	Global.set_planet_game(self)
	
	_CardElementConfirmation.disable()
	
	_CardElementConfirmation.confirmed.connect(_on_card_hand_confirmed)
	
	_CardHandUI.card_selected.connect(_on_hand_card_selected)
	_CardHandUI.card_unselected.connect(_on_hand_card_unselected)
	
	_TurnManager.turn_count_changed.connect(_on_turn_count_changed)
	_TurnManager.turn_ended.connect(_on_turn_ended)
	_TurnManager.init()
	
	InputManager.connect("any_gesture", _on_input)
	#$Node.change_script(load("res://Test/Node.gd"))
	
	R.load_mod("main")
	
	planet = new_planet()
	planet.set_script(R.get_planet("@planet:main:earthlike"))
	set_planet(planet)
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

func new_planet() -> Planet:
	if is_instance_valid(planet):
		planet.queue_free()
	InputManager.change_special_work_status_id("")
	planet = Scene_planet.instantiate()
	return planet

func set_planet(_planet):
	planet = _planet
	if !planet.terrain_selected.is_connected(_on_terrain_selected):
		planet.terrain_selected.connect(_on_terrain_selected)
	if !planet.terrain_unselected.is_connected(_on_terrain_unselected):
		planet.terrain_unselected.connect(_on_terrain_unselected)
	planet.planet_game = self
	add_child(_planet)

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

func update_terrain_selection_menu():
	if _CardElementConfirmation.enabled || !is_instance_valid(planet.get_selected_terrain()):
		_TerrainSelectionMenu.disable()
		return
	if InputManager.special_work_status_id == "ability_selecting_terrain":
		_TerrainSelectionMenu.disable()
		return
	_TerrainSelectionMenu.terrain = planet.get_selected_terrain()
	_TerrainSelectionMenu.init()
	_TerrainSelectionMenu.enable()

func use_card(card : Card, terrain : PlanetTerrain = null):
	_CardElementConfirmation.disable()
	if is_instance_valid(civilization_player):
		_CardHandUI.remove_card(card)
		civilization_player.card_hand.remove_card(card)
		if card is CardElement:
			card.use(terrain)
	pass

func _on_hand_card_selected(_card : Card):
	update_card_confirmation()
	update_terrain_selection_menu()
	pass

func _on_hand_card_unselected(_card : Card):
	update_card_confirmation()
	update_terrain_selection_menu()
	pass

func _on_terrain_selected(_terrain : PlanetTerrain):
	update_card_confirmation()
	update_terrain_selection_menu()
	pass

func _on_terrain_unselected(_terrain : PlanetTerrain):
	update_card_confirmation()
	update_terrain_selection_menu()
	pass


func _on_button_add_building_material_pressed():
	if is_instance_valid(civilization_player):
		civilization_player.asset_manager.add_asset("@asset::building_material", 1)
	pass # Replace with function body.


func _on_button_add_labor_force_pressed():
	if is_instance_valid(civilization_player):
		civilization_player.asset_manager.add_asset("@asset::labor_force", 1)
	pass # Replace with function body.


func _on_button_add_food_pressed():
	if is_instance_valid(civilization_player):
		civilization_player.asset_manager.add_asset("@asset::food", 1)
	pass # Replace with function body.


func _on_button_add_research_point_pressed():
	if is_instance_valid(civilization_player):
		civilization_player.asset_manager.add_asset("@asset::research_point", 1)
	pass # Replace with function body.

func _on_card_hand_confirmed(card : CardElement, terrain : PlanetTerrain):
	use_card(card, terrain)


func _on_check_button_civilization_territory_toggled(toggled_on):
	_TerritoryDisplayer.enable() if toggled_on else _TerritoryDisplayer.disable()

func _on_turn_count_changed(_new_turn_count : int):
	_LabelTurnCount.text = str(_new_turn_count)


func _on_button_end_player_turn_pressed():
	civilization_player.end_turn_operation()
	pass # Replace with function body.

func _on_civilization_player_turn_started(_civilization):
	_ButtonEndPlayerTurn.disabled = false
	pass

func _on_civilization_player_turn_ended(_civilization):
	_ButtonEndPlayerTurn.disabled = true
	pass

func _on_turn_ended():
	_TurnManager.start_new_turn()
