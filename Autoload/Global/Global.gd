extends Node

var rander := RandomNumberGenerator.new()

var random_seed := int(Time.get_unix_time_from_system()):
	set(_random_seed):
		random_seed = _random_seed
		rander.seed = random_seed
		logger.debug("global random seed=%d" % random_seed)
	

var logger := LoggerManager.register_logger(self, "Global", Logger.Level.DEBUG)

var rander_for_decoration := RandomNumberGenerator.new()

func _ready():
	TranslationServer.set_locale("zh_CN")
	logger.debug("global random seed=%d" % random_seed)
	rander.randomize()
	rander_for_decoration.randomize()
