extends Node
###资源附加属性###
#种类：程度（0-100）
var addition_virus = {}#病毒
var addition_germ = {}#细菌
var addition_radiation = {}#辐射
var addition_parasite = {}#寄生虫

###资源属性###
var mass#质量
var volume#体积
var state#状态

###资源特性###
var standard_para = [100, 100, 100, 100, 100, 100, 100, 1, 100, 100, 0, 100, 100, 100, 100]
var smell = standard_para[0]#越大越刺激
var rigidity = standard_para[1]#硬度
var indencity = standard_para[2]#强度
var conductivity_electricity = standard_para[3]#导电率
var conductivity_temperature = standard_para[4]#导热率
var ductility = standard_para[5]#延展性
var solubleness = standard_para[6]#溶解性，并非溶解度。数值越高越易溶解
var density = standard_para[7]#密度
var heat_stability = standard_para[8]#热稳定
var corrosion_risistancy = standard_para[9]#耐腐蚀
var melting_point = standard_para[10]#熔点
var boiling_point = standard_para[11]#沸点
var flammability = standard_para[12]#可燃性
var transparency = standard_para[13]#透明度
var magnetism = standard_para[14]#磁性

func _para_init():
	smell = standard_para[0]#越大越刺激
	rigidity = standard_para[1]#硬度
	indencity = standard_para[2]#强度
	conductivity_electricity = standard_para[3]#导电率
	conductivity_temperature = standard_para[4]#导热率
	ductility = standard_para[5]#延展性
	solubleness = standard_para[6]#溶解性，并非溶解度。数值越高越易溶解
	density = standard_para[7]#密度
	heat_stability = standard_para[8]#热稳定
	corrosion_risistancy = standard_para[9]#耐腐蚀
	melting_point = standard_para[10]#熔点
	boiling_point = standard_para[11]#沸点
	flammability = standard_para[12]#可燃性
	transparency = standard_para[13]#透明度
	magnetism = standard_para[14]#磁性