extends Object
class_name CardGroup

signal card_added(deck, card)
signal card_removed(deck, card)
signal card_changed(deck, card)

var civilization : Civilization
var cards := []

func _init(_civilization):
	civilization = _civilization

func add_card(card : Card):
	cards.append(card)
	card_added.emit(self, card)
	card_changed.emit(self, card)

func remove_card(card : Card):
	if cards.has(card):
		cards.erase(card)
		card_removed.emit(self, card)
		card_changed.emit(self, card)
		card.delete()
