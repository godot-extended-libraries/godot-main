# Godot Main

Are you tired of the following process of creating new projects in [**Godot Engine**](https://godotengine.org/)?

1. Open project manager.
2. Create a new project.
3. Launch the editor.
4. Create new scene.
5. Choose root node.
6. Create new script.
7. Set the scene as ***main***.

This repository contains scripts and other tools which help to eliminate the 
above steps, so you can just focus on prototyping your ideas rather than spend
your time on chores.

## Configuration

The `templates/` directory in this repository contains 2D and 3D templates with
`main.tscn` already instantiated. The default environment is not present in 2D
template to speed up project startup.

The `config.ini` file can be created at the root of this repository with the
following keys (values are just examples):
```ini
[paths]
godot_executable=D:\bin\godot\godot.exe
project_template=templates\2d
```

| Key                | Description                                                                      |
| ------------------ | -------------------------------------------------------------------------------- |
| `godot_executable` | The absolute path to Godot's executable                                          |
| `project_template` | A *relative* path to one of the project templates in the `templates/` directory. |

If the `config.ini` file does not exist, a new one will be created by a script.

User-defined templates can be created at `templates/user/` directory (which is
`gitignore`d).

The sections below describe already implemented scripts per platform that you
can use.

# Scripts

## Windows

### AutoHotKey

The `godot.ahk` can be launched on Windows with
[AutoHotKey](https://www.autohotkey.com/) installed.

After launching the script, use <kbd>Ctrl + Alt + G</kbd> to *create* and edit a
new project, and <kbd>Ctrl + Alt + E</kbd> to *launch* and edit a recently edited
project immediately.

Optionally, a `custom.ahk` can be created to override the default shortcuts. Make
sure to write `use_custom := True` at the top. For instance:
```ahk
use_custom := True

^!g:: ; Ctrl + Alt + G
	Input, user_input, B C I L1 T3 M E
	if (user_input = "g")
		CreateAndEditProject()
	else if (user_input = "e")
		EditRecentProject()
	return
```

# Development

The task here is to have a script which can:
1. Parse `config.ini` (or any other configuration file for that matter).
2. Automatically create a new project from one of the project templates in the
   `templates/` directory.
3. Save it under `projects/` directory.
4. Launch it for editing immediately.

Not all steps may be possible to perform depending on the platform, so it's ok
if some steps are skipped.
