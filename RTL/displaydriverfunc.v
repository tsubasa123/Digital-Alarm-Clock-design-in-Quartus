module display_driver_func (current_time,
                            show_new_time,
                            alarm_time,
                            key_buffer_time,
                            show_a,
                            sound_alarm,
                            display_time);

    input show_a, show_new_time;
    input [3:0] current_time;
    input [3:0] alarm_time;
    input [3:0] key_buffer_time;
    
    output reg sound_alarm;
    output reg [7:0] display_time;

    reg [3:0] lcd_display;

    parameter ZERO  = 8'h30,
              ONE   = 8'h31,
              TWO   = 8'h32,
              THREE = 8'h33,
              FOUR  = 8'h34,
              FIVE  = 8'h35,
              SIX   = 8'h36,
              SEVEN = 8'h37,
              EIGHT = 8'h38,
              NINE  = 8'h39,
              ERROR = 8'h3A;

    always @(show_a or show_new_time or current_time or alarm_time or key_buffer_time)
        begin
            if (show_a)
                lcd_display = alarm_time;
            else if (show_new_time)
                lcd_display = key_buffer_time;
            else
                lcd_display = current_time;
            if (current_time == alarm_time)
                sound_alarm = 1'b1;
            else
                sound_alarm = 1'b0;
        end
    
    always @(lcd_display)
        begin
            case (lcd_display)
                4'd0: display_time = ZERO;
                4'd1: display_time = ONE;
                4'd2: display_time = TWO;
                4'd3: display_time = THREE;
                4'd4: display_time = FOUR;
                4'd5: display_time = FIVE;
                4'd6: display_time = SIX;
                4'd7: display_time = SEVEN;
                4'd8: display_time = EIGHT;
                4'd9: display_time = NINE;
                default: display_time = ERROR;
            endcase 
        end
   
endmodule