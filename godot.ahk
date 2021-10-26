#SingleInstance, force
FileEncoding, UTF-8

; Create `custom.ahk` relative to this script and define `use_custom := True`
; there if you want to override the default hotkeys to better suite your needs.
; See https://www.autohotkey.com/docs/Hotkeys.htm for all possible combinations.
#Include *i custom.ahk

#If not use_custom
^!g::CreateAndEditProject() ; Ctrl + Alt + G
^!o::OpenAndEditProject()   ; Ctrl + Alt + O
^!e::EditRecentProject()    ; Ctrl + Alt + E
#If

CreateAndEditProject() {
	project_template := "templates\2d"

	if not FileExist("config.ini") {
		IniWrite, % "", config.ini, paths, godot_executable
		IniWrite, templates\2d, config.ini, paths, project_template
		IniWrite, % "", config.ini, paths, project_recent
	} else {
		IniRead, godot_executable, config.ini, paths, godot_executable
		IniRead, project_template, config.ini, paths, project_template
		IniRead, project_recent, config.ini, paths, project_recent
	}

	godot_executable := NavigateGodotExecutable(godot_executable)
	if not FileExist(godot_executable) {
		return
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
	IniWrite, %project_path%, config.ini, paths, project_recent
	Run, %godot_executable% --path %project_path% --editor
}

OpenAndEditProject() {
	if not FileExist("config.ini") {
		IniWrite, % "", config.ini, paths, godot_executable
		IniWrite, templates\2d, config.ini, paths, project_template
		IniWrite, % "", config.ini, paths, project_recent
	} else {
		IniRead, godot_executable, config.ini, paths, godot_executable
		IniRead, project_recent, config.ini, paths, project_recent
	}

	godot_executable := NavigateGodotExecutable(godot_executable)
	if not FileExist(godot_executable) {
		return
	}
	godot_project := NavigateGodotProject(project_recent)
	if FileExist(godot_project) {
		Run, %godot_executable% --path %godot_project% --editor
	}
}

EditRecentProject() {
	if not FileExist("config.ini") {
		return
	} else {
		IniRead, godot_executable, config.ini, paths, godot_executable
		IniRead, project_recent, config.ini, paths, project_recent
	}
	if not FileExist(godot_executable) {
		return
	}
	if not FileExist(project_recent) {
		; Find recent project from the directory where this script is located.
		project_recent := ""
		Loop, Files, project.godot, FR
		{
			t1 := A_LoopFileTimeCreated
			If (t1 > t2)
			{
				t2 := A_LoopFileTimeCreated
				project_recent := A_LoopFileDir
			}
		}
	}
	if FileExist(project_recent) {
		Run, %godot_executable% --path %project_recent% --editor
	}
}

NavigateGodotExecutable(search_path) {
	godot_executable := search_path
	while not FileExist(godot_executable) {
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
	return godot_executable
}

NavigateGodotProject(search_path) {
	godot_project := ""
	while not FileExist(godot_project) {
		; Asterisk in `search_path` allows to pre-open recent project path.
		FileSelectFolder, godot_project, *%search_path%, 0, Select Godot project folder
		if (ErrorLevel == 1) {
			; The user has cancelled the dialog.
			return
		}
		if FileExist(godot_project) {
			IniWrite, %godot_project%, config.ini, paths, project_recent
			break
		}
	}
	return godot_project
}
