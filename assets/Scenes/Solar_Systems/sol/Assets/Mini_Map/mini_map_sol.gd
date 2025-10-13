extends Node3D

var map_scalar: float = 1e7
@onready var planets = $planets.get_children()


func get_planet_list():
  return $planets.get_children()
