/*      This code is a simplified IDS. It does a single comparison over each 64 bit chunk of
 *      packets rather than scanning byte by byte over it. It would still detect pattern in
 *      a packet containing a 64 bit payload matching the pattern. .
 *      Unfortunately it does rely on some integration of ways to interface the fifo and 
 *      a way to output data back into the user data path. 
*/

// Register a0 has address 10 in the reg file
int fifo_read(); // Read data from the fifo into register a0
int fifo_ctrl(); // Read control data from the fifo into reg a0
void output_packet_fragment(int data); // Sends 8 bytes of data from a0 to output to user data path

int main(){
    //int data1, data2;
    int flag = 0;
    int buffer[100]; // output buffer
    int i; // buffer pointer
    int pattern = 7;
    
    while(1){ // loop forever
        if(fifo_ctrl() != 0){ // Packet start
            i = 0; // Reset buffer pointer for new packet
            buffer[i] = fifo_read(); // store packet header in output buffer, reading from FIFO
            i++;
            while(fifo_ctrl() == 0){ // Iterate through the packet
                if(buffer[i] == pattern){ flag = 1; }
                buffer[i] = fifo_read(); // Store in output buffer
                i++;
            }
            if (buffer[i] == pattern){ flag = 1; } // Check last packet piece
            buffer[i] = fifo_read(); // Store final packet piece in output buffer
            i++;
            
            if(!flag){ // If the pattern was not detected, output packet to continue routing. 
                for(int j = 0; j < i; j++){output_packet_fragment(buffer[j]); } // Output packet
            }
        } //endif, packet terminated, continue polling
    }
}

