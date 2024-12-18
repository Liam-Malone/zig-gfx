const std = @import("std");

const BindingsGenerator = struct {
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    binding_gen: *std.Build.Step.Compile,
    wl_msg: *std.Build.Module,

    pub fn gen_bindings(self: *const BindingsGenerator, name: []const u8, xml_spec: std.Build.LazyPath) *std.Build.Module {
        const binding_gen_run = self.b.addRunArtifact(self.binding_gen);
        binding_gen_run.addFileArg(xml_spec);
        const bindings = binding_gen_run.addOutputFileArg(name);

        const bindings_module = self.b.addModule("bindings", .{
            .root_source_file = bindings,
            .target = self.target,
            .optimize = self.optimize,
        });

        bindings_module.addImport("wl_msg", self.wl_msg);
        return bindings_module;
    }
};

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const use_llvm = b.option(bool, "use-llvm", "Whether or not to use the LLVM compiler backend") orelse true;
    const use_lld = b.option(bool, "use-lld", "Whether or not to use LLD as the linker") orelse use_llvm;

    // BEGIN Wayland-Bindings
    const wl_msg_module = b.addModule("wl_msg", .{
        .root_source_file = b.path("src/wl_msg.zig"),
        .target = target,
        .optimize = optimize,
    });

    const bindgen = b.addExecutable(.{
        .name = "wl-zig-bindgen",
        .root_source_file = b.path("src/wl-zig-bindgen.zig"),
        .target = target,
        .optimize = optimize,
        .use_llvm = use_llvm,
        .use_lld = use_lld,
    });

    const bindings_generator: BindingsGenerator = .{
        .b = b,
        .target = target,
        .optimize = optimize,
        .wl_msg = wl_msg_module,
        .binding_gen = bindgen,
    };

    const wayland_bindings = bindings_generator.gen_bindings("wayland.zig", b.path("protocols/wayland/wayland.xml"));
    const xdg_shell_bindings = bindings_generator.gen_bindings("xdg_shell.zig", b.path("protocols/wayland/xdg-shell.xml"));
    const xdg_decoration_bindings = bindings_generator.gen_bindings("xdg_decorations.zig", b.path("protocols/wayland/xdg-decoration-unstable-v1.xml"));
    const linux_dmabuf_bindings = bindings_generator.gen_bindings("linux_dmabuf.zig", b.path("protocols/wayland/linux-dmabuf-v1.xml"));
    // END Wayland-Bindings

    const exe = b.addExecutable(.{
        .name = "Gfx-Project",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .use_llvm = use_llvm,
        .use_lld = use_lld,
    });

    // TODO: Add windows and eventually macos support
    switch (target.result.os.tag) {
        .linux => {
            exe.root_module.addImport("wl_msg", wl_msg_module);
            exe.root_module.addImport("wayland", wayland_bindings);
            exe.root_module.addImport("xdg_shell", xdg_shell_bindings);
            exe.root_module.addImport("xdg_decoration", xdg_decoration_bindings);
            exe.root_module.addImport("dmabuf", linux_dmabuf_bindings);
        },
        else => {
            std.log.err("Unsupported Platform: {s}\n", .{@tagName(target.result.os.tag)});
            std.process.exit(1);
        },
    }

    if (b.lazyDependency("vulkan-zig", .{
        .target = target,
        .optimize = optimize,
        .registry = @as([]const u8, b.pathFromRoot("protocols/vulkan/vk.xml")),
    })) |vkzig_dep| {
        const vkzig_bindings = vkzig_dep.module("vulkan-zig");
        exe.root_module.addImport("vulkan", vkzig_bindings);
        exe.linkSystemLibrary("vulkan");
    }

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run Program");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    // TODO: Add windows and eventually macos support
    switch (target.result.os.tag) {
        .linux => {
            exe_unit_tests.root_module.addImport("wl_msg", wl_msg_module);
            exe_unit_tests.root_module.addImport("wayland", wayland_bindings);
            exe_unit_tests.root_module.addImport("xdg_shell", xdg_shell_bindings);
            exe_unit_tests.root_module.addImport("xdg_decoration", xdg_decoration_bindings);
            exe_unit_tests.root_module.addImport("dmabuf", linux_dmabuf_bindings);
        },
        else => {
            std.log.err("Unsupported Platform: {s}\n", .{@tagName(target.result.os.tag)});
            std.process.exit(1);
        },
    }

    const test_step = b.step("test", "Run Tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
