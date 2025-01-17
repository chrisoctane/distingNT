[SDCard_Bank_X]
==============================
Complete libraries that are ready to copy to a blank microSD card. they contain different content and can be thought of as preset banks if you have multiple microSD cards. 

Format a MicroSD card then copy everything from inside "SDCard_Bank_X" directly onto it, exactly as it's laid out.  If you do so, everything on your Disting NT will work out of the box (with the latest firmware) without fuss.  
Don't combine banks because there are some intentional limits in place on the hardware.

Bank A:
FMSYX		SynprezFM
samples		CORec_MSCollection
impulses	Samplicity M7

Bank B:
FMSYX		DX7-OC
samples		Snailed_MSCollection
impulses	EchoThiefImpulseResponseLibrary


[master] Folders
==============================
These folders are mini repositories of various types, named for the destination on the SDCard that their contents are to be placed.  

There are limits on the number of files/folders that can be used in the samples folder - 10,000 samples shared by 1000 folders, currently. This limit makes it possible to switch samples live - even add CV control to switch through multisample banks!

I find it best practice to delete everything in a folder (eg. the samples folder) before copying other content into it. I'll try to make sure that these folders aren't too big to copy - but if you run into any issues, flag them in the Expert Sleepers Discord.

SDCard Image/UI scripts
==============================
2 presets with LUA UI are available in the presets folder. They have LUA UI in their name.  To try these out, load the preset then load the corresponding LUA GUI file from the 'ui_scripts folder to see some cool macro action thanks to @chordsmaze from the Expert Sleepers' Discord.

tools
==============================
All of the juicy stuff: Firmware, library tools, program building - all in one place.


If you have samples, multisamples, suggestions, complaints, or anything else to share, come to the Expert Sleepers Discord.

Have fun 

Chris.