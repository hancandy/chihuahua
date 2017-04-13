extends Node2D

var POINTS_SPEED = 10

var STATE = {
    PLAY = 0,
    WIN = 1,
    LOSE = 2
}

var chihuahua
var ui
var points = 50
var points_modifier = 0
var state = STATE.PLAY

func _ready():
    ui = get_node("/root/Root/UI")
    chihuahua = get_node("/root/Root/Chihuahua")
    
    ui.get_node("Win").hide()
    ui.get_node("Lose").hide()

    ui.get_node("Lose/Button").connect("button_down", self, "retry")
    ui.get_node("Win/Button").connect("button_down", self, "retry")

    set_process(true)

func _process(delta):
    if state != STATE.PLAY:
        return

    if chihuahua.state == 1:
        if points_modifier < 1:
            points_modifier += delta
        else:
            points_modifier = 1
    
    elif chihuahua.state == 2:
        if points_modifier > -1:
            points_modifier -= delta
        else:
            points_modifier = -1

    else:
        if points_modifier > -0.25:
            points_modifier -= delta
        else:
            points_modifier = -0.25
    
    points += points_modifier * delta * POINTS_SPEED

    if points <= 0:
        points = 0
        state = STATE.LOSE
        ui.get_node("Lose").show()

    elif points >= 100:
        points = 100
        state = STATE.WIN
        ui.get_node("Win").show()

    ui.get_node("ProgressBar").set_val(points)

func retry():
    get_tree().reload_current_scene()
