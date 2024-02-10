use winit::{
    event::*,
    event_loop::EventLoop,
    keyboard::{KeyCode, PhysicalKey},
    window::WindowBuilder,
};

use std::thread;
use std::time::Duration;

use crate::state::State;

const UPDATE_INTERVAL: u64 = 100;

pub async fn create_window() {
    let event_loop = EventLoop::new().unwrap();
    let window = WindowBuilder::new().build(&event_loop).unwrap();

    let mut state = State::new(window).await;
    state.step_up();
    event_loop
        .run(move |event, elwt| match event {
            Event::WindowEvent { event, .. } => match event {
                // Close window on pressing Q
                WindowEvent::KeyboardInput { event, .. } => match event {
                    KeyEvent {
                        physical_key: PhysicalKey::Code(KeyCode::KeyQ),
                        ..
                    } => elwt.exit(),
                    _ => {}
                },
                WindowEvent::RedrawRequested => match state.render() {
                    Ok(_) => thread::sleep(Duration::from_millis(UPDATE_INTERVAL)),
                    Err(_) => {}
                },
                WindowEvent::Resized(new_size) => state.resize(new_size),
                _ => {}
            },

            Event::AboutToWait => {
                state.window().request_redraw();
            }
            _ => (),
        })
        .unwrap();
}
