#[repr(C)]
#[derive(Debug, Clone, Copy, bytemuck::Zeroable, bytemuck::Pod)]
pub struct Vertex {
    pub position: [f32; 2],
}

impl Vertex {
    const fn new(position: [f32; 2]) -> Self {
        Vertex { position }
    }

    pub fn desc() -> wgpu::VertexBufferLayout<'static> {
        wgpu::VertexBufferLayout {
            array_stride: std::mem::size_of::<Vertex>() as wgpu::BufferAddress,
            step_mode: wgpu::VertexStepMode::Vertex,
            attributes: &[
                // Position attribute
                wgpu::VertexAttribute {
                    offset: 0,
                    shader_location: 0,
                    format: wgpu::VertexFormat::Float32x2,
                },
            ],
        }
    }
}

pub const VERTICES: &[Vertex] = &[
    // First Triangle
    Vertex::new([-0.8, -0.8]),
    Vertex::new([0.8, -0.8]),
    Vertex::new([0.8, 0.8]),
    // Second Triangle
    Vertex::new([-0.8, -0.8]),
    Vertex::new([0.8, 0.8]),
    Vertex::new([-0.8, 0.8]),
];
