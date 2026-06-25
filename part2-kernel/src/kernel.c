#define VIDEO_MEMORY (char*)0xB8000
#define WHITE_ON_BLACK 0x0F

void print(const char* str) {
    char* video = VIDEO_MEMORY;
    int i = 0;
    while (str[i] != '\0') {
        video[i * 2]     = str[i];
        video[i * 2 + 1] = WHITE_ON_BLACK;
        i++;
    }
}

void kernel_main() {
    print("Kernel Estudiante: Cristopher Quisilema - UIDE 2026");
}
