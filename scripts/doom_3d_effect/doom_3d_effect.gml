function doom_3d_effect(player_x, player_y, player_angle, map_data, wall_textures, type="fps") {
    var FOV = pi * 0.6;
    var HALF_FOV = FOV / 2;
    var NUM_RAYS = 480; 
    var MAX_DEPTH = 512;
    var CELL_SIZE = 64;
    var SCALE_FACTOR = room_height / (2 * tan(HALF_FOV));
    draw_clear(c_black);

    var map_width = array_length(map_data);
    var map_height = array_length(map_data[0]);

    var show_2d_map = keyboard_check(ord("M"));

var show_2d_map = keyboard_check(ord("M"));

if (show_2d_map) {
    var map_scale_x = room_width / (map_width * CELL_SIZE);
    var map_scale_y = room_height / (map_height * CELL_SIZE);
    var map_scale = map_scale_x;
    if (map_scale_y < map_scale_x) {
        map_scale = map_scale_y;
    }
    var map_offset_x = (room_width - map_width * CELL_SIZE * map_scale) / 2;
    var map_offset_y = (room_height - map_height * CELL_SIZE * map_scale) / 2;

    var xx, yy;
    for (xx = 0; xx < map_width; xx++) {
        for (yy = 0; yy < map_height; yy++) {
            if (map_data[xx][yy] == 1) {
                draw_set_color(c_white);
                draw_rectangle(
                    map_offset_x + xx * CELL_SIZE * map_scale,
                    map_offset_y + yy * CELL_SIZE * map_scale,
                    map_offset_x + (xx + 1) * CELL_SIZE * map_scale,
                    map_offset_y + (yy + 1) * CELL_SIZE * map_scale,
                    false
                );
            }
        }
    }

    draw_set_color(c_red);
    draw_circle(
        map_offset_x + player_x * map_scale,
        map_offset_y + player_y * map_scale,
        5,
        false
    );

    draw_line_color(
        map_offset_x + player_x * map_scale,
        map_offset_y + player_y * map_scale,
        map_offset_x + (player_x + cos(player_angle) * 20) * map_scale,
        map_offset_y + (player_y - sin(player_angle) * 20) * map_scale,
        c_yellow,
        c_yellow
    );
} else if (type == "fps") {
    var i, ray_angle, sin_angle, cos_angle, distance, hit_wall, step;
    var test_x, test_y, test_cell_x, test_cell_y, correct_distance, wall_height;
    var color_intensity, color, screen_x, line_width;

    for (i = 0; i < NUM_RAYS; i++) {
        ray_angle = player_angle - HALF_FOV + (i / NUM_RAYS) * FOV;
        sin_angle = sin(ray_angle);
        cos_angle = cos(ray_angle);
        
        distance = 0;
        hit_wall = false;
        
        step = 0.75;
        
        while (distance < MAX_DEPTH && !hit_wall) {
            distance += step;
            
            test_x = player_x + cos_angle * distance;
            test_y = player_y - sin_angle * distance;
            
            test_cell_x = floor(test_x / CELL_SIZE);
            test_cell_y = floor(test_y / CELL_SIZE);
            
            if (test_cell_x < 0 || test_cell_x >= map_width || test_cell_y < 0 || test_cell_y >= map_height) {
                hit_wall = true;
                distance = MAX_DEPTH;
            } else if (map_data[test_cell_x][test_cell_y] == 1) {
                hit_wall = true;
            }
        }
        
        correct_distance = distance * cos(ray_angle - player_angle);
        wall_height = (room_height / correct_distance) * SCALE_FACTOR;
        if (wall_height > room_height) wall_height = room_height;
        
        color_intensity = 255 - (correct_distance * 2);
        if (color_intensity < 50) color_intensity = 50;
        if (color_intensity > 255) color_intensity = 255;
        color = make_color_rgb(color_intensity, color_intensity, color_intensity);
        
        screen_x = (i / NUM_RAYS) * room_width;
        line_width = ceil(room_width / NUM_RAYS);

        draw_line_width_color(screen_x, (room_height - wall_height) / 2, screen_x, (room_height + wall_height) / 2, line_width, color, color);
    }
    } else {
        var FOV = pi * 0.8; 
        var HALF_FOV = FOV / 2;
        var NUM_RAYS = room_width;
        var MAX_DEPTH = 512; 
        var CELL_SIZE = 64;
        draw_clear(c_black);

        var map_width = array_length(map_data);
        var map_height = array_length(map_data[0]);
        
        var i, ray_angle, distance, hit_wall;
        var test_x, test_y, test_cell_x, test_cell_y, correct_distance, wall_height;
        var color_intensity, color;

        for (i = 0; i < NUM_RAYS; i++) {
            ray_angle = player_angle - HALF_FOV + (i / NUM_RAYS) * FOV;
            distance = 0;
            hit_wall = false;
            
            while (distance < MAX_DEPTH && !hit_wall) {
                distance += 0.1;
                
                test_x = player_x + cos(ray_angle) * distance;
                test_y = player_y - sin(ray_angle) * distance;
                
                test_cell_x = floor(test_x / CELL_SIZE);
                test_cell_y = floor(test_y / CELL_SIZE);
                
                if (test_cell_x < 0 || test_cell_x >= map_width || test_cell_y < 0 || test_cell_y >= map_height) {
                    hit_wall = true;
                    distance = MAX_DEPTH;
                } else if (map_data[test_cell_x][test_cell_y] == 1) {
                    hit_wall = true;
                }
            }
            
            correct_distance = distance * cos(ray_angle - player_angle);
            wall_height = (room_height / correct_distance) * (NUM_RAYS / (2 * tan(HALF_FOV)));
            if (wall_height > room_height) wall_height = room_height;
            
            color_intensity = 255 - (distance * 1.5);
            if (color_intensity < 0) color_intensity = 0;
            if (color_intensity > 255) color_intensity = 255;
            color = make_color_rgb(color_intensity, color_intensity, color_intensity);
            
            if (distance < MAX_DEPTH / 2) {
                draw_line_width_color(i, (room_height - wall_height) / 2, i, (room_height + wall_height) / 2, 1, color, color);
            } else {
                draw_line_width_color(i, (room_height - wall_height) / 2, i, (room_height + wall_height) / 2, 1, make_color_rgb(color_intensity * 0.8, color_intensity * 0.8, color_intensity * 0.8), make_color_rgb(color_intensity * 0.8, color_intensity * 0.8, color_intensity * 0.8));
            }
        }
    }
}