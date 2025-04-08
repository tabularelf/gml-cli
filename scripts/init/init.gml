draw_enable_drawevent(false);
debug_event("OutputDebugOn");
gmlspeak_force_init();

for(var _i = 0; _i < 10000; ++_i) {
	var _name = script_get_name(_i);
		if ((_name != "<unknown>") 
		&&  (!string_starts_with(_name, "@@"))
		&&  (!string_starts_with(_name, "YoYo_"))
		&&  (!string_starts_with(_name, "$"))) {
			
		GMLspeak.interface.exposeFunction(_name, _i);	
	}     
}

GMLspeak.toString = function() {
	return "";	
}

GMLspeak.sharedGlobal[$ "GMLspeak"] = global.__gmlspeak__;
GMLspeak.interface.compileFlags.checkForVariables = true;
GMLspeak.interface.compileFlags.useVariableHash = true;
GMLspeak.interface.exposeAsset("obj_instance");
GMLspeak.interface.exposeFunction(
	"method_get_index", 
	catspeak_get_index,
	"method_get_self",
	catspeak_get_self
);

GMLspeak.interface.exposeFunction(
		"method_get_self", 
		function(_func) {
			if (is_catspeak(_func)) {
				var _index = method_get_self(_func);
				return _index[$ "self_"] ?? undefined;
			}
			
			return method_get_self(_func);
		},
		"method_get_index", 
		function(_func) {
			if (is_catspeak(_func)) {
				return __catspeak_get_callee__(_func);
			}
			
			return method(undefined, _func);
		},
		"method", 
		function(_self, _func) {
			if (is_catspeak(_func) && (_self == undefined ||_self == GMLspeak.sharedGlobal)) {
				return __catspeak_get_callee__(_func);
			}
	
			return catspeak_method(_self, _func);
		},
		"show_debug_message", function() {
			var _args = array_create(argument_count);
			for(var _i = 0; _i < argument_count; ++_i) {
				_args[_i] = argument[_i];
			}
			
			var _result = script_execute_ext(string, _args);
			print(_result);
		}
);

GMLspeak.interface.exposeFunction("execute_file", function(_path) {
	try {
		var _buff = buffer_load(_path);
		if (!buffer_exists(_buff)) throw {message: $"{_path} doesn't exist!"};
		var _program = GMLspeak.compile(GMLspeak.parse(_buff));
		if (argument_count == 1) {
			return catspeak_execute(_program);
		} else {
			var _args = array_create(argument_count-1);
			var _i = 0;
			repeat(argument_count-1) {
				_args[_i] = argument[_i+1];
			}
			
			return catspeak_execute_ext(_program, global.__catspeakGmlSelf, _args);
		}
		
	} finally {
		buffer_delete(_buff);	
	}
	
});

GMLspeak.interface.exposeConstant("pwd", __GetExecutablePath());
		