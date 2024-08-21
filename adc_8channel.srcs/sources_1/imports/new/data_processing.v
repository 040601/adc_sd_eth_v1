`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/12 14:00:31
// Design Name: 
// Module Name: data_processing
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_processing(
    input clk_125m,
    input rd_clk,
    input rst_n,
    
    input [11:0] board1_adc1_a,
    input [11:0] board1_adc1_b,
    input [11:0] board1_adc2_a,
    input [11:0] board1_adc2_b,
    input [11:0] board2_adc1_a,
    input [11:0] board2_adc1_b,
    input [11:0] board2_adc2_a,
    input [11:0] board2_adc2_b,
    input rd_en_fifo4,
    input rd_en_fifo5,
    
    
    output [3:0] data_fifo4_out,
    output [3:0] data_fifo5_out,
    output [15:0] data_length,
    output [15:0] data_length_fifo5,
    output reg  sd_wr_start,
    output reg  eth_wr_start,
    
    output reg [3:0]led,
    output empty5
    );
    reg [60:0] time_cnt;
    wire [63:0] ttt;//total time
    reg [63:0] event_cnt;
   assign ttt[63:0] = {time_cnt,3'b000};
   
    reg wr_en_ttt;
    reg rd_en_ttt;
    wire [63:0] ttt_out;
    reg [63:0] ttt_out_tem;
    reg [3:0]data_fifo4_in;
    reg wr_en_fifo4;
 //   reg rd_en_fifo4;
 //   wire [3:0] data_fifo4_out;
    
    wire adc_A_rd_fifo1;
    wire adc_B_rd_fifo1;
    wire adc_C_rd_fifo1;
    wire adc_D_rd_fifo1;
    wire adc_E_rd_fifo1;
    wire adc_F_rd_fifo1;
    wire adc_G_rd_fifo1;
    wire adc_H_rd_fifo1;
    
    
    reg adc_A_rd_fifo3;
    reg adc_B_rd_fifo3;
    reg adc_C_rd_fifo3;
    reg adc_D_rd_fifo3;
    reg adc_E_rd_fifo3;
    reg adc_F_rd_fifo3;
    reg adc_G_rd_fifo3;
    reg adc_H_rd_fifo3;
    
    wire [3:0] adc_A_data_fifo3;
    wire [3:0] adc_B_data_fifo3;
    wire [3:0] adc_C_data_fifo3;
    wire [3:0] adc_D_data_fifo3;
    wire [3:0] adc_E_data_fifo3;
    wire [3:0] adc_F_data_fifo3;
    wire [3:0] adc_G_data_fifo3;
    wire [3:0] adc_H_data_fifo3;
    
    wire [12:0] adc_A_data_cnt_fifo3;
    wire [12:0] adc_B_data_cnt_fifo3;
    wire [12:0] adc_C_data_cnt_fifo3;
    wire [12:0] adc_D_data_cnt_fifo3;
    wire [12:0] adc_E_data_cnt_fifo3;
    wire [12:0] adc_F_data_cnt_fifo3;
    wire [12:0] adc_G_data_cnt_fifo3;
    wire [12:0] adc_H_data_cnt_fifo3;
    
    wire adc_A_fifo23_start;
    wire adc_B_fifo23_start;
    wire adc_C_fifo23_start;
    wire adc_D_fifo23_start;
    wire adc_E_fifo23_start;
    wire adc_F_fifo23_start;
    wire adc_G_fifo23_start;
    wire adc_H_fifo23_start;
    
    wire adc_A_fifo23_end;
    wire adc_B_fifo23_end;
    wire adc_C_fifo23_end;
    wire adc_D_fifo23_end;
    wire adc_E_fifo23_end;
    wire adc_F_fifo23_end;
    wire adc_G_fifo23_end;
    wire adc_H_fifo23_end;
    
    wire full2A;
    wire full2B;
    wire full2C;
    wire full2D;
    wire full2E;
    wire full2F;
    wire full2G;
    wire full2H;
    
    wire fifo23_end;
    wire fifo34_start;
    assign fifo23_end = adc_A_fifo23_end&&adc_B_fifo23_end&&adc_C_fifo23_end&&adc_D_fifo23_end&&adc_E_fifo23_end&&adc_F_fifo23_end&&adc_G_fifo23_end&&adc_H_fifo23_end;
    assign fifo34_start = fifo23_end;
    //trigger instead of fifo34_start,
    // fifo23_end act at thebiginning of s
    wire pre_start;
    assign pre_start = adc_A_fifo23_start||adc_B_fifo23_start||adc_C_fifo23_start||adc_D_fifo23_start||adc_E_fifo23_start||adc_F_fifo23_start||adc_G_fifo23_start||adc_H_fifo23_start;
    wire trigger;
    assign trigger = adc_A_rd_fifo1||adc_B_rd_fifo1||adc_C_rd_fifo1||adc_D_rd_fifo1||adc_E_rd_fifo1||adc_F_rd_fifo1||adc_G_rd_fifo1||adc_H_rd_fifo1;
    wire pre_start2 ;
    reg startt23;
    assign pre_start2 = startt23;
always@(posedge clk_125m or negedge rst_n)
begin
  if(~rst_n)
    begin
       time_cnt <= 0;
    end
  else 
    begin
      time_cnt <= time_cnt +1;
    end 
end       

//always @ ( posedge trigger or negedge rst_n)
// begin
//    if(~rst_n)
//      begin
//         event_cnt <= 0;
//         wr_en_ttt <= 0;
//      end
//    else
//    begin
//      wr_en_ttt <= 1;
//      event_cnt <= event_cnt+1;
//    end  
//   end//add wr_en_ttt<=0;
  reg pre_trigger;
  reg cur_trigger;
 always @ ( posedge clk_125m or negedge rst_n)
  begin
    if(~rst_n)
      begin
         pre_trigger <= 0;
         cur_trigger <= 0;
         event_cnt <= 0;
         wr_en_ttt <= 0;
      end
    else
    begin
      cur_trigger = trigger;
      if(cur_trigger&&(~pre_trigger))
      begin
      wr_en_ttt <= 1;
      event_cnt <= event_cnt+1;
      end
      else
      begin
      wr_en_ttt <= 0;
      end
      pre_trigger = cur_trigger;
    end  
   end
    reg pre_trig2;
    reg cur_trig2;
  
    always @ ( posedge clk_125m or negedge rst_n)
    begin
      if(~rst_n)
        begin
           pre_trig2 <= 0;
           cur_trig2 <= 0;
           startt23 <= 0;
        end
      else
      begin
        cur_trig2 = trigger;
        if((~cur_trig2)&&pre_trig2)
        begin
         startt23 <= 1;
        end
        else
        begin
        startt23 <= 0;
        end
        pre_trig2 = cur_trig2;
      end  
     end
     
   /////////////////////////////////////////////
//  reg flag;
//  always @(posedge clk_125m or negedge rst_n)
//  begin
//    if(~rst_n)
//    begin
//    flag <= 0;
//    wr_en_ttt<=1;
//    end
//    else 
//  end
  
  
//  always @ ( posedge trigger)
//  begin
//      wr_en_ttt <= 1;
//      event_cnt <= event_cnt+1;
//      flag <=1;
// end
      
             /////////////////////////////////
       
data_sample adc_A_data_sample(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board1_adc1_a),
    .trigger(12'd1600),
    //output
    .rd_fifo1(adc_A_rd_fifo1),
    .fifo23_start(adc_A_fifo23_start)
);    
data_sample adc_B_data_sample(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board1_adc1_b),
     .trigger(12'd1600),
    //output
    .rd_fifo1(adc_B_rd_fifo1),
    .fifo23_start(adc_B_fifo23_start)
);  
data_sample adc_C_data_sample(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board1_adc2_a),
    .trigger(12'd1600),
    //output
    .rd_fifo1(adc_C_rd_fifo1),
    .fifo23_start(adc_C_fifo23_start)
);  
data_sample adc_D_data_sample(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board1_adc2_b),
    .trigger(12'd1600),
    //output
    .rd_fifo1(adc_D_rd_fifo1),
    .fifo23_start(adc_D_fifo23_start)
);  
data_sample adc_E_data_sample(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board2_adc1_a),
    .trigger(12'd1600),
    //output
    .rd_fifo1(adc_E_rd_fifo1),
    .fifo23_start(adc_E_fifo23_start)
);  
data_sample adc_F_data_sample(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board2_adc1_b),
    .trigger(12'd1600),
    //output
    .rd_fifo1(adc_F_rd_fifo1),
    .fifo23_start(adc_F_fifo23_start)
);  
data_sample adc_G_data_sample(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board2_adc2_a),
    .trigger(12'd1600),
    //output
    .rd_fifo1(adc_G_rd_fifo1),
    .fifo23_start(adc_G_fifo23_start)
);  
data_sample adc_H_data_sample(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board2_adc2_b),
    .trigger(12'd1600),
    //output
    .rd_fifo1(adc_H_rd_fifo1),
    .fifo23_start(adc_H_fifo23_start)
);  
    
    
    
    
data_package adc_A_data_package
(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board1_adc1_a),
    .rd_fifo1(trigger),
    .rd_fifo3(adc_A_rd_fifo3),
    .fifo23_start(pre_start2),
    //output
    .data_fifo3_out(adc_A_data_fifo3),
    .data_cnt_fifo3(adc_A_data_cnt_fifo3),
    .fifo23_end(adc_A_fifo23_end),
    .full(full2A)
);
data_package adc_B_data_package
(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board1_adc1_b),
    .rd_fifo1(trigger),
    .rd_fifo3(adc_B_rd_fifo3),
    .fifo23_start(pre_start2),
    //output
    .data_fifo3_out(adc_B_data_fifo3),
    .data_cnt_fifo3(adc_B_data_cnt_fifo3),
    .fifo23_end(adc_B_fifo23_end),
    .full(full2B)
);
data_package adc_C_data_package
(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board1_adc2_a),
    .rd_fifo1(trigger),
    .rd_fifo3(adc_C_rd_fifo3),
    .fifo23_start(pre_start2),
    //output
    .data_fifo3_out(adc_C_data_fifo3),
    .data_cnt_fifo3(adc_C_data_cnt_fifo3),
    .fifo23_end(adc_C_fifo23_end),
    .full(full2C)
);
data_package adc_D_data_package
(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board1_adc2_b),
    .rd_fifo1(trigger),
    .rd_fifo3(adc_D_rd_fifo3),
    .fifo23_start(pre_start2),
    //output
    .data_fifo3_out(adc_D_data_fifo3),
    .data_cnt_fifo3(adc_D_data_cnt_fifo3),
    .fifo23_end(adc_D_fifo23_end),
    .full(full2D)
);
data_package adc_E_data_package
(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board2_adc1_a),
    .rd_fifo1(trigger),
    .rd_fifo3(adc_E_rd_fifo3),
    .fifo23_start(pre_start2),
    //output
    .data_fifo3_out(adc_E_data_fifo3),
    .data_cnt_fifo3(adc_E_data_cnt_fifo3),
    .fifo23_end(adc_E_fifo23_end),
    .full(full2E)
);
data_package adc_F_data_package
(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board2_adc1_b),
    .rd_fifo1(trigger),
    .rd_fifo3(adc_F_rd_fifo3),
    .fifo23_start(pre_start2),
    //output
    .data_fifo3_out(adc_F_data_fifo3),
    .data_cnt_fifo3(adc_F_data_cnt_fifo3),
    .fifo23_end(adc_F_fifo23_end),
    .full(full2F)
);
data_package adc_G_data_package
(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board2_adc2_a),
    .rd_fifo1(trigger),
    .rd_fifo3(adc_G_rd_fifo3),
    .fifo23_start(pre_start2),
    //output
    .data_fifo3_out(adc_G_data_fifo3),
    .data_cnt_fifo3(adc_G_data_cnt_fifo3),
    .fifo23_end(adc_G_fifo23_end),
    .full(full2G)
);
data_package adc_H_data_package
(
    //input
    .clk_125m(clk_125m),
    .rst_n(rst_n),
    .adc_data(board2_adc2_b),
    .rd_fifo1(trigger),
    .rd_fifo3(adc_H_rd_fifo3),
    .fifo23_start(pre_start2),
    //output
    .data_fifo3_out(adc_H_data_fifo3),
    .data_cnt_fifo3(adc_H_data_cnt_fifo3),
    .fifo23_end(adc_H_fifo23_end),
    .full(full2H)
);
//a big part
localparam IDLE34 = 0;
localparam START34 = 1;
localparam SEND34_header = 2;
localparam SEND34_channel = 3;       
localparam SEND34_data = 4;   
localparam END34 = 5;
reg [3:0] state34;       
reg [3:0] next_state34;  
reg send_state;
reg [13:0] cnt34;
reg [12:0] data_cnt;
reg [3:0] cnt_ch;
//??time bank?
wire [12:0]data_cnt_tem;
//always@(posedge clk_125m or negedge rst_n)
//begin
//if(~rst_n)
//  begin
//    data_cnt_tem = 0;
//  end
//else
//    data_cnt_tem = (data_cnt>0)?(data_cnt-1):0;
//end
assign data_cnt_tem = (data_cnt>0)?(data_cnt-1):0;
 always @ (posedge clk_125m or negedge rst_n)
 begin
     if(~rst_n)
     begin
     state34 <= IDLE34;
     end
     else
     begin
     state34 <= next_state34;
     end
 end     

always @(*)
begin
  case (state34)
  IDLE34:
    begin
    if(pre_start2 == 1)
    next_state34 <= START34;
    else
    next_state34 <= IDLE34;
    end
  START34:
    begin
    if(fifo34_start== 1)
    next_state34 <= SEND34_header;
    else
    next_state34 <= START34;
    end
 SEND34_header:
    begin
    if(cnt34 >= 31) // 8+16+ 8
    next_state34 <= SEND34_channel;
    else 
    next_state34 <= SEND34_header;
    end
 SEND34_channel://need to add channel number
    begin
    if(cnt34 >= 7 )
    next_state34 <= SEND34_data;
    else
    next_state34 <= SEND34_channel;
    end
   
 SEND34_data:
     begin
     if(cnt34 >= data_cnt_tem&& cnt_ch == 8)
        next_state34 <= END34;
     else if(cnt34 >=data_cnt_tem)
        next_state34 <= SEND34_channel;
     else 
        next_state34 <= SEND34_data;
     end
  END34:
    begin
        next_state34 <= IDLE34;
    end
  endcase
end
       

 always @ (posedge clk_125m or negedge rst_n)
 begin
    if(~rst_n)
    begin 
      cnt34 <= 0;
    end
    else
    if((state34 == SEND34_header||state34 == SEND34_channel || state34 == SEND34_data)&&state34==next_state34)
    begin
      cnt34<=cnt34+1;
    end
    else
    begin
      cnt34<=0;
      //wr_en_fifo4<=0;
    end
 end
 
 always @ (posedge clk_125m or negedge rst_n)
  begin
     if(~rst_n)
     begin 
       cnt_ch<=0;
     end
     else
     if(state34 == SEND34_channel &&state34 != next_state34)
     begin
       cnt_ch<=cnt_ch+1;
     end
     else
     if(state34 == END34||state34 == IDLE34)
     begin
       cnt_ch<=0;
     end
  end
  
  always @ (posedge clk_125m or negedge rst_n)
  begin
     if(~rst_n)
     begin 
      wr_en_fifo4<=0;
      data_fifo4_in<=0 ;
      rd_en_ttt<=0;
      data_cnt <= 0;
      adc_A_rd_fifo3<=0;
      adc_B_rd_fifo3<=0;
      adc_C_rd_fifo3<=0;
      adc_D_rd_fifo3<=0;
      adc_E_rd_fifo3<=0;
      adc_F_rd_fifo3<=0;
      adc_G_rd_fifo3<=0;
      adc_H_rd_fifo3<=0; 
     end
     else if(state34 == SEND34_header)
     begin
       case(cnt34)
       0:begin
       wr_en_fifo4<=1;
       data_fifo4_in<=2;
       end
       1:
       begin
       data_fifo4_in<=0;
       //wr_en_fifo4<=1;
       end
       2:data_fifo4_in<=0;
       3:data_fifo4_in<=4;
       4:data_fifo4_in<=0;
       5:data_fifo4_in<=6;
       6:
       begin
         data_fifo4_in<=0;
         rd_en_ttt<=1;
       end
       7:
       begin
         data_fifo4_in<=1;
         rd_en_ttt<=0;
       end
       8:data_fifo4_in<=ttt_out[63:60];   
       9:data_fifo4_in<=ttt_out[59:56];
       10:data_fifo4_in<=ttt_out[55:52];
       11:data_fifo4_in<=ttt_out[51:48];
       12:data_fifo4_in<=ttt_out[47:44];
       13:data_fifo4_in<=ttt_out[43:40];
       14:data_fifo4_in<=ttt_out[39:36];
       15:data_fifo4_in<=ttt_out[35:32];
       16:data_fifo4_in<=ttt_out[31:28];
       17:data_fifo4_in<=ttt_out[27:24];
       18:data_fifo4_in<=ttt_out[23:20];
       19:data_fifo4_in<=ttt_out[19:16];
       20:data_fifo4_in<=ttt_out[15:12];
       21:data_fifo4_in<=ttt_out[11:8];
       22:data_fifo4_in<=ttt_out[7:4];
       23:data_fifo4_in<=ttt_out[3:0];
       24:data_fifo4_in<=event_cnt[31:28];
       25:data_fifo4_in<=event_cnt[27:24];
       26:data_fifo4_in<=event_cnt[23:20];
       27:data_fifo4_in<=event_cnt[19:16];
       28:data_fifo4_in<=event_cnt[15:12];
       29:data_fifo4_in<=event_cnt[11:8];
       30:data_fifo4_in<=event_cnt[7:4];
       31:data_fifo4_in<=event_cnt[3:0];
       default:
       begin
         wr_en_fifo4 <= 0;
         data_fifo4_in<= 0;
       end
       endcase
     end
     else if(state34 == SEND34_channel)
      begin
        wr_en_fifo4<=1;
 //       adc_A_rd_fifo3<=0;
 //       adc_B_rd_fifo3<=0;
 //       adc_C_rd_fifo3<=0;
 //       adc_D_rd_fifo3<=0;
 //       adc_E_rd_fifo3<=0;
 //       adc_F_rd_fifo3<=0;
 //       adc_G_rd_fifo3<=0;
 //       adc_H_rd_fifo3<=0; 
        case(cnt34)
        0:data_fifo4_in<=0;
        1:data_fifo4_in<=0;
        2:data_fifo4_in<=0;
        3:data_fifo4_in<=0;
        4:data_fifo4_in<=0;
        5:
        //data_fifo4_in<=0;
              begin
                 data_fifo4_in<=0;
                   case(cnt_ch)
                   0:
                   begin
                     adc_A_rd_fifo3 <=1;
                   end
                   1:
                   begin
                     adc_B_rd_fifo3 <=1;
                   end
                   2:
                   begin
                     adc_C_rd_fifo3 <=1;
                   end
                   3:
                   begin
                      adc_D_rd_fifo3 <=1;
                   end
                   4:
                   begin
                      adc_E_rd_fifo3 <=1;
                   end
                   5:
                   begin
                      adc_F_rd_fifo3 <=1;
                   end
                   6:
                   begin
                      adc_G_rd_fifo3 <=1;
                   end
                   7:
                   begin
                      adc_H_rd_fifo3 <=1;
                   end
                   default:;
                   endcase
               end
        6:data_fifo4_in<=0;
//       begin
//          data_fifo4_in<=0;
//            case(cnt_ch)
//            0:
//            begin
//              adc_A_rd_fifo3 <=1;
//            end
//            1:
//            begin
//              adc_B_rd_fifo3 <=1;
//            end
//            2:
//            begin
//              adc_C_rd_fifo3 <=1;
//            end
//            3:
//            begin
//               adc_D_rd_fifo3 <=1;
//            end
//            4:
//            begin
//               adc_E_rd_fifo3 <=1;
//            end
//            5:
//            begin
//               adc_F_rd_fifo3 <=1;
//            end
//            6:
//            begin
//               adc_G_rd_fifo3 <=1;
//            end
//            7:
//            begin
//               adc_H_rd_fifo3 <=1;
//            end
//            default:;
//            endcase
//        end
        7:
        begin
            case(cnt_ch)
            0:
            begin
              data_fifo4_in<=1;
              data_cnt <=adc_A_data_cnt_fifo3;
           //   adc_A_rd_fifo3 <=1;
            end
            1:
            begin
              data_fifo4_in<=2;
              data_cnt <=adc_B_data_cnt_fifo3;
          //    adc_B_rd_fifo3 <=1;
            end
            2:
            begin
              data_fifo4_in<=3;
              data_cnt <=adc_C_data_cnt_fifo3;
           //   adc_C_rd_fifo3 <=1;
            end
            3:
            begin
               data_fifo4_in<=4;
               data_cnt <=adc_D_data_cnt_fifo3;
            //   adc_D_rd_fifo3 <=1;
            end
            4:
            begin
               data_fifo4_in<=5;
               data_cnt <=adc_E_data_cnt_fifo3;
            //   adc_E_rd_fifo3 <=1;
            end
            5:
            begin
               data_fifo4_in<=6;
               data_cnt <=adc_F_data_cnt_fifo3;
             //  adc_F_rd_fifo3 <=1;
            end
            6:
            begin
               data_fifo4_in<=7;
               data_cnt <=adc_G_data_cnt_fifo3;
             //  adc_G_rd_fifo3 <=1;
            end
            7:
            begin
               data_fifo4_in<=8;
               data_cnt <=adc_H_data_cnt_fifo3;
           //    adc_H_rd_fifo3 <=1;
            end
            default:
            begin
            data_fifo4_in<=0;      
            end
            endcase
        end
        default:
        begin
          data_fifo4_in<= 0;
          wr_en_fifo4<=0;
        end
        endcase
        end
     else if(state34 == SEND34_data)
     begin
        if(data_cnt == 0)
          begin
             wr_en_fifo4<=0;
             adc_A_rd_fifo3<=0;
             adc_B_rd_fifo3<=0;
             adc_C_rd_fifo3<=0;
             adc_D_rd_fifo3<=0;
             adc_E_rd_fifo3<=0;
             adc_F_rd_fifo3<=0;
             adc_G_rd_fifo3<=0;
             adc_H_rd_fifo3<=0; 
          end
      else
         begin
            wr_en_fifo4<=1;
            case(cnt_ch)
            1:data_fifo4_in<= adc_A_data_fifo3;
            2:data_fifo4_in<= adc_B_data_fifo3;
            3:data_fifo4_in<= adc_C_data_fifo3;
            4:data_fifo4_in<= adc_D_data_fifo3;
            5:data_fifo4_in<= adc_E_data_fifo3;
            6:data_fifo4_in<= adc_F_data_fifo3;
            7:data_fifo4_in<= adc_G_data_fifo3;
            8:data_fifo4_in<= adc_H_data_fifo3;
            default:
               begin
                 data_fifo4_in<=0;      
               end
            endcase
          if(cnt34 >=data_cnt_tem)
             begin
           adc_A_rd_fifo3<=0;
           adc_B_rd_fifo3<=0;
           adc_C_rd_fifo3<=0;
           adc_D_rd_fifo3<=0;
           adc_E_rd_fifo3<=0;
           adc_F_rd_fifo3<=0;
           adc_G_rd_fifo3<=0;
           adc_H_rd_fifo3<=0; 
             end
         end
    end
     else
     begin
       wr_en_fifo4 <= 0;
       adc_A_rd_fifo3<=0;
       adc_B_rd_fifo3<=0;
       adc_C_rd_fifo3<=0;
       adc_D_rd_fifo3<=0;
       adc_E_rd_fifo3<=0;
       adc_F_rd_fifo3<=0;
       adc_G_rd_fifo3<=0;
       adc_H_rd_fifo3<=0; 
     end
  end
always@(posedge clk_125m or negedge rst_n)
begin
    if(~rst_n)
    begin
      sd_wr_start <= 0;
      eth_wr_start<= 0;
     end
    else if (state34 == END34)
    begin
      sd_wr_start <=1;
      eth_wr_start<=1;
    end
    else
    begin
      sd_wr_start <= 0;
      eth_wr_start<= 0;
     end
end
//led
always@(posedge clk_125m or negedge rst_n)
begin
   if(~rst_n)
     led<=4'b0000;
   else if (full2A == 1)
      led<=4'b0001;
   else if (full2B == 1)
      led<=4'b0010;
   else if (full2C == 1)
      led<=4'b0011;
   else if (full2D == 1)
      led<=4'b0100;
   else if (full2E == 1)
     led<=4'b0101;
 else if (full2F == 1)
     led<=4'b0110;
  else if (full2G == 1)
     led<=4'b0111;
   else if (full2H == 1)
     led<=4'b1000;
   else
     led<=4'b0000;
end
    wire rd_rst_busy;
    wire full5;
    wire full4;
    wire wr_rst_busy;

    reg rst_n0;
    wire rst_n1;
    assign rst_n1 = rst_n&&rst_n0;
    reg [3:0] cnt_full;
    always@(posedge clk_125m or negedge rst_n)
    begin
    if(rst_n==0)
      begin
        rst_n0<=0;
      end
    else if(full5&&cnt_full == 0)
        rst_n0<=0;
    else 
        rst_n0<=1;
    end  
   always@(posedge clk_125m or negedge rst_n)
    begin
    if(rst_n==0)
      begin
        cnt_full<=0;
      end
    else if(full5)
        cnt_full<=cnt_full+1;
    end  


    reg rst_n3;
    wire rst_n4;
    assign rst_n4 = rst_n&&rst_n3;
    reg [3:0] cnt_full4;
    always@(posedge clk_125m or negedge rst_n)
    begin
    if(rst_n==0)
      begin
        rst_n3<=0;
      end
    else if(full4&&cnt_full4 == 0)
        rst_n3<=0;
    else 
        rst_n3<=1;
    end  
   always@(posedge clk_125m or negedge rst_n)
    begin
    if(rst_n==0)
      begin
        cnt_full4<=0;
      end
    else if(full4)
        cnt_full4<=cnt_full4+1;
    end  



wire [4:0] ttt_cnt;

fifo_ttt tt(
    .clk(clk_125m),                  // input wire clk
    .rst(~rst_n),                  // input wire rst
    .din(ttt),                  // input wire [63 : 0] din
    .wr_en(wr_en_ttt),              // input wire wr_en
    .rd_en(rd_en_ttt),              // input wire rd_en
    .dout(ttt_out),                // output wire [63 : 0] dout
    .full(),                // output wire full
    .empty(),              // output wire empty
    .data_count(ttt_cnt),    // output wire [4 : 0] data_count
    .wr_rst_busy(),  // output wire wr_rst_busy
    .rd_rst_busy() 
    );

    fifo4 adc_total_data_sd (
      .clk(clk_125m),                  // input wire clk
      .rst(~rst_n4),                  // input wire rst
      .din(data_fifo4_in),                  // input wire [3 : 0] din
      .wr_en(wr_en_fifo4),              // input wire wr_en
      .rd_en(rd_en_fifo4),              // input wire rd_en
      .dout(data_fifo4_out),                // output wire [3 : 0] dout
      .full(full4),                // output wire full
      .empty(),              // output wire empty
      .data_count(data_length),    // output wire [16 : 0] data_count
      .wr_rst_busy(),  // output wire wr_rst_busy
      .rd_rst_busy()  // output wire rd_rst_busy
    );

  fifo5 adc_total_data_eth (
       .wr_clk(clk_125m),            // input wire wr_clk
       .rd_clk(rd_clk),                   // input wire clk
      .rst(~rst_n1),                  // input wire rst
      .din(data_fifo4_in),                  // input wire [3 : 0] din
      .wr_en(wr_en_fifo4),              // input wire wr_en
      .rd_en(rd_en_fifo5),              // input wire rd_en
      .dout(data_fifo5_out),                // output wire [3 : 0] dout
      .full(full5),                              // output wire full
      .empty(empty5),                          // output wire empty
      .rd_data_count(data_length_fifo5),    // output wire [15: 0] data_count
      .wr_rst_busy(wr_rst_busy),            // output wire wr_rst_busy
      .rd_rst_busy(rd_rst_busy)  // output wire rd_rst_busy
    );
ila_1 uut_1(
   .clk(clk_125m),
   .probe0(wr_en_fifo4),
   .probe1(data_fifo4_in),
   .probe2(rd_en_fifo4),
   .probe3(data_fifo4_out),
   .probe4(state34),
   .probe5(next_state34),
   .probe6(fifo34_start),
   .probe7(cnt34),
   .probe8(trigger),
   .probe9(rd_en_ttt),
   .probe10(ttt_out),//64
   .probe11(pre_start),
   .probe12(data_cnt), //13
   .probe13(cnt_ch),//4
   .probe14(adc_A_rd_fifo3),
   .probe15(adc_A_data_cnt_fifo3),//13
   .probe16(data_cnt_tem),//13
   .probe17(sd_wr_start),
   .probe18(event_cnt),//64
   .probe19(full2F),
   .probe20(led),
   .probe21(ttt),
   .probe22(ttt_cnt),
   .probe23(rd_en_fifo5),
   .probe24(data_length_fifo5),
   .probe25(data_fifo5_out),
   .probe26(rd_rst_busy),
   .probe27(wr_rst_busy),
   .probe28(full5),
   .probe29(empty5)
   
);      
endmodule
