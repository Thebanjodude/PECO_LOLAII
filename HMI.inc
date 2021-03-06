
'Commands from HMI
Global Boolean jobDone
Global Integer jobNumPanels, jobNumPanelsDone, jobAbortBtn
Global Boolean backInterlockACKBtn, frontInterlockACKBtn
Global Boolean inMagGoHomeBtn, inMagLoadedBtn
Global Boolean jobPauseBtn, jobResumeBtn, jobStartBtn, abortJobBtn
Global Boolean jobStopBtn, leftInterlockACKBtn, outMagGoHomeBtn
Global Boolean outMagUnloadedBtn, rightInterlockACKBtn, sftyFrmIlockAckBtn
Global Boolean backInterlockACK, frontInterlockACK
Global Boolean jobPause, jobResume, jobStart
Global Boolean jobStop, leftInterlockACK
Global Boolean rightInterlockACK, sftyFrmIlockAck

'Left and Right Spotface Measurements=> send to HMI
Global Real hole0R, hole0L, hole1R, hole1L, hole2R, hole2L, hole3R, hole3L, hole4R, hole4L
Global Real hole5R, hole5L, hole6R, hole6L, hole7R, hole7L, hole8R, hole8L, hole9R, hole9L
Global Real hole10R, hole10L, hole11R, hole11L, hole12R, hole12L, hole13R, hole13L, hole14R, hole14L
Global Real hole15R, hole15L, hole16R, hole16L, hole17R, hole17L, hole18R, hole18L, hole19R, hole19L
Global Real hole20R, hole20L, hole21R, hole21L, hole22R, hole22L, hole23L, hole23R

' Send HMI all the holes that passed or failed ,(True=Pass)
' When a hole fails the operator will know which hole failed.
Global Boolean hole0PF, hole1PF, hole2PF, hole3PF, hole4PF
Global Boolean hole5PF, hole6PF, hole7PF, hole8PF, hole9PF
Global Boolean hole10PF, hole11PF, hole12PF, hole13PF, hole14PF
Global Boolean hole15PF, hole16PF, hole17PF, hole18PF, hole19PF
Global Boolean hole20PF, hole21PF, hole22PF, hole23PF

' insert present vars
Global Boolean insertPresent01
Global Boolean insertPresent02
Global Boolean insertPresent03
Global Boolean insertPresent04
Global Boolean insertPresent05
Global Boolean insertPresent06
Global Boolean insertPresent07
Global Boolean insertPresent08
Global Boolean insertPresent09
Global Boolean insertPresent10
Global Boolean insertPresent11
Global Boolean insertPresent12
Global Boolean insertPresent13
Global Boolean insertPresent14
Global Boolean insertPresent15
Global Boolean insertPresent16
Global Boolean insertPresent17
Global Boolean insertPresent18
Global Boolean insertPresent19
Global Boolean insertPresent20
Global Boolean insertPresent21
Global Boolean insertPresent22
Global Boolean insertPresent23


