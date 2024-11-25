module instructionDecoder(
    input clk,
    input rst,
    input i_flush, //external flush input
    input [31:0] i_instruction, // 32-bit i_instruction input
    input i_if_ready,
    output o_flush //internal flush output
);

// ID LOGIC //
reg [31:0] r_id_reg; //hold the instruction
reg r_id_ready = 0;
reg r_decode_fin = 0;
reg r_flush_sig = 0;
reg [1:0] r_decode_fin_delay = 2'b0;
reg [1:0] r_if_ready_delay = 2'b0;
reg [1:0] r_id_ready_delay = 2'b0;
reg r_fin_flag = 0;
reg r_decoded_ins_ready = 0;
reg [6:0] r_op_code;
reg [4:0] rd;        // Destination register (bits 11:7, for R/I-type)
reg [2:0] funct3;    // Function3 field (bits 14:12)
reg [4:0] rs1;       // Source register 1 (bits 19:15)
reg [4:0] rs2;       // Source register 2 (bits 24:20, for R/S-type)
reg [6:0] funct7;    // Function7 field (bits 31:25, for R-type)
reg [11:0] imm;       // Immediate value (12 bits, for I/S-type)
reg r_idex_reg_occupied;
reg r_idex_reg_occupied_pulse;
//ex
reg [6:0] r_ex_op_code;
reg [4:0] ex_rd;        // Destination register (bits 11:7, for R/I-type)
reg [2:0] ex_funct3;    // Function3 field (bits 14:12)
reg [4:0] ex_rs1;       // Source register 1 (bits 19:15)
reg [4:0] ex_rs2;       // Source register 2 (bits 24:20, for R/S-type)
reg [6:0] ex_funct7;    // Function7 field (bits 31:25, for R-type)
reg [11:0] ex_imm;       // Immediate value (12 bits, for I/S-type)

// hold
reg [6:0] r_ex_hold_op_code;
reg [4:0] ex_hold_rd;        // Destination register (bits 11:7, for R/I-type)
reg [2:0] ex_hold_funct3;    // Function3 field (bits 14:12)
reg [4:0] ex_hold_rs1;       // Source register 1 (bits 19:15)
reg [4:0] ex_hold_rs2;       // Source register 2 (bits 24:20, for R/S-type)
reg [6:0] ex_hold_funct7;    // Function7 field (bits 31:25, for R-type)
reg [11:0] ex_hold_imm;       // Immediate value (12 bits, for I/S-type)
reg DEBUG_FLAG = 0;
parameter IDLE_ID = 2'b00, 
          STORE = 2'b01,
          FLUSH = 2'b10;

reg [1:0] curr_id_state, next_id_state;

always @(posedge clk or negedge rst) begin
    if (!rst) curr_id_state <= IDLE_ID;
    else curr_id_state <= next_id_state;
end
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        r_decode_fin_delay <= 2'b0;
        r_if_ready_delay <= 2'b00;
    end
    else begin
        r_decode_fin_delay <= {r_decode_fin_delay[0], r_decode_fin};
        r_if_ready_delay <= {r_if_ready_delay[0], i_if_ready};
        r_id_ready_delay <= {r_id_ready_delay[0], r_id_ready};
    end
end
always @(*) begin
    next_id_state = curr_id_state;
    case (curr_id_state)
        IDLE_ID: begin
            if (r_if_ready_delay == 2'b01) next_id_state = STORE;
        end

        STORE: begin
            if (r_decode_fin_delay <= 2'b01) next_id_state = FLUSH;
        end

        FLUSH: begin
            next_id_state = IDLE_ID;
        end
    endcase
end

always @(posedge clk or negedge rst) begin 
    if (!rst) begin
        r_id_reg <= 32'b0;
        r_flush_sig <= 1'b0;
        r_decode_fin <= 1'b0;
    end else begin
        case (curr_id_state)
            IDLE_ID: begin
                r_flush_sig <= 1'b0; // Clear flush signal
                r_id_reg <= r_id_reg;
            end

            STORE: begin
                r_id_reg <= i_instruction; // Latch the instruction
                r_id_ready <= 1'b1;
            end

            FLUSH: begin
                r_id_reg <= r_id_reg;
                r_flush_sig <= 1'b1; // Signal a flush
                r_id_ready <= 1'b0;
                r_decode_fin <= 1'b0; // Reset decode finish flag here
                
            end
        endcase
    end
end

//decoder logic
parameter IDLE_DEC = 2'b00, 
          DECODE = 2'b01,
          PASS = 2'b10,
          DECODE_FIN = 2'b11;

reg [1:0] curr_dec_state, next_dec_state;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        curr_dec_state <= IDLE_DEC;
    end else begin
        curr_dec_state <= next_dec_state;
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        r_idex_reg_occupied_pulse <= 1'b0;
    end else begin
        r_idex_reg_occupied_pulse <= r_decoded_ins_ready && !r_idex_reg_occupied;
    end
end

always @(*) begin
    next_dec_state = curr_dec_state;
    case (curr_dec_state)
        IDLE_DEC: begin
           if (r_id_ready_delay == 2'b01) next_dec_state = DECODE;
        end

        DECODE: begin
            // decode in one clk cycle
            // instead of next clk cylce might have to do more register handshaking
            if (r_idex_reg_occupied_pulse) begin
                next_dec_state = PASS;
            end
            else begin
                next_dec_state = DECODE; // Stay in FETCH if condition not met
            end
        end
        
        PASS: begin
            next_dec_state = DECODE_FIN;
        end
        DECODE_FIN: begin
            next_dec_state = IDLE_DEC;
        end
    endcase
end



always @(posedge clk or negedge rst) begin 
    if (!rst) begin
        r_id_reg <= 32'b0;
        r_flush_sig <= 1'b0;
        r_decode_fin <= 1'b0;
        r_op_code <= 7'b0;
        rd     <= 0;  // Destination register
        rs2    <= 0;// Source register 2
        funct7 <= 0;// funct7
        imm    <= 0;    
    end else begin
        case (curr_dec_state)
            IDLE_DEC: begin
                r_op_code <= r_id_reg[6:0];
                funct3 <= r_id_reg[14:12];// funct3 (bits 14:12)
                rs1    <= r_id_reg[19:15];// rs1 (bits 19:15)
            end

            DECODE: begin
                r_op_code <= r_op_code;
                funct3 <= funct3;// funct3 (bits 14:12)
                rs1    <= rs1;// rs1 (bits 19:15)
                case (r_op_code)
                    7'b0110011: begin //r-type
                        rd     <= r_id_reg [11:7];
                        rs2 <= r_id_reg [24:20];
                        funct7 <= r_id_reg [31:25];
                        imm = 12'b0;
                    end

                    7'b0010011: begin //i-type
                        rd     <= r_id_reg[11:7];  // Destination register
                        imm    <= r_id_reg[31:20];// Immediate value (sign-extended)
                        rs2    <= 5'b0;               // No rs2 for I-type
                        funct7 <= 7'b0;               // No funct7 for I-type
                    end

                    7'b0000011: begin //i-type
                        rd     <= r_id_reg[11:7];  // Destination register
                        imm    <= r_id_reg[31:20];// Immediate value (sign-extended)
                        rs2    <= 5'b0;               // No rs2 for I-type
                        funct7 <= 7'b0;               // No funct7 for I-type
                    end

                    7'b0100011: begin //s-type
                        rd     <= 5'b0;               // No destination register for S-type
                        rs2    <= r_id_reg[24:20];// Source register 2
                        imm    <= {r_id_reg[31:25], r_id_reg[11:7]}; // Immediate value (split)
                        funct7 <= 7'b0;               // No funct7 for S-type
                    end

                endcase

                r_decoded_ins_ready <= 1'b1;
            end

            PASS: begin
                //pass the values to ID/EX pipeline by holding these values until
                r_ex_hold_op_code <= r_op_code;
                ex_hold_funct3 <= funct3;// funct3 (bits 14:12)
                ex_hold_rs1    <= rs1;// rs1 (bits 19:15)
                ex_hold_rd     <= rd;
                ex_hold_rs2 <= rs2;
                ex_hold_funct7 <= funct7;
                ex_hold_imm <= imm;
            end
            DECODE_FIN: begin
                r_decoded_ins_ready <= 1'b0;
                r_decode_fin <= 1'b1;
            end
        endcase
    end
end
//r_ex_hold_op_code
// ex_hold_rd
// ex_hold_funct3
// ex_hold_rs1
// ex_hold_rs2
// ex_hold_funct7
// ex_hold_imm

// ID/EX PIPELINE LOGIC //
parameter IDLE_ID_EX = 2'b00, 
          STORE_ID_EX = 2'b01;

reg [1:0] curr_idex_state, next_idex_state;

always @(posedge clk or negedge rst) begin
    if (!rst) curr_idex_state <= IDLE_ID_EX;
    else curr_idex_state <= next_idex_state;
end

always @(*) begin
    next_idex_state = curr_idex_state;
    case (curr_idex_state)
        IDLE_ID_EX: begin
            if (r_decoded_ins_ready == 1'b1) next_idex_state = STORE_ID_EX; //limit to 8 later
        end

        STORE_ID_EX: begin
            if (i_flush == 1'b1) next_idex_state = IDLE_ID_EX; //if ID in decoder module raises high signal
            // hold onto r_if_reg value til then
        end
    endcase
end

always @(posedge clk or negedge rst) begin 
    if (!rst) begin
        r_idex_reg_occupied <= 1'b0;
    end else begin
        case (curr_idex_state)
            IDLE_ID_EX: begin
                r_idex_reg_occupied <= 1'b0;
            end
            STORE_ID_EX: begin //make flush a handshake signal
                r_idex_reg_occupied <= 1'b1; // signal to the decoder that data is ready
                r_ex_op_code <= r_ex_hold_op_code;
                ex_funct3 <= ex_hold_funct3;// funct3 (bits 14:12)
                ex_rs1    <= ex_hold_rs1;// rs1 (bits 19:15)
                ex_rd     <= ex_hold_rd;
                ex_rs2 <= ex_hold_rs2;
                ex_funct7 <= ex_hold_funct7;
                ex_imm = ex_hold_imm;
            end
        endcase
    end
end

//r_ex_hold_op_code
// ex_hold_rd
// ex_hold_funct3
// ex_hold_rs1
// ex_hold_rs2
// ex_hold_funct7
// ex_hold_imm

assign o_flush = r_flush_sig;
endmodule
