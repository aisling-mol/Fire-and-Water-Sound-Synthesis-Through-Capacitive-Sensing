// Cloned from https://github.com/madlabdk/touche


// Number of frequency steps to scan through
#define steps 128

float values[steps];  		    // Array to store smoothed analog values per step
float alpha;          		    // Smoothing factor for exponential moving average
int maxPos, maxVal;   		    // Variables to store position and value of the signal peak

void setup ()
{
  pinMode(9, OUTPUT);  		    // Set digital pin 9 as output (used with Timer1 OC1A)
  
  // Configure Timer1 registers
  TCCR1A = 0;  			          // Clear Timer/Counter Control Register A
  TCCR1B = 0;  			          // Clear Timer/Counter Control Register B
  TCCR1A |= (1 << COM1A0);  	// Toggle OC1A (pin 9) on Compare Match
  TCCR1B |= (1 << WGM12);   	// Set CTC (Clear Timer on Compare Match) mode

  Serial.begin(9600);  		    // Initialize serial communication at 9600 baud
}

void loop () {
  // If serial input is available, use it to update alpha (smoothing factor)
  if (Serial.available()) {
    // Normalize serial input (0–255) to range 0.0–1.0
    alpha = (float)Serial.read() / 255.0f;
  }

  maxPos = 0;  			          // Reset peak position
  maxVal = 0;  			          // Reset peak value

  for (int i = 0; i < steps; i++) {
    TCCR1B &= 0xFE;       	  // Disable Timer1 by clearing the clock select bits
    TCNT1 = 0;            	  // Reset Timer1 counter
    OCR1A = i;            	  // Set compare match value to control output frequency
    TCCR1B |= 0x01;       	  // Enable Timer1 with no prescaling (full speed)

    float curVal = analogRead(0);  // Read analog value from pin A0

    // Apply exponential moving average to smooth readings
    values[i] = values[i] * alpha + curVal * (1 - alpha);

    // Track the highest value and its index
    if (values[i] > maxVal) {
      maxVal = values[i];
      maxPos = i;
    }
  }

  // Send peak position and value over serial
  Serial.print(maxPos, DEC);
  Serial.print(" ");
  Serial.println(maxVal, DEC);

  delay(200);  			// Small delay before next scan cycle
}