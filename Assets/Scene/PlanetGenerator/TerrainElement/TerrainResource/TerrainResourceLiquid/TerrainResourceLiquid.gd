extends TerrainResource
class_name TerrainResourceLiquid

var liquid_area : PlanetLiquidArea

var material_id : String

func _init():
	super._init()
	type_name = "@str::liquid_type_name"
	layer = 0
