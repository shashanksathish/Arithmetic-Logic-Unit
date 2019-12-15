module alu(

           input [15:0]       Input1, Input2 , /* ALU 8-bit Inputs  */               

           input [3:0]       opcode,                 /* ALU Selection */

           output [31:0]     Output,           /* ALU Output */

           output      carryflag,                   /* Carry Out Flag */

           input    clk

    );

    reg [31:0] ALU_Result;

    reg [16:0] a,b,c,Q;

    reg [15:0] temp;

    reg previous,J,K,T, carry;

    reg [32:0] product;

    integer i;

   /*Opcode definition*/   

    localparam   ADD        = 4'b0000,    

            MULTIPLY        = 4'b0001,

            GREATER_THAN    = 4'b0010,

            EQUAL           = 4'b0011,

            SUB             = 4'b0100,

            D_FF            = 4'b0101,

            JK_FF           = 4'b0110,

            T_FF            = 4'b0111,

            DIVIDE          = 4'b1000,

            AND             = 4'b1001,

            OR              = 4'b1010,

            NOR             = 4'b1011,

            XOR             = 4'b1100,

            NAND            = 4'b1101,

            XNOR            = 4'b1110,

            NOT             = 4'b1111;

    assign Output = ALU_Result;         /* ALU output */

    assign carryflag = carry;            /* Carryout flag */

    always @(posedge clk)

    begin

      carry = 0;

        case(opcode)

            ADD: //ALU_Result = Input1 + Input2;   /* Addition */

                  /*Carry look ahead adder*/

                  begin

                  ALU_Result=0;

                  for(i=0;i<16;i=i+1)

                        begin

                        c[0] =0;

                        b[i]=Input1[i]&Input2[i];

                        a[i]=Input1[i]^Input2[i];

                        c[i+1]=b[i]|(a[i]&c[i]);

                        ALU_Result[i]=Input1[i]^Input2[i]^c[i];                        

                        end

                  carry=c[16];

                  end

            MULTIPLY:  
	begin

            ALU_Result = 0;
            
        for(i=0; i<16; i=i+1)
	begin
          if( Input1[i] == 1'b1 ) ALU_Result = ALU_Result + ( Input2 << i );
  	end
	end
     

                 

            GREATER_THAN:    ALU_Result = (Input1>Input2)?0:1;                                     //ALU_Result = 0, if Input1>Input2

                 

            EQUAL:      ALU_Result = (Input1==Input2)?1:0;                                  //ALU_Result = 1, if Input1==Input2

                 

           SUB:        

                begin

		ALU_Result = Input1 - Input2; //Subtraction

		carry = ALU_Result[16];

		end

            D_FF: //D Flip Flop

                  begin

                  ALU_Result=0;

                  previous =0;

                  for(i=0; i<16; i=i+1)

                        begin

            //Characteristic equation derived from K map of D Flip Flop

                  Q[i]=(Input1[i]);

                              ALU_Result[i]=Q[i];

                              previous=Q[i];                          

                        end        

                  end

            JK_FF://JK Flip Flop

                  begin

                  previous = 0;

                  for(i=0; i<16;i=i+1)

                  begin

                  J=Input1[i] ;

                  K=Input2[i];

                        begin

            //Characteristic equation derived from K map of JK Flip Flop

            Q[i] = (J&(~previous))|((~K)&previous); 

                              ALU_Result[i] = Q[i];

                              previous = Q[i];

                        end        

                  end

                  end

                 

            T_FF ://T flip flop

                  begin

                  previous = 0;

                  for(i=0;i<16;i=i+1)

                  begin

                  T = Input1[i];                    

                        begin

            //Characteristic equation derived from K map of T Flip Flop

            Q[i] = (T&(~previous))|((~T)&previous);

                              ALU_Result[i] = Q[i];

                              previous = Q[i];                        

	                        end

                  end

                  end

            DIVIDE: //Buffer

                  begin

                        ALU_Result=Input1/Input2;

                  end

            /* Logical Operations*/

            AND:// AND Gate

                  begin

                        for(i=0;i<16;i=i+1)

                        ALU_Result[i]= Input1[i]& Input2[i];

                  end 

    

            OR://OR Gate

                  begin

                        for(i=0;i<16;i=i+1)

                        ALU_Result[i]= Input1[i]| Input2[i];

                  end

            NOR://NOR Gate

                  begin

                        for(i=0;i<16;i=i+1)

                        ALU_Result[i]= ~(Input1[i]| Input2[i]);

                  end

            XOR://XOR Gate

                  begin

                        for(i=0;i<16;i=i+1)

                        ALU_Result[i]= Input1[i]^Input2[i];

                  end

            NAND://NAND Gate

                  begin

                        for(i=0;i<16;i=i+1)

                        ALU_Result[i]= ~(Input1[i]& Input2[i]);

                  end

            XOR:// XNOR Gate

                  begin

                        for(i=0;i<16;i=i+1)

                        ALU_Result[i]= Input1[i]~^Input2[i];

                  end

            NOT://NOT Gate

                  begin

                        for(i=0;i<16;i=i+1)

                        ALU_Result[i]= ~Input1[i];

                  end

            default:    ALU_Result = 0;        /* Default Test case */

        endcase

    end

endmodule
