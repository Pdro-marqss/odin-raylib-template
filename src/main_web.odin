#+build js
package main;

import "base:runtime";
import "core:mem"
import "core:c";

import em "./emscripten";

@(private = "file")
web_context: runtime.Context;

@export
main_start :: proc "c" () {
    context= runtime.default_context();
    context.allocator = em.emscripten_allocator();
    runtime.init_global_temporary_allocator(1 * mem.Megabyte);
    context.logger = em.create_emscripten_logger();
    web_context = context;
    init();
}

@export
main_update :: proc "c" () -> bool {
    context = web_context;
    update();
    return should_run();
}

@export
main_end :: proc "c" () {
    context = web_context;
    shutdown();
}

@export
web_window_size_changed :: proc "c" (width: c.int, height: c.int) {
    context = web_context;
    parent_window_size_changed(int(width), int(height));
}