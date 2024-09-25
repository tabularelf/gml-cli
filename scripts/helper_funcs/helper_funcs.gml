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