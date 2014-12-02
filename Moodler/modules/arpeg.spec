double result;
int pc;
int np;
const char *last_pattern;
double last_trigger;
double playing;
double gate;
double note[12];
int count_stack[12];
int count_stack_address[12];
int count_stack_pointer;
int chord_offset;
double note_offset;

void init() {
    pc = 0;
    last_pattern = 0;
    last_trigger = 0;
    playing = 0.0;
    chord_offset = 0;
}

void exec(in __attribute__((normal("abc"))) __attribute__((colour("(0, 0, 1)"))) const char *pattern,
          in control trigger,
          in control note1,
          in __attribute__((normal(-100.0))) control note2,
          in __attribute__((normal(-100.0))) control note3,
          out control result,
          out control gate) {
    /*printf("Hello1\n");*/
    const char *pattern2 = pattern;
    if (pattern2 != last_pattern) {
        pc = 0;
        count_stack_pointer = 0;
        chord_offset = 0;
        note_offset = 0.0;
    }

    np = 0;
    for (double octave = 0; np < 7; octave += 0.1) {
        note[np++] = note1+octave;
        if (note2 > -100.0) {
            note[np++] = note1+note2+octave;
        }
        if (note3 > -100.0) {
            note[np++] = note1+note3+octave;
        }
    }
#if 0
    printf("%f %f %f\n", note1, note2, note3);
    for (int i = 0; i < 12; ++i) {
        printf("%d: %f\n", i, note[i]);
    }
#endif

    /*printf("Hello2\n");*/
    if (pattern2) {
        /*printf("!!!!!!! %s %d\n", pattern2, pc);*/
        int done = 0;
        if (last_trigger <= 0 && trigger > 0) {
            /*printf("Hello3\n");*/
            while (!done) {
                if (pattern2[pc] >= '0' && pattern2[pc] <= '9') {
                    count_stack[count_stack_pointer] = pattern2[pc]-'0';;
                } else
                switch (pattern2[pc]) {
                case '(':
                    count_stack_address[count_stack_pointer] = pc;
                    ++count_stack_pointer;
                    break;
                case ')':
                    if (--count_stack[count_stack_pointer-1] <= 0) {
                        --count_stack_pointer;
                    } else {
                        pc = count_stack_address[count_stack_pointer-1];
                    }
                    break;
                case 'a':
                    result = note[chord_offset]+note_offset;
                    playing = 1.0;
                    done = 1;
                    break;
                case 'b':
                    result = note[chord_offset+1]+note_offset;
                    playing = 1.0;
                    done = 1;
                    break;
                case 'c':
                    result = note[chord_offset+2]+note_offset;
                    playing = 1.0;
                    done = 1;
                    break;
                case 'd':
                    result = note[chord_offset+3]+note_offset;
                    playing = 1.0;
                    done = 1;
                    break;
                case 'e':
                    result = note[chord_offset+4]+note_offset;
                    playing = 1.0;
                    done = 1;
                    break;
                case 'f':
                    result = note[chord_offset+5]+note_offset;
                    playing = 1.0;
                    done = 1;
                    break;
                case 'g':
                    result = note[chord_offset+6]+note_offset;
                    playing = 1.0;
                    done = 1;
                    break;
                case '+':
                    ++chord_offset;
                    break;
                case '-':
                    --chord_offset;
                    break;
                case '/':
                    note_offset += 0.1/12.0;
                    break;
                case '\\':
                    note_offset -= 0.1/12.0;
                    break;
                case '.':
                    playing = 0.0;
                    done = 1;
                    break;
                }
                /*printf("Hello3.5\n");*/

                if (pattern2[pc] == 0) {
                    pc = 0;
                    chord_offset = 0;
                    count_stack_pointer = 0;
                    note_offset = 0.0;
                } else {
                    ++pc;
                }
            }
        }
    }
    /*printf("Hello4\n");*/
    last_trigger = trigger;
    last_pattern = pattern2;
    /*printf("Bye\n");*/
    gate = trigger*playing;
}
