module timing_gen (reset,
                   reset_count,
                   clock,
                   fast_watch,
                   one_second,
                   one_minute);
    
    input reset, reset_count, clock, fast_watch;
    output reg one_second;
    output reg one_minute;

    reg [13:0]clock_count;
    reg one_minute_reg;

//The one_minute pulse generation.
    always @(posedge clock or posedge reset)
        begin
            if (reset) // if hard reset then set all values to zero
                begin
                    clock_count <= 14'b0;
                    one_minute_reg <= 4'd0;
                end
            else if (reset_count) // if the FSM sends a reset count value then set all values to zero
            begin
                clock_count <= 14'b0;
                one_minute_reg <=  4'd0;
            end
            else if (clock_count[13:0] == 14'd15259) // if the count reaches 15259 then increment the minute pulse by one.
            begin
                clock_count <= 14'b0;
                one_minute_reg <= 1'b1; // the one_minute_reg value stores the minute hand value
            end
            else  // if only the clock cycle is increasing then increment the count.
                begin
                    clock_count <= clock_count +1'b1;
                    one_minute_reg <= 4'd0;
                end
        end
    
// The one second pulse generation
    always @(posedge clock or posedge reset)
        begin
            if (reset) // if hard reset then set all values to zero
                begin
                    one_second <= 4'd0;
                end
            else if (reset_count) // if the FSM sends a reset count value then set all values to zero
            begin
                one_second <=  4'd0;
            end
            else if (clock_count[13:0] == 14'd255)
                begin
                    one_second <= 1'b1;
                end
            else 
                begin
                    one_second <= 4'd0;
                end
        end
    
    //The fastwatch Mode Logic that makes the counting faster
    always @(*)
        begin
            if (fast_watch)  //If fastwatch is asserted, make one_second equivalent to one_minute
                one_minute = one_second;
            else //assert one_minute signal when one_minute_reg is asserted
                one_minute = one_minute_reg; 
        end

endmodule