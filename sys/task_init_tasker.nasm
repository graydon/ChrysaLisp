%include "func.inc"
%include "task.inc"

	fn_function "sys/task_init_tasker"
		;get task statics
		fn_call sys/task_get_statics
		vp_cpy r0, r3

		;init task control block heap
		vp_lea [r3 + TK_STATICS_TASK_HEAP], r0
		vp_cpy TK_NODE_SIZE, r1
		vp_cpy TK_NODE_SIZE*8, r2
		fn_call sys/heap_init

		;init task lists
		vp_lea [r3 + TK_STATICS_TASK_LIST], r0
		lh_init r0, r1
		vp_lea [r3 + TK_STATICS_TASK_SUSPEND_LIST], r0
		lh_init r0, r1
		vp_ret

	fn_function_end
