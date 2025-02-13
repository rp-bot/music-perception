fun void whiteNoiseBackground(float gain, dur releaseTime) {
    Noise n => dac;
    // Adjust the gain to set how "loud" the white noise is.
    gain => n.gain;
    
    releaseTime => now;
  
}
fun void playToneWithADSR(float toneDuration, float freq) {
    toneDuration * 0.75 => float activeTime;
    toneDuration * 0.25 => float silenceTime;
    
    (0.6 * activeTime)::second => dur noiseDuration;

    SinOsc s => ADSR env => dac;

    0.5 => env.gain;
    freq => s.freq;
    
    (0.1 * activeTime):: second => dur decayTime;
    (0.2 * activeTime):: second => dur releaseTime;
    
    0:: second  => env.attackTime;
    decayTime   => env.decayTime;
    releaseTime => env.releaseTime;
    1         => env.sustainLevel;
    
    env.keyOn();
    // [0.05, 0.002, 0.006, 0.02, 0.007, 0.002]
    spork ~ whiteNoiseBackground(0.002, noiseDuration);
    // Hold through the sound phase
    releaseTime => now;
    env.keyOff();
    // Let the release phase finish
    releaseTime => now;
    // Pause for the silence period
    silenceTime :: second => now;



}

// Twinkle Twinkle Little Star:
[ 60, 60, 67, 67, 69, 69, 67, 
  65, 65, 64, 64, 62, 62, 60, 
  67, 67, 65, 65, 64, 64, 62, 
  60, 60, 67, 67, 69, 69, 67,
  65, 65, 64, 64, 62, 62, 60,] @=> int notes[];

float toneDuration;

for (0 => int i; i < notes.cap(); i++) {
    Std.mtof( notes[i] ) => float freq;
    if (i%7==6){
        1 =>  toneDuration;
    }else{
        0.5 =>  toneDuration;
    }
    playToneWithADSR( toneDuration, freq );
}
