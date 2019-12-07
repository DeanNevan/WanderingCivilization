extends Node

func _ready():
	get_node("/root/InGame/WorldData/Technologies").connect("tech_init_done", self, "_on_tech_init_done")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_tech_init_done():
	pass