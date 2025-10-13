extends Control

@onready var main_manager = get_parent()
@onready var solar_system = load("res://assets/Scenes/Solar_Systems/sol/sol.tscn")

func _on_start_btn_down():
  main_manager.load_solar_system(solar_system.instantiate())
  pass # Replace with function body.
