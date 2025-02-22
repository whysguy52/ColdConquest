extends Node3D

var rotateRate = 0.005

@export var isPilot = true
var shipRotator
var cam


#ship turn with camera
var up
var isTurning:bool
var rotWeight = 0.0
var rotRate = 0.01
var finalDirection:Vector3
var initialDirection:Vector3
var lookAtVect:Vector3

#manual turn: roll, pitch, yaw
var manualTurnRate = 1 * (PI/180) #degree per tick
var manualRoll = 0
var manualPitch = 0
var manualYaw = 0

#ship mmove/displace
var speed
var acc = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
  shipRotator = get_node("ShipHull")
  cam = get_node("PilotCamTurn/PilotCamNod/PilotCam")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func _physics_process(delta):

  if manualRoll != 0:
    manual_roll()

  if manualYaw != 0:
    manual_yaw()

  if isTurning:
    ship_turn()
  pass

func _input(event):
  if !isPilot:
    return

#TODO: Move the following to LOOKUP: void _unhandled_key_input(event: InputEvent) virtual
#region Roll, Pitch and Yaw
  print("...")
  #roll
  if  event.is_action_released("key_e") or event.is_action_released("key_q"):
    print("e/q released")
    manualRoll = 0
  if event.is_action_pressed("key_e", true):
    print("e pressed")
    manualRoll = 1
  if event.is_action_pressed("key_q", true):
    print("q pressed")
    manualRoll = -1

  #pitch
  if event.is_action_pressed("key_w"):
    manualPitch = 1
  elif event.is_action_pressed("key_s"):
    manualPitch = -1
  elif event.is_action_released("key_w") or event.is_action_released("key_s"):
    manualPitch = 0
  #yaw
  if event.is_action_pressed("key_d"):
    manualYaw = 1
  elif event.is_action_pressed("key_a"):
    manualYaw = -1
  elif event.is_action_released("key_a") or event.is_action_released("key_d"):
    manualYaw = 0
#endregion

#TODO: implement acceleration!
  if event.is_action_pressed("key_r"):
    speed = 1
  elif event.is_action_pressed("key_f"):
    speed = 0

  if event.is_action_pressed("RMB"):
    rotWeight = 0.0
    isTurning = true
    finalDirection = -cam.global_transform.basis.z #cam is nested so we have to take global
    initialDirection = -shipRotator.transform.basis.z

func manual_roll():
  shipRotator.rotate(-shipRotator.transform.basis.z, manualRoll * manualTurnRate)

func manual_yaw():
  shipRotator.rotate(shipRotator.transform.basis.y, -manualYaw * manualTurnRate)

func manual_pitch():
  shipRotator.rotate(shipRotator.transform.basis.x, manualPitch * manualTurnRate)


func ship_turn():
  if rotWeight == 1.0:    #if we are done rotating
    rotWeight = 0.0
    isTurning = false
    return
  elif rotWeight > 1.0:   #if we accidentally go past 1.0?
    rotWeight = 1.0
    lookAtVect = initialDirection.slerp(finalDirection, rotWeight)
  else:                   #normal rotation case
    rotWeight += rotRate
    lookAtVect = initialDirection.slerp(finalDirection, rotWeight)

  up = shipRotator.global_transform.basis.y
  shipRotator.transform.basis = shipRotator.transform.basis.looking_at(lookAtVect,up)
