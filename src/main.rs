use window::create_window;

mod state;
mod vertices;
mod window;
fn main() {
    env_logger::init();
    pollster::block_on(create_window());
}
