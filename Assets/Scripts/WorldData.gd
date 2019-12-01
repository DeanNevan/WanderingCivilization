extends Node

var substances_rank := []

var substances_smell_rank := []
var substances_rigidity_rank := []
var substances_indencity_rank := []
var substances_conductivity_electricity_rank := []
var substances_conductivity_temperature_rank := []
var substances_ductility_rank := []
var substances_solubleness_rank := []
var substances_density_rank := []
var substances_heat_stability_rank := []
var substances_corrosion_risistancy_rank := []
var substances_melting_point_rank := []
var substances_boiling_point_rank := []
var substances_flammability_rank := []
var substances_transparency_rank := []
var substances_magnetism_rank := []

func rank_substances(substances = []):
	if substances == []:
		#for i in $Element.get_child_count():
			#substances.append($Element.get_child(i))
		for i in $Manmadesubstance.get_child_count():
			substances.append($Manmadesubstance.get_child(i))
	if substances.size() == 0:
		return "empty substances"
	substances_rank.resize(substances[0].standard_para.size() + 1)
	for i in substances_rank.size():
		substances_rank[i] = []
	for _para in substances[0].standard_para.size():
		var list = {}
		var para_array = []
		for m in substances.size():
			list[substances[m].standard_para[_para]] = substances[m]
		para_array = list.keys()
		para_array.sort()
		para_array.invert()
		for i in para_array.size():
			substances_rank[_para].append(list.get(para_array[i]))
	_update_rank()

func _update_rank():
	substances_smell_rank = substances_rank[0]
	substances_rigidity_rank = substances_rank[1]
	substances_indencity_rank = substances_rank[2]
	substances_conductivity_electricity_rank = substances_rank[3]
	substances_conductivity_temperature_rank = substances_rank[4]
	substances_ductility_rank = substances_rank[5]
	substances_solubleness_rank = substances_rank[6]
	substances_density_rank = substances_rank[7]
	substances_heat_stability_rank = substances_rank[8]
	substances_corrosion_risistancy_rank = substances_rank[9]
	substances_melting_point_rank = substances_rank[10]
	substances_boiling_point_rank = substances_rank[11]
	substances_flammability_rank = substances_rank[12]
	substances_transparency_rank = substances_rank[13]
	substances_magnetism_rank = substances_rank[14]