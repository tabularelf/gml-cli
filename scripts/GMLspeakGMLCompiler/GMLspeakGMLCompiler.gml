function GMLspeakGMLCompiler(ir, interface=undefined) : CatspeakGMLCompiler(ir, interface) constructor {
	/// @ignore
    ///
    /// @param {Struct} ctx
    /// @param {Struct} term
    /// @return {Function}
    static __compileIndex = function (ctx, term) {
        if (CATSPEAK_DEBUG_MODE) {
            __catspeak_check_arg_struct("term", term,
                "collection", undefined,
                "key", undefined
            );
        }
        return method({
            dbgError : __dbgTerm(term.collection, "is not indexable"),
            collection : __compileTerm(ctx, term.collection),
            key : __compileTerm(ctx, term.key),
        }, __gmlspeak_expr_index_get__);
    };
	
	
	var db = variable_clone(__productionLookup, 1);
	db[@ CatspeakTerm.INDEX] = __compileIndex;
	static_get(CatspeakGMLCompiler).__productionLookup = db;
}

function __gmlspeak_expr_index_get__() {
    var collection_ = collection();
    var key_ = key();
    if (is_array(collection_)) {
        return collection_[key_];
    } else if (__catspeak_is_withable(collection_)) {
		if (!variable_struct_exists(collection_, key_)) {
			show_error($"{key_} is not defined before reading", true);
			return;
		}
        return collection_[$ key_];
    } else {
        __catspeak_error_got(dbgError, collection_);
    }
}