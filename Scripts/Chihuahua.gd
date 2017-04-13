extends Node2D

var STATE = {
    NEUTRAL = 0,
    HAPPY = 1,
    ANGRY = 2
}

var AREA_TIMER_CHANGE = 4

var current_area = 1
var current_pressed_area = -1
var player
var state = STATE.NEUTRAL
var anim
var audio
var area_timer = 0
var game

func _ready():
    player = get_node("/root/Root/Player")
    anim = get_node("Animation/AnimationPlayer")
    audio = get_node("SamplePlayer2D")
    game = get_node("/root/Root")

    anim.play("Neutral")

    set_process(true)
    set_process_input(true)

    get_node("Area1").connect("input_event", self, "on_press_area_1")
    get_node("Area2").connect("input_event", self, "on_press_area_2")
    get_node("Area3").connect("input_event", self, "on_press_area_3")
    get_node("Area4").connect("input_event", self, "on_press_area_4")

func on_press_area_1(viewport, event, shape_index):
    set_area(1, event)
    
func on_press_area_2(viewport, event, shape_index):
    set_area(2, event)

func on_press_area_3(viewport, event, shape_index):
    set_area(3, event)

func on_press_area_4(viewport, event, shape_index):
    set_area(4, event)

func _process(delta):
    if game.state == 1:
        set_state(STATE.HAPPY, "Happy")
        return
    
    if game.state == 2:
        set_state(STATE.ANGRY, "Angry")
        return

    if current_pressed_area == -1:
        set_state(STATE.NEUTRAL, "Neutral")

    elif current_area == current_pressed_area:
        set_state(STATE.HAPPY, "Happy")

    else:
        set_state(STATE.ANGRY, "Angry")

    area_timer -= delta

    if area_timer <= 0:
        current_area = randi()%4+1
        area_timer = AREA_TIMER_CHANGE

func set_state(e, name):
    state = e
    
    if anim.get_current_animation() != name:
        anim.play(name)

        if e == STATE.NEUTRAL:
            audio.stop_all()

        else:
            audio.play(name)

func set_area(a, e):
    if game.state != 0:
        return
    
    if player.state == 1 && e.type == InputEvent.MOUSE_BUTTON && e.is_action_pressed("action"):
        current_pressed_area = a

func _input(e):
    if game.state != 0:
        return

    if e.type == InputEvent.MOUSE_BUTTON && e.is_action_released("action"):
        current_pressed_area = -1
