extends TerrainArtificial
class_name TerrainBuilding

enum BuildingType{
	UNKNOWN = 0,
	CORE = 1,
	PRODUCTION = 2,
	RESOURCE = 3,
	FUNCTION = 4,
}
@export var building_type := BuildingType.UNKNOWN

func _init():
	super._init()
	type_name = "@str::building_type_name"
