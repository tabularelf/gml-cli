var _params = [];
for(var _i = 0; _i < parameter_count(); ++_i) {
	switch(parameter_string(_i)) {
		case "-script":
		case "-s":
			array_push(_params, 
				{
					paramName: "script",
					result: parameter_string(_i+1),
				}
			);
			++_i;
		break;
	}
}

call_later(1,  time_source_units_seconds, function() {
	game_end(global.result);
});

global.result = 0; // Exit safely
var _len = array_length(_params);
for(var _i = 0; _i < _len; ++_i) {
	switch(_params[_i].paramName) {
		case "script":
			try {
				var _buff = buffer_load(_params[_i].result);
				if (!buffer_exists(_buff)) {
					global.result = 2;	// FILE NOT FOUND
					exit;
					
				} 
				var _program = GMLSpeak.compile(GMLSpeak.parse(_buff));
				catspeak_execute_ext(_program, {});
			} catch(_ex) {
				GMConsolePrint(_ex.message);
				global.result = 1;
			} finally {
				if (buffer_exists(_buff)) buffer_delete(_buff);
			}
		break;
	}
}