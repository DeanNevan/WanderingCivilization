extends Object
class_name Logger

enum Level{
	DEBUG = 0,
	INFO = 1,
	WARNING = 2,
	ERROR = 3,
}

var LEVEL_TO_COLOR := {
	Level.DEBUG : "gray",
	Level.INFO : "white",
	Level.WARNING : "yellow",
	Level.ERROR : "red",
}

var LEVEL_TO_NAME := {
	Level.DEBUG : "DEBUG",
	Level.INFO : "INFO",
	Level.WARNING : "WARNING",
	Level.ERROR : "ERROR",
}

var level : Level = Level.DEBUG
var master_info := ""
var enabled := true

func log_default(_content : String, _level := level):
	if !enabled || level < LoggerManager.global_level:
		return
	print_rich("[color=%s]%s | %s | %s | %s[/color]" % [
		LEVEL_TO_COLOR[_level], Time.get_datetime_string_from_system(), master_info, LEVEL_TO_NAME[_level], _content
	])

func debug(_content : String):
	log_default(_content, Level.DEBUG)

func info(_content : String):
	log_default(_content, Level.INFO)

func warning(_content : String):
	log_default(_content, Level.WARNING)

func error(_content : String):
	log_default(_content, Level.ERROR)

