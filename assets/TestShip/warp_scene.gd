extends Node3D

var ship

func _ready():
  ship = get_parent().get_parent().get_node("TestShip")
  ship.global_position = Vector3(0,0,0)
  ship.set_near_planet(false)
