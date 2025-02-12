// Base frequency
440.0 => float fundamental; 

// Number of harmonics to start with
20 => int harmonics; 

// Gain control
0.3 => float baseGain;

// Function to generate a static square wave approximation
fun void baseline() {
    SinOsc sines[harmonics];

    int i;
    while (i < harmonics) {
        (2 * i + 1) => int harmonic;
        sines[i] => dac;
        sines[i].freq(fundamental * harmonic);
        sines[i].gain(baseGain / harmonic);
        i++;
    }

    // Hold the sound for 5 seconds
    5::second => now;
}

// Function to gradually remove harmonics over time
fun void experiment() {
    1=>int stepSize; // Step size for skipping harmonics
    harmonics => int currentHarmonics; // Start with full set

    while (currentHarmonics > 1) {
        stepSize + 3 => stepSize; // Increase step size every second

        // Array for sine wave oscillators
        SinOsc sines[currentHarmonics];

        currentHarmonics - 1 => int i; // Start from the last harmonic
        currentHarmonics-1 => int  index;
        while (i >= 0) {
            (2 * i + 1) => int harmonic;
            if (harmonic > 1) { // Ensure at least one harmonic remains
                sines[i] => dac;
                sines[i].freq(fundamental * harmonic);
                sines[i].gain(baseGain / harmonic);
            }
            i--;
            index - stepSize => index; // Increase skipping factor
        }

        // Play for 1 second
        1::second => now;

        // Reduce the number of harmonics
        currentHarmonics -1 => currentHarmonics;
    }

    // Hold final tone for 2 seconds before stopping
    2::second => now;
}

// Run the functions (Uncomment one at a time to test)
// baseline();
experiment();
