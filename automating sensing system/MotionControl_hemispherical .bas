'NSI2000 script for motion control for forming a hemispherical antenna array.

Sub Main
	Dim i As Integer
	Dim j As Integer

	CONTROLLER_AUX_AXIS_SET "Azimuth"

	For j = 6 To 1 Step -1
		For i = 0 To 11 Step 1
			MOVE_AXES 0,i*30,j*15
			ShellSync("python C:\Bella\send_command.py StartTransm")
		Next i
	Next j
	ShellSync("python C:\Bella\send_command.py WriteCSV")
	MOVE_TO_SCANNER_ZERO
	
End Sub