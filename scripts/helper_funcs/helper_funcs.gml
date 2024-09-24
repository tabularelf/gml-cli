function __catspeak_get_callee__(_func) {
	var _index = method_get_self(_func);
	return _index[$ "callee"] ?? _func;
}