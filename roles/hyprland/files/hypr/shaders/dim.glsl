#version 320 es
precision mediump float;

in vec2 v_texcoord;

uniform sampler2D tex;

out vec4 fragColor;

void main() {
    vec4 color = texture(tex, v_texcoord);

    // Multiplied by 0.3 for 30% brightness
    // Assigned to our custom output variable instead of gl_FragColor
    fragColor = vec4(color.rgb * 0.3, color.a);
}