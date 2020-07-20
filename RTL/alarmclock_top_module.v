module alarmclock_top (reset,
                       clock,
                       fast_watch,
                       alarm_button,
                       time_button,
                       key,
                       alarm_sound,
                       ms_hour,
                       ls_hour,
                       ms_min,
                       ls_min);

    input clock,
          reset,
          fast_watch,
          alarm_button,
          time_button;
    input [3:0] key;

    output [7:0] ms_hour,
                 ls_hour,
                 ms_min,
                 ls_min;
    output alarm_sound;

    wire one_second,
         one_minute,
         reset_count;
    wire load_new_c,
         show_new_time,
         show_a,
         load_new_a,
         shift;
    wire [3:0] key_buffer_ms_hr,
               key_buffer_ls_hr,
               key_buffer_ms_min,
               key_buffer_ls_min;
    wire [3:0] current_time_ms_hr,
               current_time_ls_hr,
               current_time_ms_min,
               current_time_ls_min;
    wire [3:0] alarm_time_ms_hr,
               alarm_time_ls_hr,
               alarm_time_ms_min,
               alarm_time_ls_min;
    
     timing_gen TIMING_GENERATOR (.reset(reset),
                                 .reset_count(reset_count),
                                 .clock(clock),
                                 .fast_watch(fast_watch),
                                 .one_second(one_second),
                                 .one_minute(one_minute));
    
    alarm_controller_fsm ALARM_CONTROLLER (.one_second(one_second),
                                            .clock(clock),
                                            .reset(reset),
                                            .alarm_button(alarm_button),
                                            .time_button(time_button),
                                            .key(key),
                                            .load_new_c(load_new_c),
                                            .show_new_time(show_new_time),
                                            .show_a(show_a),
                                            .load_new_a(load_new_a),
                                            .reset_count(reset_count),
                                            .shift(shift));

    key_reg KEY_REGISTER (.shift(shift),
                         .key(key),
                         .clock(clock),
                         .reset(reset),
                         .key_buffer_ms_hr(key_buffer_ms_hr),
                         .key_buffer_ms_min(key_buffer_ms_min),
                         .key_buffer_ls_hr(key_buffer_ls_hr),
                         .key_buffer_ls_min(key_buffer_ls_min));
                        
    counter COUNTER (.one_minute(one_minute),
                     .new_current_time_ms_hr(key_buffer_ms_hr),
                     .new_current_time_ms_min(key_buffer_ms_min),
                     .new_current_time_ls_hr(key_buffer_ls_hr),
                     .new_current_time_ls_min(key_buffer_ls_min),
                     .load_new_c(load_new_c),
                     .clock(clock),
                     .reset(reset),
                     .current_time_ms_hr(current_time_ms_hr),
                     .current_time_ms_min(current_time_ms_min),
                     .current_time_ls_hr(current_time_ls_hr),
                     .current_time_ls_min(current_time_ls_min));

    alarm_register ALARM_REGISTER (.clock(clock),
                                   .reset(reset),
                                   .load_new_a(load_new_a),
                                   .new_alarm_time_ms_hr(key_buffer_ms_hr),
                                   .new_alarm_time_ls_hr(key_buffer_ls_hr),
                                   .new_alarm_time_ms_min(key_buffer_ms_min),
                                   .new_alarm_time_ls_min(key_buffer_ls_min),
                                   .alarm_time_ms_hr(alarm_time_ms_hr),
                                   .alarm_time_ls_hr(alarm_time_ls_hr),
                                   .alarm_time_ms_min(alarm_time_ms_min),
                                   .alarm_time_ls_min(alarm_time_ls_min));

    display_driver DISPLAY (.current_time_ms_hr(current_time_ms_hr),
                            .current_time_ls_hr(current_time_ls_hr),
                            .current_time_ms_min(current_time_ms_min),
                            .current_time_ls_min(current_time_ls_min),
                            .alarm_time_ms_hr(alarm_time_ms_hr),
                            .alarm_time_ls_hr(alarm_time_ls_hr),
                            .alarm_time_ms_min(alarm_time_ms_min),
                            .alarm_time_ls_min(alarm_time_ls_min),
                            .show_new_time(show_new_time),
                            .show_a(show_a),
                            .key_buffer_ms_hr(key_buffer_ms_hr),
                            .key_buffer_ls_hr(key_buffer_ls_hr),
                            .key_buffer_ms_min(key_buffer_ms_min),
                            .key_buffer_ls_min(key_buffer_ls_min),
                            .sound_alarm(alarm_sound),
                            .display_time_ms_hr(ms_hour),
                            .display_time_ls_hr(ls_hour),
                            .display_time_ms_min(ms_min),
                            .display_time_ls_min(ls_min));
    
endmodule