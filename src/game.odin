package main;

import rl "vendor:raylib";

run: bool = true;

init :: proc() {
    rl.InitWindow(960, 540, "template");

    // SetTargetFPS usa emscripten_sleep no web.
    when ODIN_ARCH != .wasm32 {
        rl.SetTargetFPS(60);
    }
}

update :: proc() {
    rl.BeginDrawing();
    rl.ClearBackground(rl.DARKBLUE);
    rl.DrawText("Odin + Raylib", 40, 40, 32, rl.RAYWHITE);
    rl.EndDrawing();

    // WindowShouldClose também usa emscripten_sleep.
    // No web quem fecha é a aba do navegador.
    when ODIN_ARCH != .wasm32 {
        if rl.WindowShouldClose() {
            run = false;
        }
    }
}

should_run :: proc() -> bool {
    return run;
}

shutdown :: proc() {
    rl.CloseWindow();
}

parent_window_size_changed :: proc(width: int, height: int) {
    rl.SetWindowSize(i32(width), i32(height));
}