module alarmclock_TB ();

    reg clock,
        reset,
        fast_watch,
        alarm_button,
        time_button;

    reg [3:0] key;

    wire [7:0] ms_hour,
               ls_hour,
               ms_min,
               ls_min;

    wire alarm_sound;

    parameter clock_cycle = 2;

    alarmclock_top TEST (.clock(clock),
                         .reset(reset),
                         .fast_watch(fast_watch),
                         .alarm_button(alarm_button),
                         .time_button(time_button),
                         .key(key),
                         .ms_hour(ms_hour),
                         .ls_hour(ls_hour),
                         .ms_min(ms_min),
                         .ls_min(ls_min),
                         .alarm_sound(alarm_sound));
    
    always
        begin
            #(clock_cycle/2)
                clock = 1'b1;
            #(clock_cycle/2)
                clock = ~clock; 
        end

    task initialize;
        begin
            clock = 1'b0;
            reset = 1'b0;
            alarm_button = 1'b0;
            time_button = 1'b0;
        end
    endtask
   

    task hardreset;
        begin
            reset = 1'b1;
            #10
            reset = 1'b0;
        end
    endtask

    task alarmbuttonpress;
        begin
            @(negedge clock);
            alarm_button = 1'b1;
            @(negedge clock);
            alarm_button = 1'b0;
        end
    endtask

    task timebuttonpress;
        begin
            @(negedge clock);
            time_button = 1'b1;
            @(negedge clock);
            time_button = 1'b0;
        end
    endtask

    //send stimulus 
   initial
        begin
            //initialize the values
           initialize;
           //hard reset the clock
           hardreset; 
           //Set fastwatch to 1 to make counting faster 
           fast_watch = 1'b1;
           //Set  key time to current time :11:23
            key = 1;
            repeat(3)
            @(negedge clock);
            key = 10;
            @(negedge clock);
            key = 1;
            repeat(3)
            @(negedge clock);
            key = 10;
            @(negedge clock);
            key = 2;
            repeat(3)
            @(negedge clock);
            key = 10;
            @(negedge clock);
            key = 3;
            repeat(3)   
            @(negedge clock);
            key = 10;
            timebuttonpress;

            //Set  key time to alarm time :11:30
            key = 1;
            repeat(3)
            @(negedge clock);
            key = 10;
            @(negedge clock);
            key = 1;
            repeat(3)
            @(negedge clock);
            key = 10;
            @(negedge clock);
            key = 3;
            repeat(3)
            @(negedge clock);
            key = 10;
            @(negedge clock);
            key = 0;
            repeat(3)
            @(negedge clock);
            key = 10;
            alarmbuttonpress;

            #(7*256*2);//7 -> 7minutes ->7seconds->7 *256 clock cycles ->7*256*2(Time period of clock)
            //Time out for Alarm clock 
                //key = 7;
            repeat(4*2564) //Wait for minimum 10second pulses i.e (10*256) clock cycles 
            @(negedge clock);
            $finish;
        end

       initial
            begin
               $monitor ($time,"    DISPLAY_MS_HR =%H >>> DISPLAY_LS_HR =%H>>> DISPLAY_MS_MIN =%H>>> DISPLAY_LS_MIN=%H",ms_hour[3:0],ls_hour[3:0],ms_min[3:0],ls_min[3:0]);
            end
          

    
endmodule