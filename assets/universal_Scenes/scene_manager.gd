extends Node3D

var currentScene
var warpScene
var planet_scene # make this an array that loads dynamically on ready

func _ready():
  var planetsList = $TestShip/CanvasLayer/HUD/SubViewportContainer/SubViewport/MiniSolarSystem/Planets.get_children()
  currentScene = $CurrentScene
  planet_scene = load("res://assets/levels/SolarSystemAssets/scene_planet.tscn")
  warpScene = load("res://assets/TestShip/warp_scene.tscn")

  for planet in planetsList:
    planet.area_entered.connect(load_planet)
    planet.area_exited.connect(unload_planet)

func unload_planet(map_object):
  if map_object.name.contains("MapPlayer"):
    var level = currentScene.get_children()[0]
    currentScene.remove_child(level)
    level.call_deferred("free")
    if currentScene.get_children().is_empty():
      currentScene.add_child(warpScene.instantiate())

func load_planet(map_object):
  if map_object.name.contains("MapPlayer"):
    if !currentScene.get_children().is_empty():
      var level = currentScene.get_children()[0]
      currentScene.remove_child(level)
      level.call_deferred("free")
    currentScene.add_child(planet_scene.instantiate())
    $TestShip.set_near_planet(true)
