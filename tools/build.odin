package main;

import "core:fmt";
import "core:os";

EXE         :: ".exe" when ODIN_OS == .Windows else "";
RAYLIB_WASM :: ODIN_ROOT + "vendor/raylib/wasm/libraylib.web.a";
RAYGUI_WASM :: ODIN_ROOT + "vendor/raylib/wasm/libraygui.a";
ODIN_JS     :: ODIN_ROOT + "core/sys/wasm/js/odin.js";


mkdir :: proc(path: string)
{
    if err := os.make_directory_all(path); err != nil {
        fmt.eprintln("nao consegui criar", path, "-", err);
        os.exit(1);
    }
}

copy :: proc(dst: string, src: string) {
    if err := os.copy_file(dst, src); err != nil {
        fmt.eprintln("nao consegui copiar", src, "para", dst, "-", err);
        os.exit(1);
    }
}

run :: proc(args: ..string) {
    fmt.println("->", args);

    process: os.Process;
    start_err: os.Error
    process, start_err = os.process_start({
        command = args,
        stdout = os.stdout,
        stderr = os.stderr
    });

    if start_err != nil {
        fmt.eprintln("nao consegui iniciar", args[0], "-", start_err);
        os.exit(1);
    }

    state: os.Process_State;
    wait_err: os.Error;
    state, wait_err = os.process_wait(process);

    if wait_err != nil {
        fmt.eprintln("falha ao esperar o processo -", wait_err);
        os.exit(1);
    }

    if state.exit_code != 0 {
        fmt.eprintln(args[0], "terminou com codigo", state.exit_code);
        os.exit(state.exit_code);
    }
}

build_web :: proc() {
    mkdir("build/web");

    run("odin", "build", "src",
        "-target:js_wasm32", "-build-mode:obj",
        "-define:RAYLIB_WASM_LIB=env.o", "-define:RAYGUI_WASM_LIB=env.o",
        "-out:build/web/game.wasm.o");

    copy("build/web/odin.js", ODIN_JS);

    run("emcc", "-o", "build/web/index.html",
        "build/web/game.wasm.o", RAYLIB_WASM, RAYGUI_WASM,
        "-sEXPORTED_RUNTIME_METHODS=['HEAPF32']",
        "-sUSE_GLFW=3",
        "-sWARN_ON_UNDEFINED_SYMBOLS=0",
        "-sASSERTIONS",
        "--shell-file", "web/index_template.html",
        "--preload-file", "assets");

    os.remove("build/web/game.wasm.o");
}

main :: proc() {
    target: string = len(os.args) > 1 ? os.args[1] : "debug";
    fmt.println("alvo de build:", target);

    switch target {
        case "debug":
            mkdir("build/debug");
            run("odin", "build", "src", "-out:build/debug/game" + EXE, "-debug");
            
        case "release":
            mkdir("build/release");
            run("odin", "build", "src", "-out:build/release/game" + EXE, "-o:speed");

        case "web":
            build_web();

        case "run":
            mkdir("build/release");
            run("odin", "build", "src", "-out:build/release/game" + EXE, "-o:speed");
            run("build/release/game" + EXE);

        case:
            fmt.eprintln("alvo desconhecido", target);
            fmt.eprintln("use: debug | release | web | run");
            os.exit(1);
    }
}