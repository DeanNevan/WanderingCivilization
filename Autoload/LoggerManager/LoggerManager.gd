extends Node

var global_level : Logger.Level = Logger.Level.DEBUG

var loggers := {
	
} # Node to loggers

func register_logger(_node : Node, _master_info := "", _level := Logger.Level.DEBUG) -> Logger:
	var new_logger : Logger = Logger.new()
	new_logger.master_info = _master_info
	new_logger.level = _level
	return new_logger
