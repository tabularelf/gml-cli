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
		case "-debug":
		case "-d":
			array_push(_params, 
				{
					paramName: "debug",
					result: undefined,
				}
			);
		break;
		case "-timeout":
		case "-t":
			array_push(_params, 
				{
					paramName: "timeout",
					result: parameter_string(_i+1),
				}
			);
		break;
		case "-keepalive":
			array_push(_params, 
				{
					paramName: "keepalive",
					result: undefined,
				}
			);
		break;
	}
}

var _index = array_find_index(_params, function(_elm, _index) {
	return _elm.paramName == "debug";
});

if (_index != -1) {
	var _result = _params[_index];
	array_delete(_params, _index, 1);
	array_insert(_params, 0, _result);
}

gameEnd = call_later(1,  time_source_units_frames, function() {
	game_end(global.result);
});

global.debug = false;

global.catspeakTimeout = 1000;
global.result = 0; // Exit safely
program = undefined;
scope = {};

try {
	var _len = array_length(_params);
	for(var _i = 0; _i < _len; ++_i) {
		if (global.result != 0) break;
		switch(_params[_i].paramName) {
			case "debug":
				global.debug = true;
				GMConsolePrint("Debug mode enabled!")
			break;
			case "keepalive":
				call_cancel(gameEnd);
				gameEnd = undefined;
				if (global.debug) GMConsolePrint("Program is set to keep alive!");
			break;
			case "timeout":
				if (string_pos("inf", _params[_i])) {
					global.catspeakTimeout = infinity;	
				} else {
					global.catspeakTimeout = real(result);
				}
			break;
			case "script":
				try {
					var _buff = buffer_load(_params[_i].result);
					if (!buffer_exists(_buff)) {
						global.result = 2;	// FILE NOT FOUND
						exit;
					} 
					if (program != undefined) {
						throw {message: "script was already defined!"};	
					}
					program = GMLSpeak.compile(GMLSpeak.parse(_buff));
					if (global.debug) GMConsolePrint("Program compiled successfully!");
				} finally {
					if (buffer_exists(_buff)) buffer_delete(_buff);
				}
			break;
		}
	}
} catch(_ex) {
	GMConsolePrint(_ex.message);
	if (gameEnd == undefined) {
		game_end(1);	
	}
	exit;
} 

//GMConsolePrint(string(GMLSpeak.sharedGlobal));
//GMConsolePrint(string(scope));
if (program != undefined) {
	try {
		catspeak_execute_ext(program, scope);		
	} catch(_ex) {
		GMConsolePrint(_ex.message);
	if (gameEnd == undefined) {
		game_end(1);	
	}
	exit;	
	}
}