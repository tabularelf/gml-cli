function print(_str) {
	if (os_type == os_windows) {
		GMConsolePrint(_str);	
	} else {
		show_debug_message(_str);	
	}
}