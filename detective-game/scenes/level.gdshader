shader_type canvas_item;

uniform float invert_amount : hint_range(0, 1) = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear;

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);
    vec3 inverted_color = 1.0 - color.rgb;
    
    COLOR.rgb = mix(color.rgb, inverted_color, invert_amount);
    COLOR.a = color.a;
}