/* kernel.c - The Heart of Asrbuntu (GRUB/32-bit Edition) */

// Screen constants
#define VIDEO_ADDRESS 0xB8000
#define MAX_ROWS 25
#define MAX_COLS 80

// Attribute colors (Background << 4 | Foreground)
#define WHITE_ON_BLACK 0x0F
#define CYAN_ON_BLACK  0x0B
#define RED_ON_BLACK   0x0C

// Function Prototypes
void kprint(char* message, unsigned char color);
void clear_screen();
void kprint_at(char* message, unsigned char color, int col, int row);

void kmain() {
    // 1. Clean the mess left by GRUB
    clear_screen();

    // 2. Display our welcome message
    kprint("------------------------------------------\n", WHITE_ON_BLACK);
    kprint("      ASRBUNTU OS - KERNEL v2.0 (C)       \n", CYAN_ON_BLACK);
    kprint("------------------------------------------\n", WHITE_ON_BLACK);
    
    kprint("\nStatus: Booted via GRUB into 32-bit mode.\n", WHITE_ON_BLACK);
    kprint("Memory: Video mapping at 0xB8000 active.\n", WHITE_ON_BLACK);
    
    kprint("\nWelcome, Programmer. The system is ready.\n", CYAN_ON_BLACK);
}

/* --- HELPERS --- */

// Clears the entire text buffer
void clear_screen() {
    volatile char* vga = (volatile char*)VIDEO_ADDRESS;
    for (int i = 0; i < MAX_ROWS * MAX_COLS * 2; i += 2) {
        vga[i] = ' ';         // Space character
        vga[i+1] = WHITE_ON_BLACK; 
    }
}

// Simple print function that handles newlines
int cursor_pos = 0;
void kprint(char* message, unsigned char color) {
    volatile char* vga = (volatile char*)VIDEO_ADDRESS;
    int i = 0;
    
    while (message[i] != 0) {
        // Handle newline character
        if (message[i] == '\n') {
            // Move cursor to the start of the next line
            cursor_pos = (cursor_pos / (MAX_COLS * 2) + 1) * (MAX_COLS * 2);
        } else {
            vga[cursor_pos] = message[i];
            vga[cursor_pos + 1] = color;
            cursor_pos += 2;
        }
        i++;
    }
}

// Print at a specific X, Y coordinate
void kprint_at(char* message, unsigned char color, int col, int row) {
    cursor_pos = (row * MAX_COLS + col) * 2;
    kprint(message, color);
}
