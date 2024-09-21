function init_map() {
    globalvar map_data, player_start, light_sources;

    map_data = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 1, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 0, 1, 0, 1],
        [1, 1, 1, 0, 0, 1, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 1, 0, 1, 1, 1, 0, 1],
        [1, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1]
    ];
    
    player_start = [160, 160, 0];
    
    light_sources = [
        [160, 160, 200],  
        [320, 320, 150], 
        [480, 160, 100] 
    ];
}
function get_map_cell(x, y) {
    var cell_size = 64;
    var map_x = floor(x / cell_size);
    var map_y = floor(y / cell_size);
    
    if (map_x >= 0 && map_x < array_length(map_data) &&
        map_y >= 0 && map_y < array_length(map_data[0])) {
        return map_data[map_x][map_y];
    }
    return 1; 
}

function set_map_cell(x, y, value) {
    var cell_size = 64;
    var map_x = floor(x / cell_size);
    var map_y = floor(y / cell_size);
    
    if (map_x >= 0 && map_x < array_length(map_data) &&
        map_y >= 0 && map_y < array_length(map_data[0])) {
        map_data[map_x][map_y] = value;
    }
}

function add_light_source(x, y, intensity) {
    array_push(light_sources, [x, y, intensity]);
}


function remove_light_source(index) {
    array_delete(light_sources, index, 1);
}
