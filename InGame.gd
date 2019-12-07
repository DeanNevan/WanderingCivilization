extends Node
signal combination_draw_done
signal _gamedata_init_done
signal _element_init_done
signal _player_combination_init_done
signal _player_resources_init_done
signal _player_init_done

onready var player_combination = $World/Player/PlayerCombination


var times = 0
var Times = 0

func _ready():
	randomize()
	_game_init()
	

func _process(delta):
	pass

###游戏初始化###
func _game_init():
	_player_init()
	


###玩家初始化###
func _player_init(player_combination_draw_settings = [50, [], Global.COMBINATION_DRAW_SETTINGS_MODE.RANDOM], player_terrain_layers_init_settings = [[15, 2, Global.LAYERS_COUNT_SETTINGS_MODE.RANDOM], [9, 2, Global.SURFACE_LAYER_SETTINGS_MODE.RANDOM]]):
	player_combination.combination_draw_init(player_combination_draw_settings, player_terrain_layers_init_settings)
	pass



