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
var isForward = false
var speed = 4
var acc = 0.01 #not used yet

# Called when the node enters the scene tree for the first time.
func _ready():
  shipRotator = get_node("ShipHull")
  cam = get_node("PilotCamTurn/PilotCamNod/PilotCam")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  manualRoll = int(Input.is_action_pressed("key_e")) - int(Input.is_action_pressed("key_q"))
  manualPitch = int(Input.is_action_pressed("key_s")) - int(Input.is_action_pressed("key_w"))
  manualYaw = int(Input.is_action_pressed("key_d")) - int(Input.is_action_pressed("key_a"))
  pass

func _physics_process(delta):
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

  if isForward:
    accelerate_ship(delta)

  pass

func _input(event):
  if event.is_action_pressed("key_r"):
    isForward = true
  elif event.is_action_pressed("key_f"):
    isForward = false

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
  global_position += -shipRotator.global_transform.basis.z * speed * delta
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
