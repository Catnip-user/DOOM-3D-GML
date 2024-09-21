function doom_3d_effect(player_x, player_y, player_z, player_angle, map_data, wall_textures, type="fps") {
    var FOV = pi * 0.6;
    var HALF_FOV = FOV * 0.5;
    var NUM_RAYS = 480; 
    var MAX_DEPTH = 512;
    var CELL_SIZE = 64;
    var SCALE_FACTOR = room_height / (2 * tan(HALF_FOV));
    
    var map_width = array_length(map_data);
    var map_height = array_length(map_data[0]);

    var show_2d_map = keyboard_check(ord("M"));

    if (show_2d_map) {
        draw_2d_map(map_data, map_width, map_height, CELL_SIZE, player_x, player_y, player_angle);
    } else if (type == "fps") {
        draw_fps_view(player_x, player_y, player_z, player_angle, map_data, map_width, map_height, NUM_RAYS, MAX_DEPTH, CELL_SIZE, SCALE_FACTOR, FOV, HALF_FOV);
    } else {
        draw_enhanced_view(player_x, player_y, player_z, player_angle, map_data, map_width, map_height, MAX_DEPTH, CELL_SIZE, FOV);
    }
}

function draw_fps_view(player_x, player_y, player_z, player_angle, map_data, map_width, map_height, NUM_RAYS, MAX_DEPTH, CELL_SIZE, SCALE_FACTOR, FOV, HALF_FOV) {
    var ray_angle, sin_angle, cos_angle, distance, wall_height;
    var color_intensity, color, screen_x;

    for (var i = 0; i < NUM_RAYS; i++) {
        ray_angle = player_angle - HALF_FOV + (i / NUM_RAYS) * FOV;
        sin_angle = sin(ray_angle);
        cos_angle = cos(ray_angle);
        
        distance = cast_ray_fast(player_x, player_y, cos_angle, -sin_angle, map_data, map_width, map_height, MAX_DEPTH, CELL_SIZE);
        
        var correct_distance = distance * cos(ray_angle - player_angle);
        wall_height = (room_height / correct_distance) * SCALE_FACTOR;
        wall_height = min(wall_height, room_height);
        
        color_intensity = clamp(200 - (correct_distance * 0.5), 10, 200);
        color = make_color_rgb(color_intensity, color_intensity, color_intensity);
        
        screen_x = (i / NUM_RAYS) * room_width;

        var vertical_offset = sin(player_z) * 10;
        draw_line_width_color(screen_x, (room_height - wall_height) * 0.5 + vertical_offset, screen_x, (room_height + wall_height) * 0.5 + vertical_offset, 2, color, color);
    }
}

function cast_ray_fast(start_x, start_y, cos_angle, sin_angle, map_data, map_width, map_height, MAX_DEPTH, CELL_SIZE) {
    var distance = 0;
    var hit_wall = false;
    
    while (distance < MAX_DEPTH && !hit_wall) {
        distance += 1;
        
        var test_x = start_x + cos_angle * distance;
        var test_y = start_y + sin_angle * distance;
        
        var test_cell_x = floor(test_x / CELL_SIZE);
        var test_cell_y = floor(test_y / CELL_SIZE);
        
        if (test_cell_x < 0 || test_cell_x >= map_width || test_cell_y < 0 || test_cell_y >= map_height) {
            hit_wall = true;
            distance = MAX_DEPTH;
        } else if (map_data[test_cell_x][test_cell_y] == 1) {
            hit_wall = true;
        }
    }
    
    return distance;
}

function draw_enhanced_view(player_x, player_y, player_z, player_angle, map_data, map_width, map_height, MAX_DEPTH, CELL_SIZE, FOV) {
    var HALF_FOV = FOV * 0.5;
    var NUM_RAYS = room_width;
    
    var main_surface = surface_create(room_width, room_height);
    surface_set_target(main_surface);
    draw_clear(c_black);

    var ray_angle, distance, wall_height;
    var color_intensity, color;

    for (var i = 0; i < NUM_RAYS; i++) {
        ray_angle = player_angle - HALF_FOV + (i / NUM_RAYS) * FOV;
        var cos_angle = cos(ray_angle);
        var sin_angle = -sin(ray_angle);
        
        distance = cast_ray_fast(player_x, player_y, cos_angle, sin_angle, map_data, map_width, map_height, MAX_DEPTH, CELL_SIZE);
        
        var correct_distance = distance * cos(ray_angle - player_angle);
        wall_height = (room_height / correct_distance) * (NUM_RAYS / (2 * tan(HALF_FOV)));
        wall_height = min(wall_height, room_height);
        
        color_intensity = clamp(180 - (distance * 0.3), 5, 255);
        color = make_color_rgb(color_intensity, color_intensity, color_intensity);
        
        var vertical_offset = sin(player_z) * 10;
        draw_line_width_color(i, (room_height - wall_height) * 0.5 + vertical_offset, i, (room_height + wall_height) * 0.5 + vertical_offset, 1, color, color);
    }
    
    surface_reset_target();
    
    var blur_shader = blur
    shader_set(blur_shader);
	shader_set_uniform_f(shader_get_uniform(blur_shader, "blur_amount"), 2);
    draw_surface(main_surface, 0, 0);
    shader_reset();
    
    var dof_shader = dof;
    shader_set(dof_shader);
	shader_set_uniform_f(shader_get_uniform(dof_shader, "focal_distance"), 0.2);
	shader_set_uniform_f(shader_get_uniform(dof_shader, "focal_range"), 0.5);

    draw_surface(main_surface, 0, 0);
    shader_reset();
    
    surface_free(main_surface);
}

function draw_2d_map(map_data, map_width, map_height, CELL_SIZE, player_x, player_y, player_angle) {
    var map_scale = min(room_width / (map_width * CELL_SIZE), room_height / (map_height * CELL_SIZE));
    var map_offset_x = (room_width - map_width * CELL_SIZE * map_scale) * 0.5;
    var map_offset_y = (room_height - map_height * CELL_SIZE * map_scale) * 0.5;

    draw_set_color(c_dkgray);
    draw_rectangle(0, 0, room_width, room_height, false);

    for (var xx = 0; xx < map_width; xx++) {
        for (var yy = 0; yy < map_height; yy++) {
            draw_set_color(map_data[xx][yy] == 1 ? c_white : c_black);
            draw_rectangle(
                map_offset_x + xx * CELL_SIZE * map_scale,
                map_offset_y + yy * CELL_SIZE * map_scale,
                map_offset_x + (xx + 1) * CELL_SIZE * map_scale - 1,
                map_offset_y + (yy + 1) * CELL_SIZE * map_scale - 1,
                false
            );
        }
    }

    draw_set_color(c_red);
    draw_circle(
        map_offset_x + player_x * map_scale,
        map_offset_y + player_y * map_scale,
        5,
        false
    );

    draw_line_width_color(
        map_offset_x + player_x * map_scale,
        map_offset_y + player_y * map_scale,
        map_offset_x + (player_x + cos(player_angle) * 20) * map_scale,
        map_offset_y + (player_y - sin(player_angle) * 20) * map_scale,
        2,
        c_yellow,
        c_yellow
    );
}

function cast_ray(start_x, start_y, cos_angle, sin_angle, map_data, map_width, map_height, MAX_DEPTH, CELL_SIZE) {
    var distance = 0;
    var hit_wall = false;
    var test_x, test_y;
    
    while (distance < MAX_DEPTH && !hit_wall) {
        distance += 0.5;
        
        test_x = start_x + cos_angle * distance;
        test_y = start_y + sin_angle * distance;
        
        var test_cell_x = floor(test_x / CELL_SIZE);
        var test_cell_y = floor(test_y / CELL_SIZE);
        
        if (test_cell_x < 0 || test_cell_x >= map_width || test_cell_y < 0 || test_cell_y >= map_height) {
            hit_wall = true;
            distance = MAX_DEPTH;
        } else if (map_data[test_cell_x][test_cell_y] == 1) {
            hit_wall = true;
        }
    }
    
    return [distance, test_x, test_y];
}

function calculate_color_intensity(distance, test_x, test_y) {
    var color_intensity = clamp(180 - (distance * 1.2), 5, 180);
    
    var light_sources = global.light_sources;
    var num_lights = array_length(light_sources);
    for (var j = 0; j < num_lights; j++) {
        var light = light_sources[j];
        var light_distance = point_distance(test_x, test_y, light[0], light[1]);
        var light_intensity = light[2] / (1 + light_distance * 0.01);
        var falloff = 1 / (1 + light_distance * 0.005);
        color_intensity = min(color_intensity + light_intensity * falloff, 255);
    }

    return color_intensity;
}