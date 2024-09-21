if room = rm_graphs{
doom_3d_effect(obj_player.x, obj_player.y, obj_player.image_angle * (pi/180), map_data, [wall1], "ps");
}
else if room = rm_mid{
		doom_3d_effect(obj_player.x, obj_player.y, obj_player.image_angle * (pi/180), map_data, [wall1], "ps");
}
else{
	doom_3d_effect(obj_player.x, obj_player.y, obj_player.image_angle * (pi/180), map_data, [wall1], "fps");
}
draw_debug_info()