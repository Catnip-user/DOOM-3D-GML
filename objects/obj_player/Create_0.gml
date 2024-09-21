move_speed = 2;
rotation_speed = 3;
collision_buffer = 5; 
init_map(choose("labyrinth","open","default"))
z = 0;
z_speed = 0;
z_acceleration = 0.005;
z_max_speed = 0.01;
z_amplitude = 2;
is_moving = false;
z_return_speed = 0.02;
stamina = 100;
max_stamina = 100;
stamina_regen_rate = 0.5;
stamina_drain_rate = 1;
footstep_timer = 0;
footstep_interval = 20;