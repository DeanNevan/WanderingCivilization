extends Node3D

@onready var _SpinBoxScaleLevel = $VBoxContainer/HBoxContainer/SpinBoxScaleLevel
@onready var _SpinBoxResourceRichness = $VBoxContainer/HBoxContainer2/SpinBoxResourceRichness
@onready var _SpinBoxModificationStrength = $VBoxContainer/HBoxContainer3/SpinBoxModificationStrength
@onready var _SpinBoxFlatLevel = $VBoxContainer/HBoxContainer4/SpinBoxFlatLevel
@onready var _SpinBoxHeightLevel = $VBoxContainer/HBoxContainer5/SpinBoxHeightLevel
@onready var _SpinBoxThresholdDecrease = $VBoxContainer/HBoxContainer6/SpinBoxThresholdDecrease
@onready var _SpinBoxThresholdIncrease = $VBoxContainer/HBoxContainer7/SpinBoxThresholdIncrease
@onready var _LineEditRandomSeed = $VBoxContainer/HBoxContainer8/LineEditRandomSeed
@onready var planet_game : PlanetGame = $PlanetGame


func _on_button_generate_pressed():
	planet_game._CardHandUI.clear()
	var planet : Planet = planet_game.new_planet()
	planet.set_script(R.get_planet("@planet:main:earthlike"))
	planet_game.set_planet(planet)
	
	if _LineEditRandomSeed.text.length() == 0:
		planet.rander_for_generation.seed = int(Time.get_unix_time_from_system())
	else:
		planet.rander_for_generation.seed = hash(planet_game._LineEditRandomSeed.text)
	
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
	
	planet_game.civilization_player = Civilization.new()
	planet_game.civilization_player.set_planet(planet)
	planet_game.civilization_player.init()
	
	planet_game._TerritoryDisplayer.set_territory_manager(planet_game.civilization_player.territory_manager)
	planet_game.civilization_player.asset_manager.add_asset("@asset::building_material", 10)
	planet_game.civilization_player.asset_manager.add_asset("@asset::labor_force", 10)
	planet_game.civilization_player.asset_manager.add_asset("@asset::food", 10)
	planet_game.civilization_player.asset_manager.add_asset("@asset::research_point", 10)
	
	planet_game.civilizations.append(planet_game.civilization_player)
	
	planet_game._CardHandUI.set_civilization(planet_game.civilization_player)
	
	for i in planet_game._civilization_asset_items:
		i.set_civilization(planet_game.civilization_player)
		i.init()
	
	var cards_id := [
		"@card:main:building_ship_lander",
		"@card:main:building_lumbering",
		"@card:main:building_artificial_forest",
		"@card:main:building_rock_drill_station",
		"@card:main:building_domitory",
		"@card:main:building_research_lab",
		"@card:main:building_watchtower",
	]
	for id in cards_id:
		var new_card : Card = R.get_card(id).new()
		new_card.add_to_hand(planet_game.civilization_player)
		new_card.init()
		planet_game._CardHandUI.add_card(new_card)
	
	planet_game._TurnManager.init()
	planet_game._TurnManager.start_new_turn()
