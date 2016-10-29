%include 'inc/func.inc'
%include 'class/class_error.inc'

def_func class/error/create
	;inputs
	;r0 = cstr pointer
	;r1 = error payload object
	;outputs
	;r0 = 0 if error, else object
	;trashes
	;r1-r3, r5-r7

	;save data
	vp_cpy r0, r6
	vp_cpy r1, r7

	;create new string object
	f_call error, new, {}, {r0}
	if r0, !=, 0
		;init the object
		func_path class, error
		f_call error, init, {r0, @_function_, r6, r7}, {r1}
		if r1, ==, 0
			;error with init
			v_call error, delete, {r0}, {}, r1
			vp_xor r0, r0
		endif
	endif
	vp_ret

def_func_end