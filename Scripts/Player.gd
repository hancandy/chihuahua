extends Node2D

var STATE = {
    IDLE = 0,
    WAVING = 1
}

var ROTATION_AMOUNT = 5

var state = STATE.IDLE
var pressed_pointer_pos = Vector2(0,0)
var last_pointer_pos = Vector2(0,0)

var game

func _ready():
    game = get_node("/root/Root")

    set_process(true)
    set_process_input(true)
        
    Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
    if game.state != 0:
        state = STATE.IDLE
        set_rot(0)

    var cur_pointer_pos = get_global_mouse_pos()

    if state == STATE.IDLE:
        set_global_pos(cur_pointer_pos)

    elif state == STATE.WAVING:
        var pointer_delta = cur_pointer_pos.x - last_pointer_pos.x

        if pointer_delta < 0 && get_rot() < PI / 4:
            set_rot(get_rot() - pointer_delta * delta)

        elif pointer_delta > 0 && get_rot() > -PI / 4:
            set_rot(get_rot() - pointer_delta * delta)
            
    last_pointer_pos = cur_pointer_pos

func _input(e):
    if game.state != 0:
        return

    if e.type == InputEvent.MOUSE_BUTTON:
        if e.is_action_pressed("action"):
            pressed_pointer_pos = get_global_mouse_pos()
            state = STATE.WAVING
        
        elif e.is_action_released("action"):
            get_viewport().warp_mouse(pressed_pointer_pos)
            state = STATE.IDLE
