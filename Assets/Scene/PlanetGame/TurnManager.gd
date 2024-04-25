extends Node3D
class_name TurnManager

signal turn_count_changed(new_turn_count)
signal civilization_turn_operation_started(civilization)
signal civilization_turn_operation_ended(civilization)
signal turn_ended

@export_node_path("PlanetGame") var planet_game_node_path
@onready var planet_game : PlanetGame = get_node(planet_game_node_path)

enum TurnStatus {
	DEFAULT = 0,
	PLAYER = 1,
	OTHER = 2,
}
var turn_status : TurnStatus = TurnStatus.DEFAULT

var turn_count := 0



func init():
	turn_count = 0
	turn_count_changed.emit(turn_count)
	turn_status = TurnStatus.DEFAULT

func start_new_turn():
	turn_count += 1
	turn_count_changed.emit(turn_count)
	for c in planet_game.civilizations:
		if c.id == "@civilization::player":
			turn_status = TurnStatus.PLAYER
		else:
			turn_status = TurnStatus.OTHER
		c.start_turn_operation()
		civilization_turn_operation_started.emit(c)
		await c.turn_ended
		civilization_turn_operation_ended.emit(c)
	turn_ended.emit()
