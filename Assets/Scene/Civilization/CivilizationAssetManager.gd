extends Node
class_name CivilizationAssetManager

signal asset_used_out(asset)
signal asset_changed(asset)
signal asset_increased(asset)
signal asset_decreased(asset)

var assets := {
	
}

func init_assets():
	assets.clear()
	assets["@asset::building_material"] = R.get_asset("@asset::building_material").new()
	assets["@asset::food"] = R.get_asset("@asset::food").new()
	assets["@asset::labor_force"] = R.get_asset("@asset::labor_force").new()
	assets["@asset::research_point"] = R.get_asset("@asset::research_point").new()
	
	for id in assets:
		assets[id].used_out.connect(_on_asset_used_out)
		assets[id].changed.connect(_on_asset_changed)
		assets[id].increased.connect(_on_asset_increased)
		assets[id].decreased.connect(_on_asset_decreased)

func add_asset(id : String, value : int):
	if assets.has(id):
		assets[id].add(value)

func can_consume_assets(_assets : Dictionary) -> bool:
	for id in _assets:
		if assets.has(id):
			if !can_consume_asset(id, _assets[id]):
				return false
		else:
			return false
	return true

func can_consume_asset(id : String, value : int) -> bool:
	if assets.has(id):
		return assets[id].can_consume(value)
	return false

func consume_asset(id : String, value : int):
	if can_consume_asset(id, value):
		assets[id].consume(value)

func _on_asset_used_out(_asset : CivilizationAsset):
	asset_used_out.emit(_asset)

func _on_asset_changed(_asset : CivilizationAsset):
	asset_changed.emit(_asset)

func _on_asset_increased(_asset : CivilizationAsset):
	asset_increased.emit(_asset)

func _on_asset_decreased(_asset : CivilizationAsset):
	asset_decreased.emit(_asset)
