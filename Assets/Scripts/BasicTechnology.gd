extends Node

enum {
	GLOBAL#通用
	MATH#数学
	THEORY_SCIENCE#科技理论
	THEORY_MAGIC#魔法理论
	THEORY_THEOLOGY#神学理论
	APPLY#应用技术
	SUPER#超级
}

var type = GLOBAL

var level = clamp(1, 1, 10)#技术的等级

var maturity = 0#研究条件成熟度
var require_tech = {}#需求的技术及其占比
var require_resources = {}#需求的资源
var require_condition = {}#需求的条件
var expected_require_time = 25#预期研究周期时长
var expected_probability = 0.25 - level * 0.05 + maturity * 0.5#预期一个周期研究成功率

var is_learned = false#是否习得
var degree = clamp(0, 0, 1)#普及程度

