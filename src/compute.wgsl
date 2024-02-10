@group(0) @binding(0) var<uniform> grid: vec2f;
@group(0) @binding(1) var<storage> cell_state_in: array<u32>;
@group(0) @binding(2) var<storage, read_write> cell_state_out: array<u32>;

fn cell_index(cell: vec2<i32>) -> u32 {
    return u32((cell.y % i32(grid.x)) * i32(grid.x) + (cell.x % i32(grid.x)));
}

fn cell_active(x: i32, y: i32) -> u32 {
    return cell_state_in[cell_index(vec2(x, y))];
}

@compute
@workgroup_size(8, 8)
fn compute_main(@builtin(global_invocation_id) cell: vec3u) {
    let cell_x = i32(cell.x);
    let cell_y = i32(cell.y);
    let active_neighbors = cell_active(cell_x+1, cell_y+1) +
                        cell_active(cell_x+1, cell_y) +
                        cell_active(cell_x+1, cell_y - 1) +
                        cell_active(cell_x, cell_y - 1) +
                        cell_active(cell_x - 1, cell_y - 1) +
                        cell_active(cell_x - 1, cell_y) +
                        cell_active(cell_x - 1, cell_y + 1) +
                        cell_active(cell_x, cell_y+1);

    let i = cell_index(vec2(cell_x, cell_y));

    // Conway's game of life rules:
    switch active_neighbors {
        case 2u: { // Active cells with 2 neighbors stay active.
            cell_state_out[i] = cell_state_in[i];
        }
        case 3u: { // Cells with 3 neighbors become or stay active.
            cell_state_out[i] = 1u;
        }
        default: { // Cells with < 2 or > 3 neighbors become inactive.
            cell_state_out[i] = 0u;
        }
    }
    // let i = cell_index(vec2(cell_x, cell_y));
    // if cell_state_in[i] == 1u {
    //     cell_state_out[i] = 0u;
    // } else {   
    //     cell_state_out[i] = 1u;
    // }
}