'NSI2000 script for motion control for forming a cylindrical antenna array

Sub Main
	Dim i As Integer
	Dim j As Integer

	CONTROLLER_AUX_AXIS_SET "Azimuth"
	SET_SCANNER_ZERO

	For i = 0 To 4 Step 1
		For j = -5 To 6 Step 1
			MOVE_AXES 0,i*0.01,j*30-10
			ShellSync("python C:\Bella\send_command.py StartTransm")
		Next j
	Next i
	ShellSync("python C:\Bella\send_command.py WriteCSV")
	MOVE_TO_SCANNER_ZERO
	
End Sub