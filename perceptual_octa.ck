// Create three triangle oscillators, each routed through a Gain, then to dac
TriOsc osc1 =>  dac;
TriOsc osc2 =>  dac;
TriOsc osc3 =>  dac;
TriOsc osc4 =>  dac;

// Set frequencies for C major triad

Std.mtof(60) => osc1.freq; // C4
Std.mtof(63) => osc2.freq; // E4
Std.mtof(66) => osc3.freq; // G4
Std.mtof(72) => osc4.freq; // G4

// Set initial amplitudes [0.9, 0.5, 0.5]
0.01 => osc1.gain;
0.4 => osc2.gain;
0.4 => osc3.gain;
0.5 => osc4.gain;

// Total modulation duration: 5 seconds
2::second => dur totalDur;

// Hold the soud for an extra second before ending
totalDur => now;
