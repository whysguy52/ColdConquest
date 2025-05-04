extends Node3D

var rotateRate = 0.005

@export var isPilot = true
var shipRotator
var cam


#ship turn with camera
var up
var isTurning:bool
var rotWeight = 0.0
var rotRate = 0.2
var finalDirection:Vector3
var initialDirection:Vector3
var lookAtVect:Vector3

#manual turn: roll, pitch, yaw
var manualTurnRate = 20 * (PI/180) #degree per tick
var manualRoll = 0
var manualPitch = 0
var manualYaw = 0

#ship mmove/displace
var isNearPlanet = true
var isForward = false
var isWarp = false
var speed = 4
var warpSpeed = 5000
var currentSpeed
var acc = 0.01 #not used yet

#Camera_HUD
var miniPlanetList
var hudPlanets : Array
var mapPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
  miniPlanetList = $ScreenLayer/HUD/SubViewportContainer/SubViewport/MiniSolarSystem/Planets.get_children()
  mapPlayer =  $ScreenLayer/HUD/SubViewportContainer/SubViewport/MiniSolarSystem/MapPlayer

  create_hud_planets()
  shipRotator = get_node("ShipHull")
  cam = get_node("PilotCamTurn/PilotCamNod/PilotCam")
  $ScreenLayer/HUD/SubViewportContainer/SubViewport/MiniSolarSystem.get_parent_ship($ShipHull)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

  manualRoll = int(Input.is_action_pressed("key_e")) - int(Input.is_action_pressed("key_q"))
  manualPitch = int(Input.is_action_pressed("key_s")) - int(Input.is_action_pressed("key_w"))
  manualYaw = int(Input.is_action_pressed("key_d")) - int(Input.is_action_pressed("key_a"))


  pass

func _physics_process(delta):
  if !isNearPlanet:
    global_position = Vector3(0,0,0)
  update_visual_hud_planets()

  if !isPilot:
    return
    #manual overrides auto turning by putting it first
  if isTurning:
    ship_turn(delta)
  if manualRoll != 0:
    manual_roll(delta)
  if manualPitch != 0:
    manual_pitch(delta)
  if manualYaw != 0:
    manual_yaw(delta)

  if isForward or isWarp:
    accelerate_ship(delta)
  pass

func _input(event):
  if event.is_action_pressed("key_r") and !isWarp:
    isForward = true
    currentSpeed = speed
  elif event.is_action_pressed("key_f") and !isWarp:
    isForward = false
    currentSpeed = 0
  elif event.is_action_pressed("space_bar"):
    isForward = false
    isWarp = !isWarp
    currentSpeed = warpSpeed * int(isWarp)
    $ShipHull/WarpParticles.emitting = !$ShipHull/WarpParticles.emitting

  if event.is_action_pressed("RMB"):
    rotWeight = 0.0
    isTurning = true
    finalDirection = -cam.global_transform.basis.z #cam is nested so we have to take global
    initialDirection = -shipRotator.transform.basis.z

func manual_roll(delta):
  isTurning = false
  shipRotator.rotate(-shipRotator.transform.basis.z, manualRoll * manualTurnRate * delta)
func manual_yaw(delta):
  isTurning = false
  shipRotator.rotate(shipRotator.transform.basis.y, -manualYaw * manualTurnRate * delta)
func manual_pitch(delta):
  isTurning = false
  shipRotator.rotate(shipRotator.transform.basis.x, manualPitch * manualTurnRate * delta)

func accelerate_ship(delta):
  global_position += -shipRotator.global_transform.basis.z * int(isNearPlanet) * currentSpeed * delta

  pass

func ship_turn(delta):
  if rotWeight == 1.0:    #if we are done rotating
    rotWeight = 0.0
    isTurning = false
    return
  elif rotWeight > 1.0:   #if we accidentally go past 1.0?
    rotWeight = 1.0
    lookAtVect = initialDirection.slerp(finalDirection, rotWeight)
  else:                   #normal rotation case
    rotWeight += rotRate * delta
    lookAtVect = initialDirection.slerp(finalDirection, rotWeight)

  up = shipRotator.global_transform.basis.y
  shipRotator.transform.basis = shipRotator.transform.basis.looking_at(lookAtVect,up)

func set_near_planet(nearPlanet:bool):
  isNearPlanet = nearPlanet

func create_hud_planets():
  for planet in miniPlanetList:
    var planetPos = Node3D.new()
    hudPlanets.append(planetPos)
    $HudPlanets.add_child(planetPos)
    planetPos.position = (planet.global_position - mapPlayer.global_position) * 1000
  $ScreenLayer.set_planet_references(hudPlanets)

func update_visual_hud_planets():
  for i in range(hudPlanets.size()):
    hudPlanets[i].position = (miniPlanetList[i].global_position - mapPlayer.global_position) * 1000
