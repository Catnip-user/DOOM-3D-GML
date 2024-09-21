var camera_offset = sin(z) * z_amplitude;
if room == rm_mid || room == rm_graphs{
    doom_3d_effect(obj_player.x, obj_player.y, camera_offset, obj_player.image_angle * (pi/180), map_data, [wall1], "ps");
} else {
    doom_3d_effect(obj_player.x, obj_player.y, camera_offset, obj_player.image_angle * (pi/180), map_data, [wall1], "fps");
}
draw_debug_info();

var margin = 5;
var bar_width = room_width * 0.2;
var bar_height = room_height * 0.03;
var text_size = room_height * 0.04;

draw_set_font(-1);
draw_set_color(c_black);
draw_set_valign(fa_bottom);
draw_set_halign(fa_left);

var text_scale = text_size / string_height("Stamina: 100%");
draw_text_transformed(margin, room_height - margin - bar_height - margin, "Stamina: " + string(round(stamina)) + "%", text_scale, text_scale, 0);

draw_healthbar(margin, room_height - margin - bar_height, margin + bar_width, room_height - margin, stamina, c_black, c_red, c_lime, 0, true, true);
draw_set_color(c_white)
