#SingleInstance, force
FileEncoding, UTF-8

; Create `custom.ahk` relative to this script and define `use_custom := True`
; there if you want to override the default hotkeys to better suite your needs.
; See https://www.autohotkey.com/docs/Hotkeys.htm for all possible combinations.
#Include *i custom.ahk

#If not use_custom
^!g::CreateAndEditProject() ; Ctrl + Alt + G
^!e::EditRecentProject()    ; Ctrl + Alt + E
#If

CreateAndEditProject() {
	project_template := "templates\2d"
	if not FileExist("config.ini") {
		IniWrite, % "", config.ini, paths, godot_executable
		IniWrite, templates\2d, config.ini, paths, project_template
	} else {
		IniRead, godot_executable, config.ini, paths, godot_executable
		IniRead, project_template, config.ini, paths, project_template
	}
	while not FileExist(godot_executable) {
		; If not set, ask to provide a path via the open dialog.
		FileSelectFile, godot_executable, 3, godot.exe, Select Godot executable, *.exe
		if (ErrorLevel == 1) {
			; The user has cancelled the dialog.
			return
		}
		if FileExist(godot_executable) {
			IniWrite, %godot_executable%, config.ini, paths, godot_executable
			break
		}
	}
	FormatTime, timestamp, %A_Now%, yyyy-MM-dd-THH-mm-ss
	project_path = projects/godot_%timestamp%
	if FileExist(project_template) {
		; Create a new project from an existing project template.
		FileCopyDir, %project_template%, %project_path%
	} else {
		; Create an empty project.
		FileCreateDir, %project_path%
		FileAppend, , %project_path%/project.godot
	}
	Run, %godot_executable% --path %project_path% --editor
}

EditRecentProject() {
	if not FileExist("config.ini") {
		return
	} else {
		IniRead, godot_executable, config.ini, paths, godot_executable
	}
	if not FileExist(godot_executable) {
		return
	}
	recent_project_path := ""
	Loop, Files, project.godot, FR
	{
		t1 := A_LoopFileTimeCreated
		If (t1 > t2)
		{
			t2 := A_LoopFileTimeCreated
			recent_project_path := A_LoopFileDir
		}
	}
	if (recent_project_path) {
		Run, %godot_executable% --path %recent_project_path% --editor
	}
}
