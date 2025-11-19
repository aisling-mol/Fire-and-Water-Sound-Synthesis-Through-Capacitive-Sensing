//******************************************************************
// 
// This is an interactive instrument based on capacitive sensing circuitry,
// You're enjoying an evening campfire in the woods, use the mug to create some ambience,
// but beware of things lurking in the forest or the WATER...
//
// Set up the Arduino, placing the object end in a nearly full mug of water, and try 
// touching the mug, wrapping fingers around it, or try dip a finger into the mug*
//
// *When touching the water, touch the grounded laptop for best results
//  Dipping a finger in triggers the lurking mysteries.
//
// Run as: chuck fireandwaterfinal.ck: [serialport]
//
//******************************************************************



// ==== Serial Port Setup ====

SerialIO.list() @=> string list[]; // List available serial ports

// Print list of serial ports to terminal
for(int i; i < list.cap(); i++) {
    chout <= i <= ": " <= list[i] <= IO.newline();
}

// Default to first port unless one is provided
0 => int device;
if(me.args()) {
    me.arg(0) => Std.atoi => device;
}

// Exit if device number is out of bounds
if(device >= list.cap()) {
    cherr <= "serial device #" <= device <= " not available\n";
    me.exit(); 
}

// Open serial connection to Arduino
SerialIO cereal;
if(!cereal.open(device, SerialIO.B9600, SerialIO.ASCII)) {
    chout <= "unable to open serial device '" <= list[device] <= "'\n";
    me.exit();
}



// ==== Class Instances ====

Mug muggy;     // creates melodic chime sounds
Fire fire;     // handles campfire loop and disturbances



// ==== Main Loop ====

while(true)
{
    cereal.onLine() => now;               // wait for new serial line
    cereal.getLine() => string line;      // read serial input
    if(line$Object != null) {
        StringTokenizer tok;
        tok.set(line);
        Std.atoi(tok.next()) => int pos;  // note index (0–127)
        Std.atoi(tok.next()) => int val;  // amplitude (0–1023)

        muggy.play(pos, val);             // generate chime sound
        fire.play(pos);                   // modulate fire & check for disturbance

        chout <= "pos: " <= pos <= " val: " <= val <= IO.newline();
    }
}



// ==== Fire Class ====

class Fire {
    string fireFile;
    me.sourceDir() + "/firecrackleloop.wav" => fireFile;
    me.sourceDir() + "/disturbance.wav" => string disturbanceFile;
    SndBuf fireBuf => Gain fireGain => dac;

    // Set up looping fire audio
    fireFile => fireBuf.read;
    0.5 => fireBuf.gain;
    1.0 => fireBuf.rate;
    true => fireBuf.loop;
    fireGain.gain(1.0);

    0 => int lastVal;
    70 => int loudThresh;
    5 => int lowThresh;

    // Called each frame with new val (intensity)
    fun void play(int val) {
        if (somethingAroundUs(val)) {
            spork~ playDisturbance(); // trigger async thunder/water sound
            chout <= "Sporked Disturbance" <= IO.newline();
        }

        // Update fire volume based on sensor intensity
        normalize(val) => float volume;
        chout <= "fire volume: " <= volume <= IO.newline();
        volume => fireBuf.gain;
        val => lastVal;
    }

    // Normalize sensor value to 0–1
    fun float normalize(int val) {
        40.0 => float highVal;
        20.0 => float lowVal;

        if (val > highVal) return 1.0;
        else return (val - lowVal) / (highVal - lowVal);
    }

    // Determine if a sudden change just happened
    fun int somethingAroundUs(int val) {
        if ((val > loudThresh || val < lowThresh) &&
            !(lastVal > loudThresh || lastVal < lowThresh)) {
            return true;
        }
        else return false;
    }

    // Play a random disturbance sound (e.g. thunder)
    fun void playDisturbance() {
        Math.random2(1,3) => int randPick;
        me.sourceDir() + "/disturbance" + randPick + ".wav" => string disturbanceFile;
        SndBuf buf  => dac;
        disturbanceFile => buf.read;
        1.0 => buf.rate;
        0.8 => buf.gain;
        buf.length() => now;
        chout <= "It's Gone... for now";
    }
}

// ==== Mug Class ====

class Mug {

    SinOsc c;                // primary tone oscillator
    ADSR env;                // envelope for note shaping
    PRCRev reverb;           // reverb effect
    Gain g;                  // output gain

    c => env => reverb => g => dac;
    g.gain(1);
    env.set(10::ms, 200::ms, 0.5, 100::ms); // attack, decay, sustain, release

    0 => int lastMidi;

    // Map pos (0–127) to MIDI note range 60–90 (chime tones)
    fun int mapToMidi(int pos) {
        return ((pos / 127.0) * 30.0 + 60.0) $ int;
    }

    // Called with each new input pair
    fun void play(int pos, int val) {
        // Ignore weak signals or low positions (fuzzy hands)
        if (val < 10 || pos < 25.5) {
            env.keyOff();
            return;
        }

        mapToMidi(pos) => int midiVal;

        // Only re-trigger if note changed
        if (Math.abs(midiVal - lastMidi) > 1) {
            env.keyOff();
            10::ms => now;
            env.keyOn();
        }

        // Set oscillator frequency and dynamic volume
        Std.mtof(midiVal) => c.freq;
        (val / 1023.0) * 0.8 => g.gain;
        midiVal => lastMidi;

        chout <= "Pos: " <= pos <= ", Val: " <= val <= ", MIDI: " <= midiVal <= ", Freq: " <= c.freq() <= IO.newline();
    }
}



