// --- Sine Tone Generator with ADSR Envelope ---
fun void playToneWithADSR( float toneDuration, float freq )
{
    // Split toneDuration equally between tone (active) and silence.
    toneDuration * 0.5 => float activeTime;
    toneDuration * 0.5 => float silenceTime;
    
    // Set up a sine oscillator, envelope, and connect to dac.
    SinOsc s => ADSR env => dac;
    0.5 => env.gain;
    freq => s.freq;
    
    // Calculate envelope timing parameters (using portions of activeTime).
    (0.1 * activeTime)::second => dur decayTime;
    (0.2 * activeTime)::second => dur releaseTime;
    
    0::second   => env.attackTime;
    decayTime   => env.decayTime;
    releaseTime => env.releaseTime;
    1           => env.sustainLevel;
    
    // Trigger the envelope: key on, then key off after a short time.
    env.keyOn();
    releaseTime => now;
    env.keyOff();
    releaseTime => now;
    silenceTime::second => now;
}

fun float hzToMel( float freq )
{
    // Standard conversion: mel = 2595 * log10(1 + f/700)
    return 2595.0 * ( Math.log( 1.0 + freq / 700.0 ) / Math.log( 10.0 ) );
}

// --- Function to Play Two Frequencies in Hertz ---
// This function plays the first frequency then, after a 0.5-second gap, plays the second.
fun void playTwoFrequenciesHz( float f1, float f2, float toneDuration )
{   
    hzToMel(f1) => float mel1;
    hzToMel(f2) => float mel2;

    <<< "Playing", f1, "Hz", mel1,"mels" >>>;
    playToneWithADSR( toneDuration, f1 );
    0.5::second => now;
    
    <<< "Playing", f2, "Hz", mel2,"mels" >>>;
    playToneWithADSR( toneDuration, f2 );
}

// --- Helper Function to Convert Mel to Hertz ---
// The standard conversion from mel to Hz is: f = 700 * (10^(mel/2595) - 1)
fun float melToHz( float mel )
{
    return 700.0 * ( Math.pow( 10, mel / 2595.0 ) - 1 );
}

// --- Function to Play Two Frequencies Given in the Mel Scale ---
// This function converts each mel value to Hertz, then plays them with a 0.5-second gap.
fun void playTwoFrequenciesMel( float mel1, float mel2, float toneDuration )
{
    // Convert mel values to Hertz.
    melToHz( mel1 ) => float f1;
    melToHz( mel2 ) => float f2;
    
    <<< "Playing", mel1, "mels (", f1, "Hz)" >>>;
    playToneWithADSR( toneDuration, f1 );
    0.5::second => now;
    
    <<< "Playing", mel2, "mels (", f2, "Hz)" >>>;
    playToneWithADSR( toneDuration, f2 );
}

// --- Main Script ---
// Example: Playing two frequencies given in Hertz.
// <<< "=== Playing Tones in Hertz ===" >>>;
playTwoFrequenciesHz( 400, 500, 1.0 );
3::second => now;
playTwoFrequenciesHz( 4000, 4100, 1.0 );
3::second => now;


// <<< "=== Playing Tones in Mel Scale ===" >>>;
// playTwoFrequenciesMel( 600.0, 700.0, 1.0 );
playTwoFrequenciesMel( 400, 500, 1.0 );
3::second => now;
playTwoFrequenciesMel( 2200, 2300, 1.0 );
