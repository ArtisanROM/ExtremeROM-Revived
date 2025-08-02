LOG_STEP_IN "- Setting Adaptive HFR flags"
SET_PROP "vendor" "debug.sf.show_refresh_rate_overlay_render_rate" "true"
SET_PROP "vendor" "ro.surface_flinger.game_default_frame_rate_override" "60"
SET_PROP "vendor" "ro.surface_flinger.use_content_detection_for_refresh_rate" "true"
SET_PROP "vendor" "ro.surface_flinger.set_idle_timer_ms" "250"
SET_PROP "vendor" "ro.surface_flinger.set_touch_timer_ms" "300"
SET_PROP "vendor" "ro.surface_flinger.set_display_power_timer_ms" "200"
SET_PROP "vendor" "ro.surface_flinger.enable_frame_rate_override" "true"
LOG_STEP_OUT
