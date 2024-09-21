var fonte_personalizada = font_add("Arial", 32, true, false, 32, 128);
var texto = "Pressione:\n1 - Gráficos leves e alta performance\n2 - Meio termo\n3 - Melhores gráficos";
var cor_texto = make_color_rgb(255, 105, 180);
var cor_contorno = c_black;
var espessura_contorno = 2;
var texto_x = room_width / 2;
var texto_y = room_height / 2;
var efeito_arcoiris = true;
var amplitude_onda = 2;
var frequencia_onda = 0.1;
var espaco_caracteres = 0.8;
var espaco_linhas = 1.2;

if (!variable_instance_exists(id, "escala_popup")) {
    escala_popup = 0;
    velocidade_popup = 0.05;
}
escala_popup = min(escala_popup + velocidade_popup, 1);

if (!variable_instance_exists(id, "sistema_particulas")) {
    sistema_particulas = part_system_create();
    tipo_particula = part_type_create();
    part_type_shape(tipo_particula, pt_shape_flare);
    part_type_size(tipo_particula, 0.05, 0.2, -0.002, 0);
    part_type_color3(tipo_particula, c_aqua, c_fuchsia, c_yellow);
    part_type_alpha3(tipo_particula, 1, 0.7, 0);
    part_type_speed(tipo_particula, 1, 3, -0.05, 0.1);
    part_type_direction(tipo_particula, 0, 360, 1, 5);
    part_type_life(tipo_particula, 40, 80);
    
    transicao_ativa = false;
    temporizador_transicao = 0;
    duracao_transicao = 90;
    sala_destino = noone;
}

draw_set_font(fonte_personalizada);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var linhas = string_split(texto, "\n");
var largura_maxima = 0;
var altura_total = 0;

for (var l = 0; l < array_length(linhas); l++) {
    var largura_linha = string_width(linhas[l]) * espaco_caracteres;
    largura_maxima = max(largura_maxima, largura_linha);
    altura_total += string_height(linhas[l]) * espaco_linhas;
}

var inicio_y = texto_y - altura_total / 2;

for (var l = 0; l < array_length(linhas); l++) {
    var linha = linhas[l];
    var largura_linha = string_width(linha) * espaco_caracteres;
    var inicio_x = texto_x - largura_linha / 2;
    var linha_y = inicio_y + l * string_height(linha) * espaco_linhas;
    
    var char_x = inicio_x;
    for (var i = 1; i <= string_length(linha); i++) {
        var char = string_char_at(linha, i);
        var largura_char = string_width(char) * espaco_caracteres;
        
        var deslocamento_onda = sin((current_time / 1000 + i * 0.2) * frequencia_onda) * amplitude_onda;
        
        if (efeito_arcoiris) {
            draw_set_color(make_color_hsv((current_time / 15 + i * 8) % 255, 255, 255));
        } else {
            draw_set_color(cor_contorno);
        }
        
        var x_escala = texto_x + (char_x - texto_x) * escala_popup;
        var y_escala = texto_y + (linha_y - texto_y) * escala_popup;
        
        for (var ox = -espessura_contorno; ox <= espessura_contorno; ox++) {
            for (var oy = -espessura_contorno; oy <= espessura_contorno; oy++) {
                draw_text_transformed(x_escala + ox, y_escala + oy + deslocamento_onda, char, escala_popup, escala_popup, 0);
            }
        }
        
        draw_set_color(cor_texto);
        draw_text_transformed(x_escala, y_escala + deslocamento_onda, char, escala_popup, escala_popup, 0);
        
        char_x += largura_char;
    }
}

draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

if (!transicao_ativa) {
    if (keyboard_check_pressed(ord("1"))) {
        transicao_ativa = true;
        sala_destino = rm_fps;
    } else if (keyboard_check_pressed(ord("2"))) {
        transicao_ativa = true;
        sala_destino = rm_mid;
    } else if (keyboard_check_pressed(ord("3"))) {
        transicao_ativa = true;
        sala_destino = rm_graphs;
    }
}

if (transicao_ativa) {
    repeat(15) {
        part_particles_create(sistema_particulas, random(room_width), random(room_height), tipo_particula, 1);
    }
    
    temporizador_transicao++;
    
    if (temporizador_transicao >= duracao_transicao) {
        room_goto(sala_destino);
        transicao_ativa = false;
        temporizador_transicao = 0;
        sala_destino = noone;
    }
}

part_system_drawit(sistema_particulas);

var brilho = min(temporizador_transicao / 30, 1);
draw_set_alpha(brilho * 0.3);
draw_rectangle_color(0, 0, room_width, room_height, c_white, c_white, c_white, c_white, false);
draw_set_alpha(1);