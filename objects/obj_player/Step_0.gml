var move_forward = keyboard_check(ord("W"));
var move_backward = keyboard_check(ord("S"));
var rotate_left = keyboard_check(ord("A"));
var rotate_right = keyboard_check(ord("D"));
var run_key = keyboard_check(vk_shift)

var move_dir = move_forward - move_backward;
var move_distance = move_dir * move_speed;

image_angle += (rotate_right - rotate_left) * rotation_speed;

var new_x = x + lengthdir_x(move_distance, image_angle);
var new_y = y + lengthdir_y(move_distance, image_angle);

var cell_size = 64;
var map_x = floor(new_x / cell_size);
var map_y = floor(new_y / cell_size);

if (map_x >= 0 && map_x < array_length(global.map_data) &&
    map_y >= 0 && map_y < array_length(global.map_data[0])) {
    if (global.map_data[map_x][map_y] == 0) {
        x = new_x;
        y = new_y;
    }
}

image_angle = (image_angle + 360) % 360;

if keyboard_check(ord("R")) room_restart();

if keyboard_check(vk_escape) { room_goto(rm_start)}
if (run_key){ move_speed = 4 } else { move_speed = 2}