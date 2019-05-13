module VALU (v1_i, v2_i, VALUCtrl_i, v_o,over);

    input signed[31:0] v1_i, v2_i; 
    input [2:0] VALUCtrl_i; //VALU instruction
    output reg [31:0] v_o; //output vector
    output reg [3:0]  over;//signed bit
    //output reg VZero_o; //branching signal

    reg signed[7:0] e1, e2, e3, e4;
    reg signed[7:0] b1,b2,b3,b4,b5,b6,b7,b8;
    wire [15:0]  a1,a2,a3,a4,a5,a6,a7,a8;
    reg signed[15:0]   s1,s2,s3,s4;
    //sign extension
    assign a1 = {{8{v1_i[7]}} ,v1_i[7:0]};
    assign a2 = {{8{v2_i[7]}} ,v2_i[7:0]};
    assign a3 = {{8{v1_i[15]}},v1_i[15:8]};
    assign a4 = {{8{v2_i[15]}},v2_i[15:8]};
    assign a5 = {{8{v1_i[23]}},v1_i[23:16]};
    assign a6 = {{8{v2_i[23]}},v2_i[23:16]};
    assign a7 = {{8{v1_i[31]}},v1_i[31:24]};
    assign a8 = {{8{v2_i[31]}},v2_i[31:24]};

    

    parameter VSUM  = 3'b010; //vector addition
    parameter VSUB  = 3'b110; //vector subtraction
    parameter VDP   = 3'b001; //dot product
    //parameter VSM   = 3'b000; //scalar multiplication
    //parameter VADDI = 3'b011; //vector addi
    //parameter VXP  = 3'b100; //cross product
    
    always @(*) begin
        
        //VZero_o = (v1_i - v2_i) ? 0 : 1;
        over[0] = 0;
        over[1] = 0;
        over[2] = 0;
        over[3] = 0;
        b1 = v1_i[7:0];
        b2 = v2_i[7:0];
        b3 = v1_i[15:8];
        b4 = v2_i[15:8];
        b5 = v1_i[23:16];
        b6 = v2_i[23:16];
        b7 = v1_i[31:24];
        b8 = v2_i[31:24];
        case (VALUCtrl_i)
            VSUM: begin
                
                e1 = b1 + b2;
                e2 = b3 + b4;
                e3 = b5 + b6;
                e4 = b7 + b8;
                v_o = {e4,e3,e2,e1};
                
                if( ~v1_i[7]  & ~v2_i[7] )over[0] = 1;
                else over[0] = 0;
                if( ~v1_i[15] & ~v2_i[15] )over[1] = 1;
                else over[1] = 0;
                if( ~v1_i[23] & ~v2_i[23] )over[2] = 1;
                else over[2] = 0;
                if( ~v1_i[31] & ~v2_i[31] )over[3] = 1;
                else over[3] = 0;
                
            end
            
            VSUB: begin

                e1 = b1 - b2;
                e2 = b3 - b4;
                e3 = b5 - b6;
                e4 = b7 - b8;
                v_o = {e4,e3,e2,e1};


                if( ~v1_i[7]  & (v2_i[7]) )over[0] = 1;
                else over[0] = 0;
                if( ~v1_i[15] & (v2_i[15]) )over[1] = 1;
                else over[1] = 0;
                if( ~v1_i[23] & (v2_i[23]) )over[2] = 1;
                else over[2] = 0;
                if( ~v1_i[31] & (v2_i[31]) )over[3] = 1;
                else over[3] = 0;

            end

            VDP: begin
                
                s1  = a1 * a2 ;
                s2  = a3 * a4 ;
                s3  = a5 * a6 ;
                s4  = a7 * a8 ;//16bits
             
                v_o = (s1+s2+s3+s4);

            end

            default: begin
                
                over[0] = 0;
                over[1] = 0;
                over[2] = 0;
                over[3] = 0;
                v_o = v1_i;
                
            end
            
        endcase
        
    end
    
endmodule
