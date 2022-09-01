extends Node2D

@export var CHARACTER_SPEED: float = 400.0
var navigation_map
var path = []

# The 'click' event is a custom input action defined in
# Project > Project Settings > Input Map tab
func _input(event):
	if not event.is_action_pressed('click'):
		return
	_update_navigation_path($Character.position, get_local_mouse_position())


func _update_navigation_path(start_position, end_position):
	# get_simple_path is part of the Node2D class
	# it returns a PackedVector2Array of points that lead you from the
	# start_position to the end_position
	path = NavigationServer2D.map_get_path(navigation_map, start_position, end_position, true)
	# The first point is always the start_position
	# We don't need it in this example as it corresponds to the character's position
	path.remove_at(0)
	set_process(true)


func _ready():
	navigation_map = get_world_2d().get_navigation_map()
	
	
func _process(delta):
	var walk_distance = CHARACTER_SPEED * delta
	move_along_path(walk_distance)


func move_along_path(distance):
	var last_point = $Character.position
	while path.size():
		var distance_between_points = last_point.distance_to(path[0])

		# the position to move to falls between two points
		if distance <= distance_between_points:
			$Character.position = last_point.lerp(path[0], distance / distance_between_points)
			return

		# the position is past the end of the segment
		distance -= distance_between_points
		last_point = path[0]
		path.remove_at(0)
	# the character reached the end of the path
	$Character.position = last_point
	set_process(false)
