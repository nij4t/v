import sokol
import sokol.sapp
import sokol.gfx
import sokol.sgl

struct AppState {
	pass_action sg_pass_action
}

const (
	used_import = sokol.used_import
)

fn main() {
	state := &AppState{
		pass_action: gfx.create_clear_pass(0.1, 0.1, 0.1, 1.0)
	}
	title := 'Sokol Drawing Template'
	desc := sapp_desc{
		user_data: state
		init_userdata_cb: init
		frame_userdata_cb: frame
		window_title: title.str
		html5_canvas_name: title.str
	}
	sapp.run(&desc)
}

fn init(user_data voidptr) {
	desc := sg_desc{
		mtl_device: sapp.metal_get_device()
		mtl_renderpass_descriptor_cb: sapp.metal_get_renderpass_descriptor
		mtl_drawable_cb: sapp.metal_get_drawable
		d3d11_device: sapp.d3d11_get_device()
		d3d11_device_context: sapp.d3d11_get_device_context()
		d3d11_render_target_view_cb: sapp.d3d11_get_render_target_view
		d3d11_depth_stencil_view_cb: sapp.d3d11_get_depth_stencil_view
	}
	gfx.setup(&desc)
	sgl_desc := sgl_desc_t{}
	sgl.setup(&sgl_desc)
}

fn frame(user_data voidptr) {
	// println('frame')
	state := &AppState(user_data)
	draw()
	gfx.begin_default_pass(&state.pass_action, sapp.width(), sapp.height())
	sgl.draw()
	gfx.end_pass()
	gfx.commit()
}

fn draw() {
	// first, reset and setup ortho projection
	sgl.defaults()
	sgl.matrix_mode_projection()
	sgl.ortho(0.0, f32(sapp.width()), f32(sapp.height()), 0.0, -1.0, 1.0)
	sgl.c4b(255, 0, 0, 128)
	draw_hollow_rect(10, 10, 100, 30)
	sgl.c4b(25, 150, 0, 128)
	draw_filled_rect(10, 150, 80, 40)
	// line(0, 0, 500, 500)
}

fn draw_hollow_rect(x, y, w, h f32) {
	sgl.begin_line_strip()
	sgl.v2f(x, y)
	sgl.v2f(x + w, y)
	sgl.v2f(x + w, y + h)
	sgl.v2f(x, y + h)
	sgl.v2f(x, y)
	sgl.end()
}

fn draw_filled_rect(x, y, w, h f32) {
	sgl.begin_quads()
	sgl.v2f(x, y)
	sgl.v2f(x + w, y)
	sgl.v2f(x + w, y + h)
	sgl.v2f(x, y + h)
	sgl.end()
}
