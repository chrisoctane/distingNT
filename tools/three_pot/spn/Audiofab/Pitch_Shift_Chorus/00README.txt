Pitch Shifters + Chorus on the FV-1
-----------------------------------

These patches are (c) 2024 Audiofab and are free for non-commercial use.

The SpinCAD Designer source file is provided as well as an fv1-programmer .json file (so you can directly program your pedal with fv1-programmer).

This zip archive contains eight algorithms that use chorus alone, pitch shifting and chorus, or pitch shifting and flanging:

Patch 1: Chorus with feedback
- Pot 0: Speed
- Pot 1: Depth
- Pot 2: Feedback

Patch 2: Multi-voice Chorus with feedback
- Pot 0: Speed
- Pot 1: Depth
- Pot 2: Feedback

Patch 3: Octave up-down with Chorus
- Pot 0: Speed
- Pot 1: Depth
- Pot 2: Octave up-down level (combined)

Patch 4: Octave up-down with Chorus
- Pot 0: Chorus Speed
- Pot 1: Octave up level
- Pot 2: Octave down level

Patch 5: Third and Fifth with Chorus
- Pot 0: Chorus Speed
- Pot 1: Third above level
- Pot 2: Fifth above level

Patch 6: Fourth and Fifth with Chorus
- Pot 0: Chorus Speed
- Pot 1: Fourth above level
- Pot 2: Fifth above level

Patch 7: Octave up-down with Multi-voice Chorus
- Pot 0: Chorus Speed
- Pot 1: Octave up level
- Pot 2: Octave down level

Patch 8: Octave up-down with Flanger
- Pot 0: Flanger Speed
- Pot 1: Octave up level
- Pot 2: Octave down level

Pitch shifting tends to add some high frequency "hash", so low pass filtering and chorus (or flanging) are used to "smooth out" the pitch shifting.

The LPF cutoff frequencies are set to give 10 harmonics above the highest note on the guitar:

Highest note on the guitar		329.6	Hz
Number of harmonics				10.0	
LPF cutoff frequency			3296.3	Hz
			
The constants used to set the pitch shifts are shown in the table below.

# Semitones	Freq ratio	-1->1 Pitch Val	Interval
	0		1.0000			0.500		Unison
	1		1.0595			0.530		Minor second
	2		1.1225			0.561		Major second
	3		1.1892			0.595		Minor third
	4		1.2599			0.630		Major third
	5		1.3348			0.667		Perfect fourth
	6		1.4142			0.707		Augmented fourth
	7		1.4983			0.749		Perfect fifth
	8		1.5874			0.794		Minor sixth
	9		1.6818			0.841		Major sixth
	10		1.7818			0.891		Minor seventh
	11		1.8877			0.944		Major seventh
	12		2.0000			1.000		Octave
	

For more information on fv1-programmer see https://github.com/audiofab/fv1_programmer

See https://audiofab.com/ for information on the Audiofab USB Programmer and Easy Spin FV-1 pedal.