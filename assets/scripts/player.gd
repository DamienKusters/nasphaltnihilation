extends Spatial


# Declare member variables here. Examples:
export var maxSpeed = 100;
export var throttleUp = 40;
export var throttleDown = 20;
export var drag = 5;

var currentSpeed = 0;

onready var uiHand = $"Camera/ui/speedometer/speedometerlever";
var currentHandRotation = -122;

onready var uiPlayerSprite = $"Camera/ui/sprite_player";
onready var sprPlayer = load("res://assets/sprites/motor_rear.png");
onready var sprPlayerSide = load("res://assets/sprites/motor_side.png");

onready var rigid = $"..";

func _process(delta):
	
	if !(currentSpeed >= maxSpeed):
		if Input.is_action_pressed("ui_up"):
			currentSpeed = currentSpeed + (throttleUp - drag) * delta;
	if !(currentSpeed <= 0):
		if Input.is_action_pressed("ui_down"):
			currentSpeed = currentSpeed - throttleDown * delta;
	if Input.is_action_pressed("ui_left"):
		uiPlayerSprite.flip_h = false;
		uiPlayerSprite.texture = sprPlayerSide;
		rigid.add_force(Vector3(-10,0,0),Vector3(0,0,0));
	elif Input.is_action_pressed("ui_right"):
		uiPlayerSprite.flip_h = true;
		uiPlayerSprite.texture = sprPlayerSide;
		rigid.add_force(Vector3(10,0,0),Vector3(0,0,0));
	else:
		uiPlayerSprite.texture = sprPlayer;
	if !(currentSpeed <= 0):
		currentSpeed = currentSpeed - drag * delta;
	print(currentSpeed);
	updateUi();
	var newSpeed = currentSpeed / 5;
	rigid.add_force(Vector3(0,0,newSpeed - newSpeed - newSpeed),Vector3(0,0,0));


func updateUi():
	var percentage = (currentSpeed / maxSpeed) * 100;
	var minHand = -121.5;
	var maxHand = -117.6;
	var handDiff = 3.9;
	var handCurr = percentage * handDiff / 100;
	if currentSpeed <= 0:
		return uiHand.set_rotation(minHand);
	if currentSpeed >= maxSpeed:
		return uiHand.set_rotation(maxHand);
	var rota = minHand + handCurr;
	return uiHand.set_rotation(rota);
