shader_type canvas_item;

uniform vec2 light_position; // Позиція джерела світла у просторі UV
uniform float light_radius = 0.5; // Радіус світла
uniform float light_intensity = 10.0; // Інтенсивність світла
uniform vec4 default_light_color = vec4(1.0, 1.0, 1.0, 1.0); // Колір світла для білого пікселя

void fragment() {
    // Отримуємо колір текстури у фрагменті
    vec4 color = texture(TEXTURE, UV);

    // Визначаємо відстань від поточного пікселя до позиції джерела світла
    float dist = distance(UV, light_position);

    // Вираховуємо коефіцієнт затухання світла
    float attenuation = clamp(1.0 - (dist / light_radius), 0.0, 1.0);

    // Ініціалізація кольору світла
    vec4 final_light_color = vec4(0.0);
    float brightness = 0.0;

    // Перевіряємо на білий піксель
    if (color.r > 0.9 && color.g > 0.9 && color.b > 0.9) {
        brightness = color.r; // Яскравість для білого
        final_light_color = default_light_color; // Білий світ
    }
    // Перевіряємо на червоний піксель
    else if (color.r > 0.9 && color.g < 0.2 && color.b < 0.2) {
        brightness = color.r; // Яскравість для червоного
        final_light_color = vec4(1.0, 0.0, 0.0, 1.0); // Червоне світло
    }
    // Перевіряємо на синій піксель
    else if (color.b > 0.9 && color.r < 0.2 && color.g < 0.2) {
        brightness = color.b; // Яскравість для синього
        final_light_color = vec4(0.0, 0.0, 1.0, 1.0); // Синє світло
    }

    // Якщо світловий ефект присутній
    if (attenuation > 0.0) {
        // Додаємо світло навіть навколо текстури, якщо ми далеко від текстури
        COLOR = mix(color, final_light_color, attenuation * light_intensity);
    } else {
        COLOR = color; // Якщо немає світла, залишаємо оригінальний колір
    }
}