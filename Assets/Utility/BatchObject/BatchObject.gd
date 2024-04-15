extends Node
class_name BatchObject

var id := "@batch::default"

func copy_to(target : BatchObject):
	pass

func copy() -> BatchObject:
	return self.duplicate()
