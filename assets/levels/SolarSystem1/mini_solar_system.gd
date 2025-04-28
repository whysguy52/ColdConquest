extends Node3D

#Scaled down by 1000

var planets
var actualShip
var mapShip
var shipSpeed
var shipWarpSpeed
var currentSpeed
var isForward

func _ready():
  mapShip = $MapPlayer
  get_planets()
  isForward = false
  pass

func _physics_process(delta):
  if isForward:
    accelerate_ship(delta)
  pass

func _input(event):
  if event.is_action_pressed("key_r"):
    isForward = true
    currentSpeed = shipSpeed
  elif event.is_action_pressed("key_f"):
    isForward = false
    currentSpeed = 0
  elif event.is_action_pressed("space_bar"):
    isForward = !isForward
    currentSpeed = shipWarpSpeed * int(isForward)

func get_parent_ship(hull:Node3D):
  actualShip = hull
  shipSpeed = $"../../../../..".speed / 1000
  shipWarpSpeed = $"../../../../..".warpSpeed / 1000
  pass

func get_planets():
  planets = $Planets.get_children()

func accelerate_ship(delta):
  $MapPlayer.global_position += -actualShip.global_transform.basis.z * currentSpeed * delta
  pass
