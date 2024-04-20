extends MarginContainer

@onready var _HBoxContainer = $HBoxContainer

var Scene_CardCostMarker := preload("res://Assets/Scene/GUI/Card/CardCostMarker.tscn")

var order := [
	"@asset::building_material",
	"@asset::labor_force",
	"@asset::food",
	"@asset::research_point",
]

var card : Card

var cost := {}

var is_markers_invalid := false

func set_markers_invalid():
	is_markers_invalid = true
	for j in _HBoxContainer.get_children():
		j.set_valid(false)

func reorder():
	for i in order.size():
		for j in _HBoxContainer.get_children():
			if j.asset_id == order[i]:
				_HBoxContainer.move_child(j, i)
				break

func update_all():
	if visible:
		if is_markers_invalid:
			for j in _HBoxContainer.get_children():
				j.set_valid(false)
		else:
			for j in _HBoxContainer.get_children():
				j.set_valid(
					card.civilization.asset_manager.can_consume_asset(j.asset_id, j.value)
				)

func init():
	cost = card.get_cost()
	for i in _HBoxContainer.get_children():
		i.queue_free()
	for c_id in cost:
		var new_card_cost_marker = Scene_CardCostMarker.instantiate()
		_HBoxContainer.add_child(new_card_cost_marker)
		new_card_cost_marker.init(c_id, cost[c_id])
	reorder()
	if cost.size() == 0:
		hide()
	else:
		show()
	update_all()

func set_card(_card):
	card = _card

