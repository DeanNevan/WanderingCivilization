extends TerrainElement
class_name TerrainResource

signal remain_changed(resource)

var capacity := 100
var remain := 100

func _init():
	remain_changed.connect(_on_self_remain_changed)

func increase_remain(amount : int):
	if amount <= 0:
		return
	var old := remain
	remain = clamp(remain + amount, 0, capacity)
	if old != remain:
		remain_changed.emit()

func decrease_remain(amount : int):
	if amount <= 0:
		return
	var old := remain
	remain = clamp(remain - amount, 0, capacity)
	if old != remain:
		remain_changed.emit(self)

func _on_self_remain_changed(_resource):
	pass
