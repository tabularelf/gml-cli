function __catspeak_get_callee__(_func) {
	var _index = method_get_self(_func);
	return _index[$ "callee"] ?? _func;
}

function execute(_func) {
	try {
		_func();	
	} catch(_ex) {
		global.result = 1;
		print(_ex.message);
		game_end(global.result);
	}
}

function __GetExecutablePath() {
    static _path = (os_type == os_windows || os_type == os_macosx || os_linux == os_linux) ?
    filename_path((!code_is_compiled() && (GM_build_type == "run")) ? parameter_string(2) :( os_type == os_macosx ? __MacOSXStripPath() : parameter_string(0))) : program_directory;
    
    return _path;
}

function __MacOSXStripPath() {
	var _pos = string_last_pos("/", program_directory);
	repeat(3) {
		_pos = string_last_pos_ext("/", program_directory, _pos-1);
	}
	
	return string_copy(program_directory, 1, _pos);
}