extends Node
class_name Card

class Modification:
	
	pass

@export var id := "@card::default"
@export var card_name := "@str::default_card_name"
@export var info := "@str::default_card_info"
@export var icon : Texture = preload("res://icon.svg")

var civilization : Civilization

var cost := {}

var requirements := []

func _init(_civilization = civilization):
	civilization = _civilization

func delete():
	queue_free()

func init_cost():
	pass

func init():
	pass

func get_cost():
	return cost

func set_civilization(_civilization : Civilization):
	civilization = _civilization

func add_to_deck(_civilization : Civilization = civilization):
	set_civilization(_civilization)
	civilization.card_deck.add_card(self)

func add_to_hand(_civilization : Civilization = civilization):
	set_civilization(_civilization)
	civilization.card_hand.add_card(self)

