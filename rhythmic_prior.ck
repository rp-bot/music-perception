fun void playToneWithADSR(float toneDuration, float freq) {
    toneDuration * 0.5 => float activeTime;
    toneDuration * 0.5 => float silenceTime;
    
    SinOsc s => ADSR env => dac;
    0.5 => env.gain;
    freq => s.freq;
    
    // 0.1 * activeTime => float attackSec;
    (0.1 * activeTime):: second => dur decayTime;
    (0.2 * activeTime):: second => dur releaseTime;
    
    // attackSec :: second => dur attackTime;
    
    // Assign ADSR parameters
    0:: second  => env.attackTime;
    decayTime   => env.decayTime;
    releaseTime => env.releaseTime;
    1         => env.sustainLevel;
    
    // Start the envelope.
    env.keyOn();
    // Advance time: from the start of ATTACK to just before RELEASE.
    releaseTime => now;
    // Trigger the release phase.
    env.keyOff();
    // Let the RELEASE phase complete.
    releaseTime => now;
    // Then wait through the silence period.
    silenceTime :: second => now;
}


fun void playSequence(float totalTime, float r1, float r2, float r3)
{
    (r1 + r2 + r3) => float totalRatio;
    totalTime * (r1 / totalRatio) => float t1;
    totalTime * (r2 / totalRatio) => float t2;
    totalTime * (r3 / totalRatio) => float t3;
    
    playToneWithADSR(t1, 440);
    playToneWithADSR(t2, 440);
    playToneWithADSR(t3, 440);

}

2.0 => float totalTime;  


2 => float r1;         
1 => float r2;         
2.0 => float r3;         


for(0 => int i; i < 10; i++){
    playSequence(totalTime, r1, r2, r3);
}