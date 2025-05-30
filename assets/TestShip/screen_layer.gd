extends CanvasLayer

var planetsActual
var planetsMap
var planetHudIconSrc

func _ready():
  planetHudIconSrc = load("res://assets/TestShip/HUDComponents/PlanetMarker.tscn")

func set_planet_references(planets):
  planetsActual = planets
  for planet in planetsActual:
    var planetMarker = planetHudIconSrc.instantiate()
    planetMarker.set_my_planet(planet)
    $PlanetHUDList.add_child(planetMarker)
