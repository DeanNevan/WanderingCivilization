extends Node

signal combination_draw_done
signal _gamedata_init_done
signal _element_init_done
signal _player_combination_init_done
signal _player_resources_init_done
signal _player_init_done

var camera

onready var TimeSpeed = get_node("GUI/MainInGameGUI/Whole/Right/TimeSpeed")

onready var player_combination = $World/Player/PlayerCombination

func _ready():
	randomize()
	_game_init()
	

func _process(delta):
	pass

###游戏初始化###
func _game_init():
	_player_init()
	


###玩家初始化###
func _player_init(player_combination_draw_settings = [30, [], Global.COMBINATION_DRAW_SETTINGS_MODE.RANDOM]):
	player_combination.combination_draw_init(player_combination_draw_settings)
	pass

func set_camera(_camera):
	camera = _camera
	camera.current = true

