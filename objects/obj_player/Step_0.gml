var move_forward = keyboard_check(ord("W"));
var move_backward = keyboard_check(ord("S"));
var rotate_left = keyboard_check(ord("A"));
var rotate_right = keyboard_check(ord("D"));
var run_key = keyboard_check(vk_shift);

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
        is_moving = (move_forward || move_backward);
    }
}

image_angle = (image_angle + 360) % 360;

if keyboard_check(ord("R")) room_restart();

if keyboard_check(vk_escape) { room_goto(rm_start); }

if (run_key && stamina > 0) { 
    move_speed = 4;
    z_acceleration = 0.05;
    z_max_speed = 0.2;
    stamina -= stamina_drain_rate;
} else { 
    move_speed = 2;
    z_acceleration = 0.005;
    z_max_speed = 0.01;
    stamina = min(stamina + stamina_regen_rate, max_stamina);
}

if (is_moving) {
    z_speed += z_acceleration;
    if (z_speed > z_max_speed) z_speed = z_max_speed;
    
    footstep_timer++;
    if (footstep_timer >= footstep_interval) {
        footstep_timer = 0;
        audio_play_sound(snd_footstep, 1, false);
    }
} else {
    z_speed = lerp(z_speed, 0, z_return_speed);
    footstep_timer = 0;
}

z += z_speed;
if (z > pi * 2) z -= pi * 2;
if (z < 0) z += pi * 2;

if (!is_moving) {
    z = lerp(z, 0, z_return_speed);
}
