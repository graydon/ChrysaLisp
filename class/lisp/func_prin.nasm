%include 'inc/func.inc'
%include 'class/class_vector.inc'
%include 'class/class_stream.inc'
%include 'class/class_lisp.inc'

	def_function class/lisp/func_prin
		;inputs
		;r0 = lisp object
		;r1 = args
		;outputs
		;r0 = lisp object
		;r1 = 0, else value

		def_structure pdata
			ptr pdata_this
			ptr pdata_value
		def_structure_end

		const char_space, " "

		struct pdata, pdata
		ptr args
		ulong length

		push_scope
		retire {r0, r1}, {pdata.pdata_this, args}

		assign {pdata.pdata_this->lisp_sym_nil}, {pdata.pdata_value}
		static_call ref, ref, {pdata.pdata_value}
		static_call vector, get_length, {args}, {length}
		if {length > 1}
			static_call vector, for_each, {args, 1, $prin_callback, &pdata}, {_}
		else
			static_call stream, write_char, {pdata.pdata_this->lisp_stdout, char_space}
		endif

		eval {pdata.pdata_this, pdata.pdata_value}, {r0, r1}
		pop_scope
		return

	prin_callback:
		;inputs
		;r0 = element iterator
		;r1 = predicate data pointer
		;outputs
		;r1 = 0 if break, else not

		pptr iter
		ptr pdata

		push_scope
		retire {r0, r1}, {iter, pdata}

		static_call ref, deref, {pdata->pdata_value}
		static_call lisp, repl_eval, {pdata->pdata_this, *iter}, {pdata->pdata_value}
		if {pdata->pdata_value}
			static_call lisp, repl_print, {pdata->pdata_this, pdata->pdata_this->lisp_stdout, pdata->pdata_value}
		endif

		eval {pdata->pdata_value}, {r1}
		pop_scope
		return

	def_function_end
