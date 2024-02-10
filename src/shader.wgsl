
@group(0) @binding(0) var<uniform> grid: vec2<f32>;
@group(0) @binding(1) var<storage> cell_state: array<u32>;

struct VertexInput {
    @location(0) position: vec2<f32>,
    @builtin(instance_index) instance: u32
}

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) cell: vec2<f32>
};

@vertex
fn vs_main(
    input: VertexInput,
) -> VertexOutput {
   
    let i = f32(input.instance);
    let cell = vec2<f32>(i % grid.x, floor(i / grid.x));
    let state = f32(cell_state[input.instance]);

    let cell_offset = cell / grid * 2.0;
    let grid_pos = (input.position * state + 1.0) / grid - 1.0 + cell_offset;

    var out: VertexOutput;
    out.cell = cell;
    out.clip_position = vec4<f32>(grid_pos, 0.0, 1.0);
    return out;
}
 

@fragment
fn fs_main(input: VertexOutput) -> @location(0) vec4<f32> {
    let c = input.cell / grid;
    return vec4<f32>(c, 1.0 - c.x, 1.0);
}

