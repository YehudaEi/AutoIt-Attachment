#include "SoundGetSetQuery.au3"


; _SoundGet example - Gets the master playback volume level
MsgBox(64, "Master Volume", "Master Volume Level: " & _SoundGet(0, "dSpeakers", 1, "Volume") & "%")

; _SoundGet example - Gets the wave playback mute control
MsgBox(64, "Wave Mute", "Wave Mute Status: " & _SoundGet(0, "sWave", 1, "Mute"))

; _SoundSet example - Sets the master playback volume level
MsgBox(64, "Master Volume", "Master Volume Level (should be 27%): " & _SoundSet(0, "dSpeakers", 1, "Volume", 27) & "%")

; _SoundSet example - Sets the wave playback mute control
MsgBox(64, "Wave Mute", "Wave Mute Status (should be 1 - muted): " & _SoundSet(0, "sWave", 1, "Mute", 1))



; _SoundGetMasterVolume example - Gets the master playback volume level
MsgBox(64, "Master Volume", "Master Volume Level: " & _SoundGetMasterVolume() & "%")

; _SoundSetMasterVolume example - Sets the master playback volume level
MsgBox(64, "Master Volume", "Master Volume Level (should be 44%): " & _SoundSetMasterVolume(44) & "%")

; _SoundGetMasterMute example - Gets the master playback mute status
MsgBox(64, "Master Mute", "Master Mute Status: " & _SoundGetMasterMute())

; _SoundSetMasterMute example - Sets the master playback mute control
MsgBox(64, "Master Mute", "Master Mute Status (should be 0 - unmuted): " & _SoundSetMasterMute(0))

; Toggle Master Mute Control example
_SoundSetMasterMute(Not _SoundGetMasterMute())



; _SoundGetWaveVolume example - Gets the wave playback volume level
MsgBox(64, "Wave Volume", "Wave Volume Level: " & _SoundGetWaveVolume() & "%")

; _SoundSetWaveVolume example - Sets the wave playback volume level
MsgBox(64, "Wave Volume", "Wave Volume Level (should be 69%): " & _SoundSetWaveVolume(69) & "%")

; _SoundGetWaveMute example - Gets the wave playback mute status
MsgBox(64, "Wave Mute", "Wave Mute Status: " & _SoundGetWaveMute())

; _SoundSetWaveMute example - Sets the wave playback mute control
MsgBox(64, "Wave Mute", "Wave Mute Status (should be 1 - muted): " & _SoundSetWaveMute(1))



; _SoundGetCDVolume example - Gets the CD playback volume level
MsgBox(64, "CD Volume", "CD Volume Level: " & _SoundGetCDVolume() & "%")

; _SoundSetCDVolume example - Sets the CD playback volume level
MsgBox(64, "CD Volume", "CD Volume Level (should be 13%): " & _SoundSetCDVolume(13) & "%")

; _SoundGetCDMute example - Gets the CD playback mute status
MsgBox(64, "CD Mute", "CD Mute Status: " & _SoundGetCDMute())

; _SoundSetCDMute example - Sets the CD playback mute control
MsgBox(64, "CD Mute", "CD Mute Status (should be 0 - unmuted): " & _SoundSetCDMute(0))



; _SoundGetPhoneVolume example - Gets the telephone/modem playback volume level
MsgBox(64, "Phone Volume", "Phone Volume Level: " & _SoundGetPhoneVolume() & "%")

; _SoundSetPhoneVolume example - Sets the telephone/modem playback volume level
MsgBox(64, "Phone Volume", "Phone Volume Level (should be 33%): " & _SoundSetPhoneVolume(33) & "%")

; _SoundGetPhoneMute example - Gets the telephone/modem playback mute status
MsgBox(64, "Phone Mute", "Phone Mute Status: " & _SoundGetPhoneMute())

; _SoundSetPhoneMute example - Sets the telephone/modem playback mute control
MsgBox(64, "Phone Mute", "Phone Mute Status (should be 1 - muted): " & _SoundSetPhoneMute(1))



; _SoundQuery example - Queries the current sound system for available controls and their values
_SoundQuery()
