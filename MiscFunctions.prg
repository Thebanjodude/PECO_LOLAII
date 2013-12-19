#include "Globals.INC"


Function InTomm(inches As Real) As Real
	InTomm = inches * 25.4
Fend
Function mmToin(mm As Real) As Real
	mmToin = mm * 0.0393701
Fend
Function ChoosePointsTable()
	' Choose which points table to load

	If recPointsTable = 1 Then
		LoadPoints "points.pts"
	ElseIf recPointsTable = 2 Then
		LoadPoints "points2.pts"
	ElseIf recPointsTable = 3 Then
		LoadPoints "points3.pts"
	Else
		erUnknown = True
		Print "point Table is Unknown"
	EndIf
Fend
Function SavePointsTable()
	' Choose which points table to save

	If recPointsTable = 1 Then
		SavePoints "points.pts"
	ElseIf recPointsTable = 2 Then
		SavePoints "points2.pts"
	ElseIf recPointsTable = 3 Then
		SavePoints "points3.pts"
	Else
		erUnknown = True
		Print "point Table is Unknown"
	EndIf
Fend


