extends Node2D

var myPlanet

func set_my_planet(planet):
  myPlanet = planet

func _process(delta):
  visible = not get_viewport().get_camera_3d().is_position_behind(myPlanet.global_transform.origin)
  position = get_viewport().get_camera_3d().unproject_position(myPlanet.global_transform.origin)
