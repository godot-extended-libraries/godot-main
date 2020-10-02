#InstallKeybdHook

FileEncoding, UTF-8

; https://www.autohotkey.com/docs/Hotkeys.htm
Browser_Home::
	run_godot()
	return

run_godot() {
	if FileExist("config.ini") {
		IniRead, godot_exec, config.ini, paths, godot_exec
		IniRead, template_project, config.ini, paths, template_project
	} else {
		IniWrite, "", config.ini, paths, godot_exec
		IniWrite, "", config.ini, paths, template_project
		MsgBox, A new config.ini file was created, please configure it now.
	}
	if (godot_exec != "") {
		if (template_project == "") {
			FileCreateDir, test
			FileAppend, , test/project.godot
			Run, %godot_exec% --path test --editor
		} else {
			Run, %godot_exec% --path %template_project% --editor
		}
	}
}
