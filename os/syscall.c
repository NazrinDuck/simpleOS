#include "syscall.h"
#include "defs.h"
#include "loader.h"
#include "log.h"
#include "proc.h"
#include "syscall_ids.h"
#include "timer.h"
#include "trap.h"

uint64 sys_write(int fd, char *str, uint len)
{
	debugf("sys_write fd = %d str = %x, len = %d", fd, str, len);
	if (fd != STDOUT)
		return -1;
	for (int i = 0; i < len; ++i) {
		console_putchar(str[i]);
	}
	return len;
}

__attribute__((noreturn)) void sys_exit(int code)
{
	exit(code);
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
	yield();
	return 0;
}

uint64 sys_gettimeofday(TimeVal *val, int _tz)
{
	uint64 cycle = get_cycle();
	val->sec = cycle / CPU_FREQ;
	val->usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
	return 0;
}

int sys_task_info(struct TaskInfo *ti, struct proc *curr_proc)
{
	if (ti == (void *)0) {
		return -1;
	}

	uint64 cycle = get_cycle();
	curr_proc->task_info.time = (cycle % CPU_FREQ) * 1000 / CPU_FREQ;

	/*
	debugf("status:%d, time:%d (ms)", curr_proc->task_info.status,
	       curr_proc->task_info.time);
         */

	ti->status = curr_proc->task_info.status;
	ti->time = curr_proc->task_info.time;
	for (int i = 0; i < MAX_SYSCALL_NUM; i++) {
		ti->syscall_times[i] = curr_proc->task_info.syscall_times[i];
		/*
		debugf("syscall[%d]: %d", i,
		       curr_proc->task_info.syscall_times[i]);
         */
	}

	return 0;
}

/*
* LAB1: you may need to define sys_task_info here
*/

extern char trap_page[];

void syscall()
{
	struct trapframe *trapframe = curr_proc()->trapframe;
	int id = trapframe->a7, ret;
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
			   trapframe->a3, trapframe->a4, trapframe->a5 };
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
	       args[1], args[2], args[3], args[4], args[5]);

	curr_proc()->task_info.syscall_times[id]++;
	/*
	* LAB1: you may need to update syscall counter for task info here
	*/
	switch (id) {
	case SYS_write:
		ret = sys_write(args[0], (char *)args[1], args[2]);
		break;
	case SYS_exit:
		sys_exit(args[0]);
		// __builtin_unreachable();
	case SYS_sched_yield:
		ret = sys_sched_yield();
		break;
	case SYS_gettimeofday:
		ret = sys_gettimeofday((TimeVal *)args[0], args[1]);
		break;
	case SYS_task_info:
		ret = sys_task_info((struct TaskInfo *)args[0], curr_proc());
		break;
	/*
	* LAB1: you may need to add SYS_taskinfo case here
	*/
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
	tracef("syscall ret %d", ret);
}
