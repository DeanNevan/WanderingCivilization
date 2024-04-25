extends Node
class_name Civilization

signal turn_ended(civilization)
signal turn_started(civilization)

@export var id := "@civilization::player"
@export var civilization_name := ""
@export var info := ""

var planet : Planet
var asset_manager := CivilizationAssetManager.new(self)
var territory_manager := CivilizationTerritoryManager.new(self)

var card_deck := CardDeck.new(self)
var card_hand := CardHand.new(self)

func _ready():
	add_child(asset_manager)

func start_turn_operation():
	turn_started.emit(self)
	pass

func end_turn_operation():
	turn_ended.emit(self)
	pass

func set_planet(_planet):
	planet = _planet

func init():
	asset_manager.init_assets()
