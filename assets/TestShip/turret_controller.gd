extends Node3D

#object references
var cam
var childTurrets
@export var isGunner = false

#for rotation
var targetVect
var currentVect

# Called when the node enters the scene tree for the first time.
func _ready():
  cam = get_parent().get_parent().get_node("PilotCamTurn/PilotCamNod/PilotCam")
  childTurrets = get_children()

  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func _input(event):
  if event.is_action_pressed("RMB"):
    if !isGunner:
      return
    targetVect = -cam.global_transform.basis.z
    for turret in childTurrets: #pass the cameras global -z to each turret
      turret.pass_global_vect(targetVect)

  pass
