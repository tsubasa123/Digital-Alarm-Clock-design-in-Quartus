module counter (one_minute,
                new_current_time_ms_hr,
                new_current_time_ms_min,
                new_current_time_ls_hr,
                new_current_time_ls_min,
                load_new_c,
                clock,
                reset,
                current_time_ms_hr,
                current_time_ms_min,
                current_time_ls_hr,
                current_time_ls_min);
    
    input clock, reset;
    input load_new_c;
    input [3:0] new_current_time_ms_hr,
                new_current_time_ms_min,
                new_current_time_ls_hr,
                new_current_time_ls_min;
    input one_minute;

    output reg [3:0] current_time_ms_hr,
                     current_time_ms_min,
                     current_time_ls_hr,
                     current_time_ls_min;
    
    always @(posedge clock or posedge reset)
        begin
            if (reset)
                begin
                    current_time_ms_hr <= 4'd0;
                    current_time_ls_hr <= 4'd0;
                    current_time_ms_min <= 4'd0;
                    current_time_ls_min <= 4'd0;
                end
            else if(load_new_c)
                begin
                     current_time_ms_hr <= new_current_time_ms_hr;
                     current_time_ls_hr <= new_current_time_ls_hr;
                     current_time_ms_min <= new_current_time_ms_min;
                     current_time_ls_min <= new_current_time_ls_min;
                end
            else if(one_minute == 1)
                begin
                    if (current_time_ms_hr == 4'd2 && current_time_ls_hr == 4'd3 &&
                        current_time_ms_min == 4'd5 && current_time_ls_min == 4'd9)
                        begin
                            current_time_ms_hr <= 4'd0;
                            current_time_ls_hr <= 4'd0;
                            current_time_ms_min <= 4'd0;
                            current_time_ls_min <= 4'd0;
                        end
                    else if (current_time_ls_hr == 4'd9 && current_time_ms_min == 4'd5
                             && current_time_ls_min == 4'd9)
                        begin
                            current_time_ms_hr <= current_time_ls_hr + 1'd1;
                            current_time_ls_hr <= 4'd0;
                            current_time_ms_min <= 4'd0;
                            current_time_ls_min <= 4'd0;
                        end
                    else if (current_time_ms_min == 4'd5 && current_time_ls_min == 4'd9)
                        begin
                            current_time_ls_hr <= current_time_ls_hr + 1'd1;
                            current_time_ms_min <= 4'd0;
                            current_time_ls_min <= 4'd0;
                        end
                    else if (current_time_ls_min == 4'd9)
                        begin
                            current_time_ms_min <= current_time_ms_min + 1'd1;
                            current_time_ls_min <= 4'd0;
                        end
                     else
                        begin
                            current_time_ls_min <= current_time_ls_min + 1'd1;
                        end

                end
        end

endmodule