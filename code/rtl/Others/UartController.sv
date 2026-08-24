module UartController (
    input  logic clk,
    input  logic rst_n,

    // UartRx
    input  logic [7:0] rx_data,
    input  logic rx_ready,
    
    output logic sync_en_out,
    output logic [4:0] sync_hours_out,
    output logic [5:0] sync_minutes_out,
    output logic [7:0] rx_train_id,
    output logic rx_train_req,

    // UartTx
    output logic tx_start,
    output logic [7:0] tx_data,
    input  logic tx_busy,

    
    input  logic send_time_req,
    input  logic [4:0] current_hours,
    input  logic [5:0] current_minutes,
    
    input  logic send_train_req,
    input  logic [7:0] tx_train_id_in
);

    // ==========================================
    // RX FSM
    // ==========================================
    typedef enum logic [1:0] {RX_IDLE, RX_WAIT_HOUR, RX_WAIT_MIN} rx_state_t;
    rx_state_t rx_state;
    logic [4:0] rx_hours_buf;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_state <= RX_IDLE;
            rx_hours_buf <= 0;
            sync_en_out <= 0;
            rx_train_req <= 0;
        end else begin
            sync_en_out <= 0;
            rx_train_req <= 0;

            if (rx_ready) begin
                case (rx_state)
                    RX_IDLE: begin
                        if (rx_data == 8'hFF) begin 
                            rx_state <= RX_WAIT_HOUR;
                        end else begin            
                            rx_train_id <= rx_data;
                            rx_train_req <= 1'b1;
                        end
                    end
                    RX_WAIT_HOUR: begin
                        rx_hours_buf <= rx_data[4:0];
                        rx_state <= RX_WAIT_MIN;
                    end
                    RX_WAIT_MIN: begin
                        sync_hours_out <= rx_hours_buf;
                        sync_minutes_out <= rx_data[5:0];
                        sync_en_out <= 1'b1; 
                        rx_state <= RX_IDLE;
                    end
                endcase
            end
        end
    end

    // ==========================================
    // TX FSM
    // ==========================================
    typedef enum logic [2:0] {TX_IDLE, TX_SYNC_HEADER, TX_SYNC_HOUR, TX_SYNC_MIN, TX_TRAIN} tx_state_t;
    tx_state_t tx_state;


    logic [4:0] tx_hours_buf;
    logic [5:0] tx_minutes_buf;
    logic [7:0] tx_train_buf;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_state <= TX_IDLE;
            tx_start <= 0;
        end else begin
            tx_start <= 0; 
            case (tx_state)
                TX_IDLE: begin
                    if (send_time_req && !tx_busy) begin
                        tx_hours_buf <= current_hours;
                        tx_minutes_buf <= current_minutes;
                        tx_data <= 8'hFF; 
                        tx_start <= 1'b1;
                        tx_state <= TX_SYNC_HEADER;
                    end 
                    else if (send_train_req && !tx_busy) begin
                        tx_train_buf <= tx_train_id_in;
                        tx_data <= tx_train_id_in;
                        tx_start <= 1'b1;
                        tx_state <= TX_TRAIN;
                    end
                end
                
                TX_SYNC_HEADER: begin
                    if (!tx_busy && !tx_start) begin
                        tx_data <= {3'b0, tx_hours_buf};
                        tx_start <= 1'b1;
                        tx_state <= TX_SYNC_HOUR;
                    end
                end
                
                TX_SYNC_HOUR: begin
                    if (!tx_busy && !tx_start) begin
                        tx_data <= {2'b0, tx_minutes_buf};
                        tx_start <= 1'b1;
                        tx_state <= TX_SYNC_MIN;
                    end
                end
                
                TX_SYNC_MIN: begin
                    if (!tx_busy && !tx_start) tx_state <= TX_IDLE;
                end
                
                TX_TRAIN: begin
                    if (!tx_busy && !tx_start) tx_state <= TX_IDLE;
                end
            endcase
        end
    end
endmodule