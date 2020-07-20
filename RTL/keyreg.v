module key_reg(shift,
              key,
              clock,
              reset,
              key_buffer_ms_hr,
              key_buffer_ms_min,
              key_buffer_ls_hr,
              key_buffer_ls_min);
    
    input shift, clock, reset;
    input [3:0] key;  

    output reg [3:0] key_buffer_ms_hr,
                     key_buffer_ms_min,
                     key_buffer_ls_hr,
                     key_buffer_ls_min;
    
    always @(posedge clock or posedge reset)
        begin
            if (reset)
                begin
                    key_buffer_ms_hr  <= 0;
                    key_buffer_ls_hr  <= 0;
                    key_buffer_ms_min <= 0;
                    key_buffer_ls_min <= 0;
                end 
            else if (shift == 1)
                begin
                    key_buffer_ms_hr  <= key_buffer_ls_hr;
                    key_buffer_ls_hr  <= key_buffer_ms_min;
                    key_buffer_ms_min <= key_buffer_ls_min;
                    key_buffer_ls_min <= key;
                end
            else 
                begin
                    key_buffer_ms_hr  <= key_buffer_ms_hr;
                    key_buffer_ls_hr  <= key_buffer_ls_hr;
                    key_buffer_ms_min <= key_buffer_ms_min;
                    key_buffer_ls_min <= key;
                end
        end
endmodule