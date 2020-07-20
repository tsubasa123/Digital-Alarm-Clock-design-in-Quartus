module alarm_controller_fsm (one_second,
                             clock,
                             reset,
                             alarm_button,
                             time_button,
                             key,
                             load_new_c,
                             show_new_time,
                             show_a,
                             load_new_a,
                             reset_count,
                             shift);
    
    input one_second, clock, reset, alarm_button, time_button;
    input [3:0]key;
    output load_new_c, load_new_a, show_new_time, show_a, reset_count,shift;

    reg [2:0]present_state, next_state;
    wire time_out;
    reg [3:0]count1, count2; // The count variables to count the values in KEY_STORED and KEY_WAITED state.

    //The different states
    parameter SHOW_TIME         = 3'b000;
    parameter KEY_ENTRY         = 3'b001;
    parameter KEY_STORED        = 3'b010; 
    parameter SHOW_ALARM        = 3'b011;
    parameter SET_ALARM_TIME    = 3'b100;
    parameter SET_CURRENT_TIME  = 3'b101;
    parameter KEY_WAITED        = 3'b110;
    parameter NOT_PRESSED    = 10;

    //configuring the Counters count1 and count2.
    always @(posedge clock or posedge reset)
        begin
            if (reset)
                count1 <= 4'd0;
            else if (!(present_state == KEY_STORED)) 
                count1 <= 4'd0;
            else if (count1 == 4'd9)
                count1 <= 4'd0;
            else if (one_second)
                count1 = count1 + 1'b1;
        end
    
    always @(posedge clock or posedge reset)
    begin
        if (reset)
            count2 <= 4'd0;
        else if (!(present_state == KEY_WAITED)) 
            count2 <= 4'd0;
        else if (count2 == 4'd9)
            count2 <= 4'd0;
        else if (one_second)
            count2 = count2 + 1'b1;
    end

    //The time_out logic .. The time_out is active low signal.
    assign time_out = ((count1 == 9)||(count2 == 9)) ? 0 : 1;

    //The sequential part of the FSM.
    always @(posedge clock or posedge reset)
        begin
            if (reset)
                present_state <=  SHOW_TIME;
            else 
                present_state <= next_state;
        end
    
    //The next state logic
    always @(present_state or alarm_button or key or time_out or time_button)
        begin
            case (present_state)
                SHOW_TIME : 
                    begin
                        if (alarm_button)
                            next_state = SHOW_ALARM;
                        else if (key != NOT_PRESSED)
                            next_state = KEY_STORED;
                        else
                            next_state = SHOW_TIME;
                    end
                KEY_STORED : next_state = KEY_WAITED;
                KEY_WAITED:
                    begin
                        if (key == NOT_PRESSED)
                            next_state = KEY_ENTRY;
                        else if (time_out == 0)
                            next_state = SHOW_TIME;
                        else 
                            next_state = KEY_WAITED; 
                    end
                KEY_ENTRY:
                    begin
                        if (alarm_button)
                            next_state = SET_ALARM_TIME;
                        else if (time_button)
                            next_state = SET_CURRENT_TIME;
                        else if (time_out == 0)
                            next_state = SHOW_TIME;
                        else if (key != NOT_PRESSED)
                            next_state = KEY_STORED;
                        else 
                            next_state = KEY_ENTRY;
                    end
                SET_ALARM_TIME: next_state = SHOW_TIME;
                SET_CURRENT_TIME: next_state = SHOW_TIME;
                SHOW_ALARM:
                    begin
                        if (!alarm_button)
                            next_state = SHOW_TIME;
                        else
                            next_state = SHOW_ALARM; 
                    end
                default: next_state = SHOW_TIME;
            endcase
        end
    
        //The output logics
        //show_new_time causes the display driver to display the time while it is being set
        assign show_new_time = ((present_state == KEY_STORED)|| 
                                ( present_state == KEY_ENTRY)||
                                (present_state == KEY_WAITED)) ? 1 : 0;
        // It will cause the display to show the alarm screen
        assign show_a = (present_state == SHOW_ALARM) ? 1 : 0;
        // It will instruct the alarm register to load the value of the new alarm time
        assign load_new_a = (present_state == SET_ALARM_TIME) ? 1 : 0;
        // It will instruct the counter register that the alarm has been set and that the counter value has to be reset
        assign load_new_c = (present_state == SET_CURRENT_TIME) ? 1 : 0;
        // It will the timing generator the time has been set 
        assign reset_count = (present_state == SET_CURRENT_TIME) ? 1 : 0;
        // It will instruct the key register to shift a value to the left.
        assign shift = (present_state == KEY_STORED) ? 1 : 0; 

    
endmodule