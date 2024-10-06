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
		case "-verbose":
		array_push(_params, 
			{
				paramName: "verbose",
				result: undefined,
			}
		);
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
		case "-string":
		array_push(_params, 
				{
					paramName: "string",
					result: parameter_string(_i+1),
				}
			);
			++_i;
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
	return _elm.paramName == "verbose";
});

if (_index != -1) {
	var _result = _params[_index];
	array_delete(_params, _index, 1);
	array_insert(_params, 0, _result);
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
global.verbose = false;

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
				print("Debug mode enabled!")
			break;
			case "verbose":
				global.verbose = true;
				print("Verbose mode activated");
			break;
			case "keepalive":
				call_cancel(gameEnd);
				gameEnd = undefined;
				if (global.debug) print("Program is set to keep alive!");
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
					if (string_starts_with(_params[_i].result, "./")) {
						_params[_i].result = string_replace(_params[_i].result, "./", __GetExecutablePath());	
					}
					var _buff = buffer_load(_params[_i].result);
					if (!buffer_exists(_buff)) {
						global.result = 2;	// FILE NOT FOUND
						exit;
					} 
					if (program != undefined) {
						throw {message: "script was already defined!"};	
					}
					var str = buffer_read(_buff, buffer_text);
					
					if (global.verbose) {
						print($"Input:\n\n{str}\n\n=========\n");
					}
						var ast = GMLSpeak.parseString(str);
					if (global.verbose) {
						print($"Abstract Tree Syntax:\n\n{json_stringify(ast, true)}\n\n=========\n");
					}
					program = GMLSpeak.compile(ast);
					if (global.debug) || (global.verbose)  print("Program compiled successfully!");
				} finally {
					if (buffer_exists(_buff)) buffer_delete(_buff);
				}
			break;
			case "string":
				if (program != undefined) {
					throw {message: "script was already defined!"};	
				}
				var str = _params[_i].result;
				
				if (global.verbose) {
					print($"Input:\n\n{str}\n\n=========\n");
				}
					var ast = GMLSpeak.parseString(str);
				if (global.verbose) {
					print($"Abstract Tree Syntax:\n\n{json_stringify(ast, true)}\n\n=========\n");
				}
				program = GMLSpeak.compile(ast);
				if (global.debug) || (global.verbose)  print("Program compiled successfully!");
			break;
		}
	}
} catch(_ex) {
	print(_ex.message);	
	if (gameEnd == undefined) {
		game_end(1);	
	}
	exit;
} 

//GMConsolePrint(string(GMLSpeak.sharedGlobal));
//GMConsolePrint(string(scope));
if (program != undefined) {
	try {
		if (global.verbose) {
			print("===Results===\n\n");	
		}
		catspeak_execute_ext(program, scope);		
	} catch(_ex) {
		if (global.verbose) {
			print(_ex.longMessage);	
		} else {
			print(_ex.message);
		}
	if (gameEnd == undefined) {
		game_end(1);	
	}
	exit;	
	}
}