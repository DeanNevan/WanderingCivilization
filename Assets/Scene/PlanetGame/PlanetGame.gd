extends Node3D
class_name PlanetGame

@onready var _CivilizationPlayer = $CivilizationPlayer
@onready var _OrbitCamera = $CameraOrigin/OrbitCamera

var planet : Planet
func set_planet(_planet):
	planet = _planet

func init():
	_CivilizationPlayer.planet = planet
