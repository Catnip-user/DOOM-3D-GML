function draw_debug_info() {
    if (keyboard_check(vk_lalt)) {
        var info_x = 0;
        var info_y = 0;
        var line_height = 10;
        var padding = 5;
        var max_width = 0;
        
        var debug_info = [
            "FPS: " + string(fps_real),
            "Room: " + room_get_name(room),
            "Instance Count: " + string(instance_count),
            "Mouse X: " + string(mouse_x) + ", Y: " + string(mouse_y),
            "Delta Time: " + string(delta_time / 1000000),
            "Game Speed: " + string(game_get_speed(gamespeed_fps)),
            "OS: " + os_get_config(),
            "Device: " + string(os_device),
            "Browser: " + string(os_browser),
            "Display: " + string(display_get_width()) + "x" + string(display_get_height()),
            "Window Size: " + string(window_get_width()) + "x" + string(window_get_height()),
            "Fullscreen: " + (window_get_fullscreen() ? "Yes" : "No"),
            "View Current: " + string(view_current),
            "View Visible: " + (view_visible[0] ? "Yes" : "No"),
			"Player X:" + string(obj_player.x),
			"Player Y:" + string(obj_player.y),
			"Real Room Height:" + string(room_height),
			"Real Room Width:" + string(room_width),
        ];
        
        for (var i = 0; i < array_length(debug_info); i++) {
            max_width = max(max_width, string_width(debug_info[i]));
        }
        
        draw_set_alpha(0.8);
        draw_rectangle_color(info_x - padding, info_y - padding, 
                             info_x + max_width + padding, 
                             info_y + (line_height * array_length(debug_info)) + padding,
                             c_black, c_black, c_black, c_black, false);
        draw_set_alpha(1);
        
        draw_set_font(-1);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        for (var i = 0; i < array_length(debug_info); i++) {
            draw_text_color(info_x, info_y + (i * line_height), debug_info[i],
                            c_lime, c_lime, c_yellow, c_yellow, 1);
        }
    }
}