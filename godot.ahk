#SingleInstance, force

FileEncoding, UTF-8

; See https://www.autohotkey.com/docs/Hotkeys.htm for all possible combinations.
^!g:: ; Ctrl + Alt + G
	CreateAndEditNewGodotProject()
	return

CreateAndEditNewGodotProject() {
	if not FileExist("config.ini") {
		IniWrite, % "", config.ini, paths, godot_exec
		IniWrite, templates/default, config.ini, paths, template_project
	} else {
		IniRead, godot_exec, config.ini, paths, godot_exec
		IniRead, template_project, config.ini, paths, template_project
	}
	exec_found := FileExist(godot_exec)
	while (not exec_found) {
		; If not set, ask to provide a path via the open dialog.
		FileSelectFile, godot_exec, 3, godot.exe, Select Godot executable, *.exe
		if (ErrorLevel == 1) {
			; The user has cancelled the dialog.
			return
		}
		if (FileExist(godot_exec)) {
			IniWrite, %godot_exec%, config.ini, paths, godot_exec
			exec_found := True
			break
		}
	}
	if FileExist(template_project) {
		; Create a new project from an existing project template.
		FileCopyDir, %template_project%, projects/%A_Now%
		Run, %godot_exec% --path projects/%A_Now% --editor
	} else {
		; Create an empty project.
		FileCreateDir, projects/test
		FileAppend, , projects/test/project.godot
		Run, %godot_exec% --path test --editor
	}
}
