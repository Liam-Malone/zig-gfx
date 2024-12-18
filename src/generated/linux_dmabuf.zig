// WARNING: This file is auto-generated by wl-zig-bindgen.
//          It is recommended that you do NOT edit this file.
//
// TODO: Put a useful message in here when this thing is ready.
//

const std = @import("std");
const log = std.log.scoped(.@"linux-dmabuf-v1");

const wl_msg = @import("wl_msg"); // It's assumed that the user provides this module

/// factory for creating dmabuf-based wl_buffers
pub const LinuxDmabufV1 = struct {
    id: u32,
    version: u32 = 5,

    pub const destroy_params = struct {
        pub const op = 0;
    };

    /// unbind the factory
    pub fn destroy(self: *const LinuxDmabufV1, writer: anytype, params: destroy_params) !void {
        try wl_msg.write(writer, @TypeOf(params), params, self.id);
    }

    pub const create_params_params = struct {
        pub const op = 1;
        /// the new temporary
        params_id: u32,
    };

    /// create a temporary object for buffer parameters
    pub fn create_params(self: *const LinuxDmabufV1, writer: anytype, params: create_params_params) !void {
        try wl_msg.write(writer, @TypeOf(params), params, self.id);
    }

    pub const get_default_feedback_params = struct {
        pub const op = 2;
        id: u32,
    };

    /// get default feedback
    pub fn get_default_feedback(self: *const LinuxDmabufV1, writer: anytype, params: get_default_feedback_params) !void {
        try wl_msg.write(writer, @TypeOf(params), params, self.id);
    }

    pub const get_surface_feedback_params = struct {
        pub const op = 3;
        id: u32,
        surface: u32,
    };

    /// get feedback for a surface
    pub fn get_surface_feedback(self: *const LinuxDmabufV1, writer: anytype, params: get_surface_feedback_params) !void {
        try wl_msg.write(writer, @TypeOf(params), params, self.id);
    }
    pub const Event = union(enum) {
        format: Event.Format,
        modifier: Event.Modifier,

        /// supported buffer format
        pub const Format = struct {
            format: u32,
        };

        /// supported buffer format modifier
        pub const Modifier = struct {
            format: u32,
            modifier_hi: u32,
            modifier_lo: u32,
        };
        pub fn parse(op: u32, data: []const u8) !Event {
            return switch (op) {
                0 => .{ .format = try wl_msg.parse_data(Event.Format, data) },
                1 => .{ .modifier = try wl_msg.parse_data(Event.Modifier, data) },
                else => {
                    log.warn("Unknown linux_dmabuf_v1 event: {d}", .{op});
                    return error.UnknownEvent;
                },
            };
        }
    };
};

/// parameters for creating a dmabuf-based wl_buffer
pub const LinuxBufferParamsV1 = struct {
    id: u32,
    version: u32 = 5,
    pub const Error = enum(u32) {
        /// the dmabuf_batch object has already been used to create a wl_buffer
        already_used = 0,
        /// plane index out of bounds
        plane_idx = 1,
        /// the plane index was already set
        plane_set = 2,
        /// missing or too many planes to create a buffer
        incomplete = 3,
        /// format not supported
        invalid_format = 4,
        /// invalid width or height
        invalid_dimensions = 5,
        /// offset + stride * height goes out of dmabuf bounds
        out_of_bounds = 6,
        /// invalid wl_buffer resulted from importing dmabufs via the create_immed request on given buffer_params
        invalid_wl_buffer = 7,
    };
    pub const Flags = packed struct(u32) {
        /// contents are y-inverted
        y_invert: bool = false,
        /// content is interlaced
        interlaced: bool = false,
        /// bottom field first
        bottom_first: bool = false,
        __reserved_bit_3: bool = false,
        __reserved_bit_4: bool = false,
        __reserved_bit_5: bool = false,
        __reserved_bit_6: bool = false,
        __reserved_bit_7: bool = false,
        __reserved_bit_8: bool = false,
        __reserved_bit_9: bool = false,
        __reserved_bit_10: bool = false,
        __reserved_bit_11: bool = false,
        __reserved_bit_12: bool = false,
        __reserved_bit_13: bool = false,
        __reserved_bit_14: bool = false,
        __reserved_bit_15: bool = false,
        __reserved_bit_16: bool = false,
        __reserved_bit_17: bool = false,
        __reserved_bit_18: bool = false,
        __reserved_bit_19: bool = false,
        __reserved_bit_20: bool = false,
        __reserved_bit_21: bool = false,
        __reserved_bit_22: bool = false,
        __reserved_bit_23: bool = false,
        __reserved_bit_24: bool = false,
        __reserved_bit_25: bool = false,
        __reserved_bit_26: bool = false,
        __reserved_bit_27: bool = false,
        __reserved_bit_28: bool = false,
        __reserved_bit_29: bool = false,
        __reserved_bit_30: bool = false,
        __reserved_bit_31: bool = false,
    };
    pub const destroy_params = struct {
        pub const op = 0;
    };

    /// delete this object, used or not
    pub fn destroy(self: *const LinuxBufferParamsV1, writer: anytype, params: destroy_params) !void {
        try wl_msg.write(writer, @TypeOf(params), params, self.id);
    }

    pub const add_params = struct {
        pub const op = 1;
        /// dmabuf fd
        fd: std.posix.fd_t,
        /// plane index
        plane_idx: u32,
        /// offset in bytes
        offset: u32,
        /// stride in bytes
        stride: u32,
        /// high 32 bits of layout modifier
        modifier_hi: u32,
        /// low 32 bits of layout modifier
        modifier_lo: u32,
    };

    /// add a dmabuf to the temporary set
    pub fn add(self: *const LinuxBufferParamsV1, writer: anytype, params: add_params) !void {
        try wl_msg.write(writer, @TypeOf(params), params, self.id);
    }

    pub const create_params = struct {
        pub const op = 2;
        /// base plane width in pixels
        width: i32,
        /// base plane height in pixels
        height: i32,
        /// DRM_FORMAT code
        format: u32,
        /// see enum flags
        flags: Flags,
    };

    /// create a wl_buffer from the given dmabufs
    pub fn create(self: *const LinuxBufferParamsV1, writer: anytype, params: create_params) !void {
        try wl_msg.write(writer, @TypeOf(params), params, self.id);
    }

    pub const create_immed_params = struct {
        pub const op = 3;
        /// id for the newly created wl_buffer
        buffer_id: u32,
        /// base plane width in pixels
        width: i32,
        /// base plane height in pixels
        height: i32,
        /// DRM_FORMAT code
        format: u32,
        /// see enum flags
        flags: Flags,
    };

    /// immediately create a wl_buffer from the given dmabufs
    pub fn create_immed(self: *const LinuxBufferParamsV1, writer: anytype, params: create_immed_params) !void {
        try wl_msg.write(writer, @TypeOf(params), params, self.id);
    }
    pub const Event = union(enum) {
        created: Event.Created,
        failed: Event.Failed,

        /// buffer creation succeeded
        pub const Created = struct {
            buffer: u32,
        };

        /// buffer creation failed
        pub const Failed = struct {};
        pub fn parse(op: u32, data: []const u8) !Event {
            return switch (op) {
                0 => .{ .created = try wl_msg.parse_data(Event.Created, data) },
                1 => .{ .failed = try wl_msg.parse_data(Event.Failed, data) },
                else => {
                    log.warn("Unknown linux_buffer_params_v1 event: {d}", .{op});
                    return error.UnknownEvent;
                },
            };
        }
    };
};

/// dmabuf feedback
pub const LinuxDmabufFeedbackV1 = struct {
    id: u32,
    version: u32 = 5,
    pub const TrancheFlags = packed struct(u32) {
        /// direct scan-out tranche
        scanout: bool = false,
        __reserved_bit_1: bool = false,
        __reserved_bit_2: bool = false,
        __reserved_bit_3: bool = false,
        __reserved_bit_4: bool = false,
        __reserved_bit_5: bool = false,
        __reserved_bit_6: bool = false,
        __reserved_bit_7: bool = false,
        __reserved_bit_8: bool = false,
        __reserved_bit_9: bool = false,
        __reserved_bit_10: bool = false,
        __reserved_bit_11: bool = false,
        __reserved_bit_12: bool = false,
        __reserved_bit_13: bool = false,
        __reserved_bit_14: bool = false,
        __reserved_bit_15: bool = false,
        __reserved_bit_16: bool = false,
        __reserved_bit_17: bool = false,
        __reserved_bit_18: bool = false,
        __reserved_bit_19: bool = false,
        __reserved_bit_20: bool = false,
        __reserved_bit_21: bool = false,
        __reserved_bit_22: bool = false,
        __reserved_bit_23: bool = false,
        __reserved_bit_24: bool = false,
        __reserved_bit_25: bool = false,
        __reserved_bit_26: bool = false,
        __reserved_bit_27: bool = false,
        __reserved_bit_28: bool = false,
        __reserved_bit_29: bool = false,
        __reserved_bit_30: bool = false,
        __reserved_bit_31: bool = false,
    };
    pub const destroy_params = struct {
        pub const op = 0;
    };

    /// destroy the feedback object
    pub fn destroy(self: *const LinuxDmabufFeedbackV1, writer: anytype, params: destroy_params) !void {
        try wl_msg.write(writer, @TypeOf(params), params, self.id);
    }
    pub const Event = union(enum) {
        done: Event.Done,
        format_table: Event.FormatTable,
        main_device: Event.MainDevice,
        tranche_done: Event.TrancheDone,
        tranche_target_device: Event.TrancheTargetDevice,
        tranche_formats: Event.TrancheFormats,
        tranche_flags: Event.TrancheFlags,

        /// all feedback has been sent
        pub const Done = struct {};

        /// format and modifier table
        pub const FormatTable = struct {
            fd: std.posix.fd_t,
            size: u32,
        };

        /// preferred main device
        pub const MainDevice = struct {
            device: []const u8,
        };

        /// a preference tranche has been sent
        pub const TrancheDone = struct {};

        /// target device
        pub const TrancheTargetDevice = struct {
            device: []const u8,
        };

        /// supported buffer format modifier
        pub const TrancheFormats = struct {
            indices: []const u8,
        };

        /// tranche flags
        pub const TrancheFlags = struct {
            flags: LinuxDmabufFeedbackV1.TrancheFlags,
        };
        pub fn parse(op: u32, data: []const u8) !Event {
            return switch (op) {
                0 => .{ .done = try wl_msg.parse_data(Event.Done, data) },
                1 => .{ .format_table = try wl_msg.parse_data(Event.FormatTable, data) },
                2 => .{ .main_device = try wl_msg.parse_data(Event.MainDevice, data) },
                3 => .{ .tranche_done = try wl_msg.parse_data(Event.TrancheDone, data) },
                4 => .{ .tranche_target_device = try wl_msg.parse_data(Event.TrancheTargetDevice, data) },
                5 => .{ .tranche_formats = try wl_msg.parse_data(Event.TrancheFormats, data) },
                6 => .{ .tranche_flags = try wl_msg.parse_data(Event.TrancheFlags, data) },
                else => {
                    log.warn("Unknown linux_dmabuf_feedback_v1 event: {d}", .{op});
                    return error.UnknownEvent;
                },
            };
        }
    };
};
