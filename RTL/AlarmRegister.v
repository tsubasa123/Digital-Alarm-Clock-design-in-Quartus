module alarm_register (clock,
                       reset,
                       load_new_a,
                       new_alarm_time_ms_hr,
                       new_alarm_time_ls_hr,
                       new_alarm_time_ms_min,
                       new_alarm_time_ls_min,
                       alarm_time_ms_hr,
                       alarm_time_ls_hr,
                       alarm_time_ms_min,
                       alarm_time_ls_min);
    
    input clock, reset, load_new_a;
    input [3:0] new_alarm_time_ms_hr,
                new_alarm_time_ls_hr,
                new_alarm_time_ms_min,
                new_alarm_time_ls_min;

    output reg [3:0] alarm_time_ms_hr,
                     alarm_time_ls_hr,
                     alarm_time_ms_min,
                     alarm_time_ls_min;

    always @(posedge clock or posedge reset)
        begin
            if (reset)
                begin
                    alarm_time_ms_hr  <= 4'd0;
                    alarm_time_ls_hr  <= 4'd0;
                    alarm_time_ms_min <= 4'd0;
                    alarm_time_ls_min <= 4'd0;
                end 
            else if (load_new_a)
                begin
                    alarm_time_ms_hr  <= new_alarm_time_ms_hr;
                    alarm_time_ls_hr  <= new_alarm_time_ls_hr;
                    alarm_time_ms_min <= new_alarm_time_ms_min;
                    alarm_time_ls_min <= new_alarm_time_ls_min;
                end
            else 
                begin
                    alarm_time_ms_hr  <= alarm_time_ms_hr;
                    alarm_time_ls_hr  <= alarm_time_ls_hr;
                    alarm_time_ms_min <= alarm_time_ms_min;
                    alarm_time_ls_min <= alarm_time_ls_min;
                end
        end

endmodule