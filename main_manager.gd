extends Node3D

var is_solar_system
@onready var selected_scene = preload("res://assets/Scenes/Menu_Scenes/Title_Screen/title_screen.tscn")#for testing - change to main screen
var current_scene

#currently load the sol system for testing. will load main menu eventually.
func _ready():
  current_scene = selected_scene.instantiate()
  add_child(current_scene)
  pass

func next_scene():
  pass

func load_solar_system(solar_scene):
  remove_child(current_scene)
  current_scene = solar_scene
  add_child(current_scene)
  pass
