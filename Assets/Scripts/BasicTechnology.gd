extends Node

signal init_done

enum {
	PRIMITIVE#原始
	GLOBAL#通用
	MATH#数学
	THEORY_SCIENCE#科技理论
	THEORY_MAGIC#魔法理论
	THEORY_THEOLOGY#神学理论
	APPLY#应用技术
	SUPER#超级
}

var type = PRIMITIVE

var group_nodes

var level = clamp(1, 1, 10)#技术的等级

var require_degree = 0#研究条件成熟度
var require_tech = {}#需求的技术及其占比
var require_resources = {}#需求的资源
var require_condition = {}#需求的条件
var expected_require_time = 25#预期研究周期时长
var expected_probability = 0.25 - level * 0.05 + require_degree * 0.5#预期一个周期研究成功率

var is_learned = false#是否习得
var mature_speed = 0.05
var maturity = clamp(0, 0, 1)#成熟度、普及度s

func _ready():
	self.add_to_group(str(get_parent().get_parent().get_parent().name) + "TechPrimitive")

"""func init_tech():
	match type:
		PRIMITIVE:
			pass
		GLOBAL:
			self.add_to_group("TechGlobal")
			get_node("/root/InGame/WorldData/Technologies/Global").add_child(self)
		MATH:
			self.add_to_group("TechMath")
			get_node("/root/InGame/WorldData/Technologies/Math").add_child(self)
		THEORY_SCIENCE:
			self.add_to_group("TechTheoryScience")
			get_node("/root/InGame/WorldData/Technologies/TheoryScience").add_child(self)
		THEORY_MAGIC:
			self.add_to_group("TechTheoryMagic")
			get_node("/root/InGame/WorldData/Technologies/TheoryMagic").add_child(self)
		THEORY_THEOLOGY:
			self.add_to_group("TechTheoryTheology")
			get_node("/root/InGame/WorldData/Technologies/TheoryTheology").add_child(self)
		APPLY:
			self.add_to_group("TechApply")
			get_node("/root/InGame/WorldData/Technologies/Apply").add_child(self)
		SUPER:
			self.add_to_group("TechSuper")
			get_node("/root/InGame/WorldData/Technologies/Super").add_child(self)
	emit_signal("init_done")"""