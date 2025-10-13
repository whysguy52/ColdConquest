extends Node3D


var mini_map_resource = preload("res://assets/Scenes/Solar_Systems/sol/Assets/Mini_Map/mini_map_sol.tscn")

var mini_map
var planet_list
var is_solar_system = true

func _ready():
  mini_map = mini_map_resource.instantiate() #do not add to scene. only used for positions
  get_planets()

func get_planets():
  planet_list = mini_map.get_planet_list()

  for planet in planet_list:
    var planet_resource = load("res://assets/Scenes/Solar_Systems/sol/Assets/" + planet.name + "/" + planet.name + ".tscn")
    var planet_inst = planet_resource.instantiate()
    $Planets.add_child(planet_inst)
    planet_inst.global_transform.origin = planet.transform.origin * 1e10
