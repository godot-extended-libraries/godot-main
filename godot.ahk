#SingleInstance, force
FileEncoding, UTF-8

; Create `custom.ahk` relative to this script and define `use_custom := True`
; there if you want to override the default hotkeys to better suite your needs.
; See https://www.autohotkey.com/docs/Hotkeys.htm for all possible combinations.
#Include *i custom.ahk

#If not use_custom
^!g::CreateAndEditProject() ; Ctrl + Alt + G
^!e::OpenRecentProject()    ; Ctrl + Alt + E
#If

CreateAndEditProject() {
	if not FileExist("config.ini") {
		IniWrite, % "", config.ini, paths, godot_exec
		IniWrite, templates\default, config.ini, paths, template_project
	} else {
		IniRead, godot_exec, config.ini, paths, godot_exec
		IniRead, template_project, config.ini, paths, template_project
	}
	while not FileExist(godot_exec) {
		; If not set, ask to provide a path via the open dialog.
		FileSelectFile, godot_exec, 3, godot.exe, Select Godot executable, *.exe
		if (ErrorLevel == 1) {
			; The user has cancelled the dialog.
			return
		}
		if FileExist(godot_exec) {
			IniWrite, %godot_exec%, config.ini, paths, godot_exec
			break
		}
	}
	FormatTime, timestamp, %A_Now%, yyyy-MM-dd-THH-mm-ss
	project_path = projects/godot_%timestamp%
	if FileExist(template_project) {
		; Create a new project from an existing project template.
		FileCopyDir, %template_project%, %project_path%
	} else {
		; Create an empty project.
		FileCreateDir, %project_path%
		FileAppend, , %project_path%/project.godot
	}
	Run, %godot_exec% --path %project_path% --editor
}

OpenRecentProject() {
	if not FileExist("config.ini") {
		return
	} else {
		IniRead, godot_exec, config.ini, paths, godot_exec
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
		Run, %godot_exec% --path %recent_project_path% --editor
	}
}
