extends CardElement
class_name CardArtificial

class RequirementCost:
	extends Requirement
	var card : CardArtificial
	func _init(_card):
		card = _card
	func _to_string():
		return tr("@str::cost")
	func check(_terrain) -> bool:
		if card.civilization.asset_manager.can_consume_assets(card.cost):
			return true
		return false

func init():
	super.init()
	requirements.push_front(RequirementCost.new(
		self
	))

func init_cost():
	super.init_cost()
	cost = {}
	var artificial : TerrainArtificial = element_instance
	for c in artificial.create_cost:
		cost[c] = artificial.create_cost[c]

