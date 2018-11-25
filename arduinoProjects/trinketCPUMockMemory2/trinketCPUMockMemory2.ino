#define ENABLE 0
#define SERIAL_OUT 1
#define CLOCKPIN 2
#define TESTCLOCK 3

//replace this with 16bit hex values from somewhere.
//potentially an assembler/compiler...

const PROGMEM volatile int programLines[] = {
0x0006,
0x0001,
0x0005,
0x02f3,
0x0006,
0x0280,
0x0005,
0x02f4,
0x0006,
0x01e0,
0x0005,
0x02f5,
0x0006,
0x044c,
0x0003,
0x02f3,
0x0002,
0x0005,
0x02f6,
0x0014,
0x02f6,
0x000b,
0x02f6,
0x000e,
0x0009,
0x011f,
0x0006,
0x0000,
0x0013,
0x02f6,
0x0007,
0x0123,
0x0001,
0x02f6,
0x0013,
0x02f6,
0x0001,
0x02f6,
0x000c,
0xfde8,
0x000e,
0x0009,
0x010d,
0x0007,
0x010b,
  };
const volatile int len = (sizeof(programLines)/sizeof(int));
volatile int index = 0;
//start at MSB
volatile int subindex = 0;

// the setup routine runs once when you press reset:
void setup() {
  // initialize the LED pin as an output.
  pinMode(SERIAL_OUT, OUTPUT);
  pinMode(CLOCKPIN, INPUT);
  pinMode(ENABLE, INPUT_PULLUP);
  pinMode(TESTCLOCK, OUTPUT);

  attachInterrupt(digitalPinToInterrupt(CLOCKPIN), onClock, RISING);

}

void onClock() {


  bool notEnabled = digitalRead(ENABLE);

  if(notEnabled == true){
    index = 0;
    subindex = 0;
  }
  
  //if the enable line is low  - then we can keep outputting data.
  if (notEnabled == false)
  { 
    //reset index if we overflow
    if(index == len){
      index = 0;
    }
    
    //reset subIndex when it reachs 0
    //so we can shift out the next lines data
    if(subindex == 16){
      subindex = 0;
      index = index + 1;
    }

    //first get the current word;
    int LOC =   pgm_read_word_near(programLines + index);
    //next get the current bit
    int dataBit = bitRead(LOC,subindex);
    subindex = subindex + 1;
    digitalWrite(SERIAL_OUT,dataBit);
  }
}

// the loop routine runs over and over again forever:
void loop() {

  
}
