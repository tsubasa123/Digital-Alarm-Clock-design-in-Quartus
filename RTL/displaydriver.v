module display_driver (current_time_ms_hr,
                       current_time_ls_hr,
                       current_time_ms_min,
                       current_time_ls_min,
                       alarm_time_ms_hr,
                       alarm_time_ls_hr,
                       alarm_time_ms_min,
                       alarm_time_ls_min,
                       show_new_time,
                       show_a,
                       key_buffer_ms_hr,
                       key_buffer_ls_hr,
                       key_buffer_ms_min,
                       key_buffer_ls_min,
                       sound_alarm,
                       display_time_ms_hr,
                       display_time_ls_hr,
                       display_time_ms_min,
                       display_time_ls_min);

    input show_new_time,show_a;
    input [3:0] current_time_ms_hr,
                current_time_ls_hr,
                current_time_ms_min,
                current_time_ls_min;
    input [3:0] alarm_time_ms_hr,
                alarm_time_ls_hr,
                alarm_time_ms_min,
                alarm_time_ls_min;
    input [3:0] key_buffer_ms_hr,
                key_buffer_ls_hr,
                key_buffer_ms_min,
                key_buffer_ls_min;
    output sound_alarm;
    output [7:0] display_time_ms_hr,
                 display_time_ls_hr,
                 display_time_ms_min,
                 display_time_ls_min;

    wire sound_alarm1, sound_alarm2, sound_alarm3, sound_alarm4;

    assign sound_alarm = (sound_alarm1 & sound_alarm2 & sound_alarm3 & sound_alarm4);

    display_driver_func MS_HR (.current_time(current_time_ms_hr),
                               .show_new_time(show_new_time),
                               .alarm_time(alarm_time_ms_hr),
                               .key_buffer_time(key_buffer_ms_hr),
                               .show_a(show_a),
                               .sound_alarm(sound_alarm1),
                               .display_time(display_time_ms_hr));

    display_driver_func LS_HR (.current_time(current_time_ls_hr),
                               .show_new_time(show_new_time),
                               .alarm_time(alarm_time_ls_hr),
                               .key_buffer_time(key_buffer_ls_hr),
                               .show_a(show_a),
                               .sound_alarm(sound_alarm2),
                               .display_time(display_time_ls_hr));
                    
    display_driver_func MS_MIN (.current_time(current_time_ms_min),
                               .show_new_time(show_new_time),
                               .alarm_time(alarm_time_ms_min),
                               .key_buffer_time(key_buffer_ms_min),
                               .show_a(show_a),
                               .sound_alarm(sound_alarm3),
                               .display_time(display_time_ms_min));
        
    display_driver_func LS_MIN (.current_time(current_time_ls_min),
                               .show_new_time(show_new_time),
                               .alarm_time(alarm_time_ls_min),
                               .key_buffer_time(key_buffer_ls_min),
                               .show_a(show_a),
                               .sound_alarm(sound_alarm4),
                               .display_time(display_time_ls_min));

endmodule
