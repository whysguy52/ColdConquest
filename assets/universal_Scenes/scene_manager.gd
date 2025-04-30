extends Node3D



func _ready():
  var planetsList = $TestShip/CanvasLayer/HUD/SubViewportContainer/SubViewport/MiniSolarSystem/Planets.get_children()
  for planet in planetsList:
    planet.area_entered.connect(load_planet)
    planet.area_exited.connect(unload_planet)

func unload_planet(map_object):
  if map_object.name.contains("MapPlayer"):
    print("unload")

func load_planet(map_object):
  if map_object.name.contains("MapPlayer"):
    print("load")
