extends Node

func get_position_with_location(location):
	var m = 0
	var n = 0
	#print(location.y)
	if fmod(location.y, 2) == 0:
		#偶数
		n = (location.y / 2) * 60 * sqrt(3)
	elif fmod(location.y, 2) == 1:
		#奇数
		if location.y > 0:
			n = ((location.y + 1) / 2 ) * 60 * sqrt(3)
		else:
			n = ((location.y - 1) / 2 ) * 60 * sqrt(3)
	m = location.x * 120
	return(Vector2(m, n))
	
	