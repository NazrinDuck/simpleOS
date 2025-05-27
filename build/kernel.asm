
build/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    80200000:	00066117          	auipc	sp,0x66
    80200004:	00010113          	mv	sp,sp
    call main
    80200008:	529000ef          	jal	ra,80200d30 <main>

000000008020000c <init_queue>:
#include "queue.h"
#include "defs.h"

void
init_queue(struct queue *q)
{
    8020000c:	1141                	addi	sp,sp,-16
    8020000e:	e422                	sd	s0,8(sp)
    80200010:	0800                	addi	s0,sp,16
	q->front = q->tail = 0;
    80200012:	6785                	lui	a5,0x1
    80200014:	953e                	add	a0,a0,a5
    80200016:	00052223          	sw	zero,4(a0)
    8020001a:	00052023          	sw	zero,0(a0)
	q->empty = 1;
    8020001e:	4785                	li	a5,1
    80200020:	c51c                	sw	a5,8(a0)
}
    80200022:	6422                	ld	s0,8(sp)
    80200024:	0141                	addi	sp,sp,16
    80200026:	8082                	ret

0000000080200028 <push_queue>:

void
push_queue(struct queue *q, int value, unsigned long long stride)
{
    80200028:	7179                	addi	sp,sp,-48
    8020002a:	f406                	sd	ra,40(sp)
    8020002c:	f022                	sd	s0,32(sp)
    8020002e:	ec26                	sd	s1,24(sp)
    80200030:	e84a                	sd	s2,16(sp)
    80200032:	e44e                	sd	s3,8(sp)
    80200034:	e052                	sd	s4,0(sp)
    80200036:	1800                	addi	s0,sp,48
    80200038:	892a                	mv	s2,a0
    8020003a:	8a2e                	mv	s4,a1
    8020003c:	89b2                	mv	s3,a2
	if (!q->empty && q->front == q->tail) {
    8020003e:	6785                	lui	a5,0x1
    80200040:	97aa                	add	a5,a5,a0
    80200042:	479c                	lw	a5,8(a5)
    80200044:	ebfd                	bnez	a5,8020013a <push_queue+0x112>
    80200046:	6785                	lui	a5,0x1
    80200048:	97aa                	add	a5,a5,a0
    8020004a:	4398                	lw	a4,0(a5)
    8020004c:	43dc                	lw	a5,4(a5)
    8020004e:	0af70763          	beq	a4,a5,802000fc <push_queue+0xd4>
		q->tail = (q->tail + 1) % NPROC;
		return;
	}

	int i;
	for (i = q->front; i <= q->tail; ++i) {
    80200052:	6785                	lui	a5,0x1
    80200054:	97ca                	add	a5,a5,s2
    80200056:	4390                	lw	a2,0(a5)
    80200058:	43d8                	lw	a4,4(a5)
    8020005a:	10c74b63          	blt	a4,a2,80200170 <push_queue+0x148>
    8020005e:	20260793          	addi	a5,a2,514
    80200062:	078e                	slli	a5,a5,0x3
    80200064:	97ca                	add	a5,a5,s2
    80200066:	84b2                	mv	s1,a2
		if (stride < q->stride[i]) {
    80200068:	6394                	ld	a3,0(a5)
    8020006a:	00d9e663          	bltu	s3,a3,80200076 <push_queue+0x4e>
	for (i = q->front; i <= q->tail; ++i) {
    8020006e:	2485                	addiw	s1,s1,1
    80200070:	07a1                	addi	a5,a5,8
    80200072:	fe975be3          	bge	a4,s1,80200068 <push_queue+0x40>
			break;
		}
	}

	q->tail = (q->tail + 1) % NPROC;
    80200076:	2705                	addiw	a4,a4,1
    80200078:	41f7579b          	sraiw	a5,a4,0x1f
    8020007c:	0177d69b          	srliw	a3,a5,0x17
    80200080:	9f35                	addw	a4,a4,a3
    80200082:	1ff77793          	andi	a5,a4,511
    80200086:	9f95                	subw	a5,a5,a3
    80200088:	0007869b          	sext.w	a3,a5
    8020008c:	6705                	lui	a4,0x1
    8020008e:	974a                	add	a4,a4,s2
    80200090:	c35c                	sw	a5,4(a4)
	if (q->front == q->tail) {
    80200092:	0ec68163          	beq	a3,a2,80200174 <push_queue+0x14c>
		panic("queue shouldn't be overflow");
	}
	for (int t = q->tail; t > i; --t) {
    80200096:	6785                	lui	a5,0x1
    80200098:	97ca                	add	a5,a5,s2
    8020009a:	43d4                	lw	a3,4(a5)
    8020009c:	02d4dd63          	bge	s1,a3,802000d6 <push_queue+0xae>
    802000a0:	00269593          	slli	a1,a3,0x2
    802000a4:	00b907b3          	add	a5,s2,a1
    802000a8:	20168713          	addi	a4,a3,513
    802000ac:	070e                	slli	a4,a4,0x3
    802000ae:	974a                	add	a4,a4,s2
    802000b0:	ffc90613          	addi	a2,s2,-4
    802000b4:	962e                	add	a2,a2,a1
    802000b6:	36fd                	addiw	a3,a3,-1
    802000b8:	9e85                	subw	a3,a3,s1
    802000ba:	02069593          	slli	a1,a3,0x20
    802000be:	01e5d693          	srli	a3,a1,0x1e
    802000c2:	8e15                	sub	a2,a2,a3
		q->data[t] = q->data[t - 1];
    802000c4:	ffc7a683          	lw	a3,-4(a5) # ffc <_entry-0x801ff004>
    802000c8:	c394                	sw	a3,0(a5)
		q->stride[t] = q->stride[t - 1];
    802000ca:	6314                	ld	a3,0(a4)
    802000cc:	e714                	sd	a3,8(a4)
	for (int t = q->tail; t > i; --t) {
    802000ce:	17f1                	addi	a5,a5,-4
    802000d0:	1761                	addi	a4,a4,-8
    802000d2:	fec799e3          	bne	a5,a2,802000c4 <push_queue+0x9c>
	}
	q->data[i] = value;
    802000d6:	00249793          	slli	a5,s1,0x2
    802000da:	97ca                	add	a5,a5,s2
    802000dc:	0147a023          	sw	s4,0(a5)
	q->stride[i] = stride;
    802000e0:	20248493          	addi	s1,s1,514
    802000e4:	048e                	slli	s1,s1,0x3
    802000e6:	94ca                	add	s1,s1,s2
    802000e8:	0134b023          	sd	s3,0(s1)
}
    802000ec:	70a2                	ld	ra,40(sp)
    802000ee:	7402                	ld	s0,32(sp)
    802000f0:	64e2                	ld	s1,24(sp)
    802000f2:	6942                	ld	s2,16(sp)
    802000f4:	69a2                	ld	s3,8(sp)
    802000f6:	6a02                	ld	s4,0(sp)
    802000f8:	6145                	addi	sp,sp,48
    802000fa:	8082                	ret
		panic("queue shouldn't be overflow");
    802000fc:	00002097          	auipc	ra,0x2
    80200100:	0ea080e7          	jalr	234(ra) # 802021e6 <threadid>
    80200104:	86aa                	mv	a3,a0
    80200106:	47bd                	li	a5,15
    80200108:	00004717          	auipc	a4,0x4
    8020010c:	ef870713          	addi	a4,a4,-264 # 80204000 <e_text>
    80200110:	00004617          	auipc	a2,0x4
    80200114:	f0060613          	addi	a2,a2,-256 # 80204010 <e_text+0x10>
    80200118:	45fd                	li	a1,31
    8020011a:	00004517          	auipc	a0,0x4
    8020011e:	efe50513          	addi	a0,a0,-258 # 80204018 <e_text+0x18>
    80200122:	00003097          	auipc	ra,0x3
    80200126:	848080e7          	jalr	-1976(ra) # 8020296a <printf>
    8020012a:	00002097          	auipc	ra,0x2
    8020012e:	08e080e7          	jalr	142(ra) # 802021b8 <shutdown>
	if (q->empty) {
    80200132:	6785                	lui	a5,0x1
    80200134:	97ca                	add	a5,a5,s2
    80200136:	479c                	lw	a5,8(a5)
    80200138:	df89                	beqz	a5,80200052 <push_queue+0x2a>
		q->empty = 0;
    8020013a:	6705                	lui	a4,0x1
    8020013c:	974a                	add	a4,a4,s2
    8020013e:	00072423          	sw	zero,8(a4) # 1008 <_entry-0x801feff8>
		q->data[q->tail] = value;
    80200142:	435c                	lw	a5,4(a4)
    80200144:	00279693          	slli	a3,a5,0x2
    80200148:	96ca                	add	a3,a3,s2
    8020014a:	0146a023          	sw	s4,0(a3)
		q->stride[q->tail] = stride;
    8020014e:	20278693          	addi	a3,a5,514 # 1202 <_entry-0x801fedfe>
    80200152:	068e                	slli	a3,a3,0x3
    80200154:	9936                	add	s2,s2,a3
    80200156:	01393023          	sd	s3,0(s2)
		q->tail = (q->tail + 1) % NPROC;
    8020015a:	2785                	addiw	a5,a5,1
    8020015c:	41f7d69b          	sraiw	a3,a5,0x1f
    80200160:	0176d69b          	srliw	a3,a3,0x17
    80200164:	9fb5                	addw	a5,a5,a3
    80200166:	1ff7f793          	andi	a5,a5,511
    8020016a:	9f95                	subw	a5,a5,a3
    8020016c:	c35c                	sw	a5,4(a4)
		return;
    8020016e:	bfbd                	j	802000ec <push_queue+0xc4>
	for (i = q->front; i <= q->tail; ++i) {
    80200170:	84b2                	mv	s1,a2
    80200172:	b711                	j	80200076 <push_queue+0x4e>
		panic("queue shouldn't be overflow");
    80200174:	00002097          	auipc	ra,0x2
    80200178:	072080e7          	jalr	114(ra) # 802021e6 <threadid>
    8020017c:	86aa                	mv	a3,a0
    8020017e:	02300793          	li	a5,35
    80200182:	00004717          	auipc	a4,0x4
    80200186:	e7e70713          	addi	a4,a4,-386 # 80204000 <e_text>
    8020018a:	00004617          	auipc	a2,0x4
    8020018e:	e8660613          	addi	a2,a2,-378 # 80204010 <e_text+0x10>
    80200192:	45fd                	li	a1,31
    80200194:	00004517          	auipc	a0,0x4
    80200198:	e8450513          	addi	a0,a0,-380 # 80204018 <e_text+0x18>
    8020019c:	00002097          	auipc	ra,0x2
    802001a0:	7ce080e7          	jalr	1998(ra) # 8020296a <printf>
    802001a4:	00002097          	auipc	ra,0x2
    802001a8:	014080e7          	jalr	20(ra) # 802021b8 <shutdown>
    802001ac:	b5ed                	j	80200096 <push_queue+0x6e>

00000000802001ae <pop_queue>:

int
pop_queue(struct queue *q)
{
    802001ae:	1141                	addi	sp,sp,-16
    802001b0:	e422                	sd	s0,8(sp)
    802001b2:	0800                	addi	s0,sp,16
	if (q->empty)
    802001b4:	6785                	lui	a5,0x1
    802001b6:	97aa                	add	a5,a5,a0
    802001b8:	479c                	lw	a5,8(a5)
    802001ba:	ef95                	bnez	a5,802001f6 <pop_queue+0x48>
		return -1;
	int value = q->data[q->front];
    802001bc:	6605                	lui	a2,0x1
    802001be:	962a                	add	a2,a2,a0
    802001c0:	4218                	lw	a4,0(a2)
    802001c2:	00271793          	slli	a5,a4,0x2
    802001c6:	97aa                	add	a5,a5,a0
    802001c8:	4388                	lw	a0,0(a5)
	q->front = (q->front + 1) % NPROC;
    802001ca:	2705                	addiw	a4,a4,1
    802001cc:	41f7579b          	sraiw	a5,a4,0x1f
    802001d0:	0177d59b          	srliw	a1,a5,0x17
    802001d4:	00b707bb          	addw	a5,a4,a1
    802001d8:	1ff7f793          	andi	a5,a5,511
    802001dc:	9f8d                	subw	a5,a5,a1
    802001de:	0007871b          	sext.w	a4,a5
    802001e2:	c21c                	sw	a5,0(a2)
	if (q->front == q->tail)
    802001e4:	425c                	lw	a5,4(a2)
    802001e6:	00e78563          	beq	a5,a4,802001f0 <pop_queue+0x42>
		q->empty = 1;
	return value;
}
    802001ea:	6422                	ld	s0,8(sp)
    802001ec:	0141                	addi	sp,sp,16
    802001ee:	8082                	ret
		q->empty = 1;
    802001f0:	4785                	li	a5,1
    802001f2:	c61c                	sw	a5,8(a2)
    802001f4:	bfdd                	j	802001ea <pop_queue+0x3c>
		return -1;
    802001f6:	557d                	li	a0,-1
    802001f8:	bfcd                	j	802001ea <pop_queue+0x3c>

00000000802001fa <loader_init>:
char names[MAX_APP_NUM][MAX_STR_LEN];

// Get user progs' infomation through pre-defined symbol in `link_app.S`
void
loader_init()
{
    802001fa:	7139                	addi	sp,sp,-64
    802001fc:	fc06                	sd	ra,56(sp)
    802001fe:	f822                	sd	s0,48(sp)
    80200200:	f426                	sd	s1,40(sp)
    80200202:	f04a                	sd	s2,32(sp)
    80200204:	ec4e                	sd	s3,24(sp)
    80200206:	e852                	sd	s4,16(sp)
    80200208:	e456                	sd	s5,8(sp)
    8020020a:	e05a                	sd	s6,0(sp)
    8020020c:	0080                	addi	s0,sp,64
	char *s;
	app_info_ptr = (uint64 *)_app_num;
	app_num = *app_info_ptr;
    8020020e:	00497497          	auipc	s1,0x497
    80200212:	dfa48493          	addi	s1,s1,-518 # 80697008 <app_num>
    80200216:	00005697          	auipc	a3,0x5
    8020021a:	dea68693          	addi	a3,a3,-534 # 80205000 <_app_num>
    8020021e:	0006c783          	lbu	a5,0(a3)
    80200222:	0016c703          	lbu	a4,1(a3)
    80200226:	0722                	slli	a4,a4,0x8
    80200228:	8f5d                	or	a4,a4,a5
    8020022a:	0026c783          	lbu	a5,2(a3)
    8020022e:	07c2                	slli	a5,a5,0x10
    80200230:	8f5d                	or	a4,a4,a5
    80200232:	0036c783          	lbu	a5,3(a3)
    80200236:	07e2                	slli	a5,a5,0x18
    80200238:	8fd9                	or	a5,a5,a4
    8020023a:	c09c                	sw	a5,0(s1)
	app_info_ptr++;
    8020023c:	00005797          	auipc	a5,0x5
    80200240:	dcc78793          	addi	a5,a5,-564 # 80205008 <_app_num+0x8>
    80200244:	00497717          	auipc	a4,0x497
    80200248:	daf73e23          	sd	a5,-580(a4) # 80697000 <app_info_ptr>
	s = _app_names;
	printf("app list:\n");
    8020024c:	00004517          	auipc	a0,0x4
    80200250:	e0450513          	addi	a0,a0,-508 # 80204050 <e_text+0x50>
    80200254:	00002097          	auipc	ra,0x2
    80200258:	716080e7          	jalr	1814(ra) # 8020296a <printf>
	for (int i = 0; i < app_num; ++i) {
    8020025c:	409c                	lw	a5,0(s1)
    8020025e:	04f05c63          	blez	a5,802002b6 <loader_init+0xbc>
    80200262:	00066997          	auipc	s3,0x66
    80200266:	d9e98993          	addi	s3,s3,-610 # 80266000 <names>
    8020026a:	4a01                	li	s4,0
	s = _app_names;
    8020026c:	00005917          	auipc	s2,0x5
    80200270:	edc90913          	addi	s2,s2,-292 # 80205148 <_app_names>
		int len = strlen(s);
		strncpy(names[i], (const char *)s, len);
		s += len + 1;
		printf("%s\n", names[i]);
    80200274:	00004b17          	auipc	s6,0x4
    80200278:	decb0b13          	addi	s6,s6,-532 # 80204060 <e_text+0x60>
	for (int i = 0; i < app_num; ++i) {
    8020027c:	8aa6                	mv	s5,s1
		int len = strlen(s);
    8020027e:	854a                	mv	a0,s2
    80200280:	00000097          	auipc	ra,0x0
    80200284:	5e8080e7          	jalr	1512(ra) # 80200868 <strlen>
    80200288:	84aa                	mv	s1,a0
		strncpy(names[i], (const char *)s, len);
    8020028a:	862a                	mv	a2,a0
    8020028c:	85ca                	mv	a1,s2
    8020028e:	854e                	mv	a0,s3
    80200290:	00000097          	auipc	ra,0x0
    80200294:	568080e7          	jalr	1384(ra) # 802007f8 <strncpy>
		s += len + 1;
    80200298:	0485                	addi	s1,s1,1
    8020029a:	9926                	add	s2,s2,s1
		printf("%s\n", names[i]);
    8020029c:	85ce                	mv	a1,s3
    8020029e:	855a                	mv	a0,s6
    802002a0:	00002097          	auipc	ra,0x2
    802002a4:	6ca080e7          	jalr	1738(ra) # 8020296a <printf>
	for (int i = 0; i < app_num; ++i) {
    802002a8:	2a05                	addiw	s4,s4,1
    802002aa:	0c898993          	addi	s3,s3,200
    802002ae:	000aa783          	lw	a5,0(s5)
    802002b2:	fcfa46e3          	blt	s4,a5,8020027e <loader_init+0x84>
	}
}
    802002b6:	70e2                	ld	ra,56(sp)
    802002b8:	7442                	ld	s0,48(sp)
    802002ba:	74a2                	ld	s1,40(sp)
    802002bc:	7902                	ld	s2,32(sp)
    802002be:	69e2                	ld	s3,24(sp)
    802002c0:	6a42                	ld	s4,16(sp)
    802002c2:	6aa2                	ld	s5,8(sp)
    802002c4:	6b02                	ld	s6,0(sp)
    802002c6:	6121                	addi	sp,sp,64
    802002c8:	8082                	ret

00000000802002ca <get_id_by_name>:

int
get_id_by_name(char *name)
{
    802002ca:	7179                	addi	sp,sp,-48
    802002cc:	f406                	sd	ra,40(sp)
    802002ce:	f022                	sd	s0,32(sp)
    802002d0:	ec26                	sd	s1,24(sp)
    802002d2:	e84a                	sd	s2,16(sp)
    802002d4:	e44e                	sd	s3,8(sp)
    802002d6:	e052                	sd	s4,0(sp)
    802002d8:	1800                	addi	s0,sp,48
    802002da:	89aa                	mv	s3,a0
	for (int i = 0; i < app_num; ++i) {
    802002dc:	00497797          	auipc	a5,0x497
    802002e0:	d2c7a783          	lw	a5,-724(a5) # 80697008 <app_num>
    802002e4:	02f05b63          	blez	a5,8020031a <get_id_by_name+0x50>
    802002e8:	00066917          	auipc	s2,0x66
    802002ec:	d1890913          	addi	s2,s2,-744 # 80266000 <names>
    802002f0:	4481                	li	s1,0
    802002f2:	00497a17          	auipc	s4,0x497
    802002f6:	d16a0a13          	addi	s4,s4,-746 # 80697008 <app_num>
		if (strncmp(name, names[i], 100) == 0)
    802002fa:	06400613          	li	a2,100
    802002fe:	85ca                	mv	a1,s2
    80200300:	854e                	mv	a0,s3
    80200302:	00000097          	auipc	ra,0x0
    80200306:	4ba080e7          	jalr	1210(ra) # 802007bc <strncmp>
    8020030a:	cd19                	beqz	a0,80200328 <get_id_by_name+0x5e>
	for (int i = 0; i < app_num; ++i) {
    8020030c:	2485                	addiw	s1,s1,1
    8020030e:	0c890913          	addi	s2,s2,200
    80200312:	000a2783          	lw	a5,0(s4)
    80200316:	fef4c2e3          	blt	s1,a5,802002fa <get_id_by_name+0x30>
			return i;
	}
	warnf("Cannot find such app %s", name);
    8020031a:	85ce                	mv	a1,s3
    8020031c:	4501                	li	a0,0
    8020031e:	00000097          	auipc	ra,0x0
    80200322:	574080e7          	jalr	1396(ra) # 80200892 <dummy>
	return -1;
    80200326:	54fd                	li	s1,-1
}
    80200328:	8526                	mv	a0,s1
    8020032a:	70a2                	ld	ra,40(sp)
    8020032c:	7402                	ld	s0,32(sp)
    8020032e:	64e2                	ld	s1,24(sp)
    80200330:	6942                	ld	s2,16(sp)
    80200332:	69a2                	ld	s3,8(sp)
    80200334:	6a02                	ld	s4,0(sp)
    80200336:	6145                	addi	sp,sp,48
    80200338:	8082                	ret

000000008020033a <bin_loader>:

int
bin_loader(uint64 start, uint64 end, struct proc *p)
{
    8020033a:	7119                	addi	sp,sp,-128
    8020033c:	fc86                	sd	ra,120(sp)
    8020033e:	f8a2                	sd	s0,112(sp)
    80200340:	f4a6                	sd	s1,104(sp)
    80200342:	f0ca                	sd	s2,96(sp)
    80200344:	ecce                	sd	s3,88(sp)
    80200346:	e8d2                	sd	s4,80(sp)
    80200348:	e4d6                	sd	s5,72(sp)
    8020034a:	e0da                	sd	s6,64(sp)
    8020034c:	fc5e                	sd	s7,56(sp)
    8020034e:	f862                	sd	s8,48(sp)
    80200350:	f466                	sd	s9,40(sp)
    80200352:	f06a                	sd	s10,32(sp)
    80200354:	ec6e                	sd	s11,24(sp)
    80200356:	0100                	addi	s0,sp,128
    80200358:	8caa                	mv	s9,a0
    8020035a:	8c2e                	mv	s8,a1
    8020035c:	8a32                	mv	s4,a2
	if (p == NULL || p->state == UNUSED)
    8020035e:	c219                	beqz	a2,80200364 <bin_loader+0x2a>
    80200360:	421c                	lw	a5,0(a2)
    80200362:	ef8d                	bnez	a5,8020039c <bin_loader+0x62>
		panic("...");
    80200364:	00002097          	auipc	ra,0x2
    80200368:	e82080e7          	jalr	-382(ra) # 802021e6 <threadid>
    8020036c:	86aa                	mv	a3,a0
    8020036e:	02c00793          	li	a5,44
    80200372:	00004717          	auipc	a4,0x4
    80200376:	cf670713          	addi	a4,a4,-778 # 80204068 <e_text+0x68>
    8020037a:	00004617          	auipc	a2,0x4
    8020037e:	c9660613          	addi	a2,a2,-874 # 80204010 <e_text+0x10>
    80200382:	45fd                	li	a1,31
    80200384:	00004517          	auipc	a0,0x4
    80200388:	cf450513          	addi	a0,a0,-780 # 80204078 <e_text+0x78>
    8020038c:	00002097          	auipc	ra,0x2
    80200390:	5de080e7          	jalr	1502(ra) # 8020296a <printf>
    80200394:	00002097          	auipc	ra,0x2
    80200398:	e24080e7          	jalr	-476(ra) # 802021b8 <shutdown>
	void *page;
	uint64 pa_start = PGROUNDDOWN(start);
    8020039c:	77fd                	lui	a5,0xfffff
    8020039e:	00fcf9b3          	and	s3,s9,a5
	uint64 pa_end = PGROUNDUP(end);
    802003a2:	6b05                	lui	s6,0x1
    802003a4:	1b7d                	addi	s6,s6,-1
    802003a6:	9b62                	add	s6,s6,s8
    802003a8:	00fb7b33          	and	s6,s6,a5
	uint64 length = pa_end - pa_start;
    802003ac:	6789                	lui	a5,0x2
    802003ae:	97da                	add	a5,a5,s6
    802003b0:	f8f43023          	sd	a5,-128(s0)
	uint64 va_start = BASE_ADDRESS;
	uint64 va_end = BASE_ADDRESS + length;
	for (uint64 va = va_start, pa = pa_start; pa < pa_end;
    802003b4:	1169f563          	bgeu	s3,s6,802004be <bin_loader+0x184>
    802003b8:	84ce                	mv	s1,s3
    802003ba:	6a85                	lui	s5,0x1
    802003bc:	413a8d33          	sub	s10,s5,s3
	     va += PGSIZE, pa += PGSIZE) {
		page = kalloc();
		if (page == 0) {
			panic("...");
    802003c0:	00004d97          	auipc	s11,0x4
    802003c4:	ca8d8d93          	addi	s11,s11,-856 # 80204068 <e_text+0x68>
		}
		memmove(page, (const void *)pa, PGSIZE);
		if (pa < start) {
			memset(page, 0, start - va);
		} else if (pa + PAGE_SIZE > end) {
			memset(page + (end - pa), 0, PAGE_SIZE - (end - pa));
    802003c8:	6785                	lui	a5,0x1
    802003ca:	418787bb          	subw	a5,a5,s8
    802003ce:	f8f42623          	sw	a5,-116(s0)
			memset(page, 0, start - va);
    802003d2:	77fd                	lui	a5,0xfffff
    802003d4:	019787bb          	addw	a5,a5,s9
    802003d8:	013787bb          	addw	a5,a5,s3
    802003dc:	f8f42423          	sw	a5,-120(s0)
    802003e0:	a09d                	j	80200446 <bin_loader+0x10c>
			panic("...");
    802003e2:	00002097          	auipc	ra,0x2
    802003e6:	e04080e7          	jalr	-508(ra) # 802021e6 <threadid>
    802003ea:	86aa                	mv	a3,a0
    802003ec:	03700793          	li	a5,55
    802003f0:	876e                	mv	a4,s11
    802003f2:	00004617          	auipc	a2,0x4
    802003f6:	c1e60613          	addi	a2,a2,-994 # 80204010 <e_text+0x10>
    802003fa:	45fd                	li	a1,31
    802003fc:	00004517          	auipc	a0,0x4
    80200400:	c7c50513          	addi	a0,a0,-900 # 80204078 <e_text+0x78>
    80200404:	00002097          	auipc	ra,0x2
    80200408:	566080e7          	jalr	1382(ra) # 8020296a <printf>
    8020040c:	00002097          	auipc	ra,0x2
    80200410:	dac080e7          	jalr	-596(ra) # 802021b8 <shutdown>
    80200414:	a089                	j	80200456 <bin_loader+0x11c>
			memset(page, 0, start - va);
    80200416:	f8842783          	lw	a5,-120(s0)
    8020041a:	4097863b          	subw	a2,a5,s1
    8020041e:	4581                	li	a1,0
    80200420:	854a                	mv	a0,s2
    80200422:	00000097          	auipc	ra,0x0
    80200426:	2c2080e7          	jalr	706(ra) # 802006e4 <memset>
		}
		if (mappages(p->pagetable, va, PGSIZE, (uint64)page,
    8020042a:	4779                	li	a4,30
    8020042c:	86ca                	mv	a3,s2
    8020042e:	8656                	mv	a2,s5
    80200430:	85de                	mv	a1,s7
    80200432:	008a3503          	ld	a0,8(s4)
    80200436:	00001097          	auipc	ra,0x1
    8020043a:	200080e7          	jalr	512(ra) # 80201636 <mappages>
    8020043e:	e531                	bnez	a0,8020048a <bin_loader+0x150>
	     va += PGSIZE, pa += PGSIZE) {
    80200440:	94d6                	add	s1,s1,s5
	for (uint64 va = va_start, pa = pa_start; pa < pa_end;
    80200442:	0764fe63          	bgeu	s1,s6,802004be <bin_loader+0x184>
    80200446:	009d0bb3          	add	s7,s10,s1
		page = kalloc();
    8020044a:	00002097          	auipc	ra,0x2
    8020044e:	d06080e7          	jalr	-762(ra) # 80202150 <kalloc>
    80200452:	892a                	mv	s2,a0
		if (page == 0) {
    80200454:	d559                	beqz	a0,802003e2 <bin_loader+0xa8>
		memmove(page, (const void *)pa, PGSIZE);
    80200456:	8656                	mv	a2,s5
    80200458:	85a6                	mv	a1,s1
    8020045a:	854a                	mv	a0,s2
    8020045c:	00000097          	auipc	ra,0x0
    80200460:	2e4080e7          	jalr	740(ra) # 80200740 <memmove>
		if (pa < start) {
    80200464:	fb94e9e3          	bltu	s1,s9,80200416 <bin_loader+0xdc>
		} else if (pa + PAGE_SIZE > end) {
    80200468:	015487b3          	add	a5,s1,s5
    8020046c:	fafc7fe3          	bgeu	s8,a5,8020042a <bin_loader+0xf0>
			memset(page + (end - pa), 0, PAGE_SIZE - (end - pa));
    80200470:	409c0533          	sub	a0,s8,s1
    80200474:	f8c42783          	lw	a5,-116(s0)
    80200478:	0097863b          	addw	a2,a5,s1
    8020047c:	4581                	li	a1,0
    8020047e:	954a                	add	a0,a0,s2
    80200480:	00000097          	auipc	ra,0x0
    80200484:	264080e7          	jalr	612(ra) # 802006e4 <memset>
    80200488:	b74d                	j	8020042a <bin_loader+0xf0>
			     PTE_U | PTE_R | PTE_W | PTE_X) != 0)
			panic("...");
    8020048a:	00002097          	auipc	ra,0x2
    8020048e:	d5c080e7          	jalr	-676(ra) # 802021e6 <threadid>
    80200492:	86aa                	mv	a3,a0
    80200494:	04100793          	li	a5,65
    80200498:	876e                	mv	a4,s11
    8020049a:	00004617          	auipc	a2,0x4
    8020049e:	b7660613          	addi	a2,a2,-1162 # 80204010 <e_text+0x10>
    802004a2:	45fd                	li	a1,31
    802004a4:	00004517          	auipc	a0,0x4
    802004a8:	bd450513          	addi	a0,a0,-1068 # 80204078 <e_text+0x78>
    802004ac:	00002097          	auipc	ra,0x2
    802004b0:	4be080e7          	jalr	1214(ra) # 8020296a <printf>
    802004b4:	00002097          	auipc	ra,0x2
    802004b8:	d04080e7          	jalr	-764(ra) # 802021b8 <shutdown>
    802004bc:	b751                	j	80200440 <bin_loader+0x106>
	}
	// map ustack
	p->ustack = va_end + PAGE_SIZE;
    802004be:	f8043783          	ld	a5,-128(s0)
    802004c2:	413789b3          	sub	s3,a5,s3
    802004c6:	013a3823          	sd	s3,16(s4)
	for (uint64 va = p->ustack; va < p->ustack + USTACK_SIZE;
    802004ca:	6785                	lui	a5,0x1
    802004cc:	97ce                	add	a5,a5,s3
    802004ce:	0af9f663          	bgeu	s3,a5,8020057a <bin_loader+0x240>
	     va += PGSIZE) {
		page = kalloc();
		if (page == 0) {
			panic("...");
    802004d2:	00004b17          	auipc	s6,0x4
    802004d6:	b96b0b13          	addi	s6,s6,-1130 # 80204068 <e_text+0x68>
    802004da:	00004a97          	auipc	s5,0x4
    802004de:	b36a8a93          	addi	s5,s5,-1226 # 80204010 <e_text+0x10>
    802004e2:	00004917          	auipc	s2,0x4
    802004e6:	b9690913          	addi	s2,s2,-1130 # 80204078 <e_text+0x78>
    802004ea:	a825                	j	80200522 <bin_loader+0x1e8>
    802004ec:	00002097          	auipc	ra,0x2
    802004f0:	cfa080e7          	jalr	-774(ra) # 802021e6 <threadid>
    802004f4:	86aa                	mv	a3,a0
    802004f6:	04900793          	li	a5,73
    802004fa:	875a                	mv	a4,s6
    802004fc:	8656                	mv	a2,s5
    802004fe:	45fd                	li	a1,31
    80200500:	854a                	mv	a0,s2
    80200502:	00002097          	auipc	ra,0x2
    80200506:	468080e7          	jalr	1128(ra) # 8020296a <printf>
    8020050a:	00002097          	auipc	ra,0x2
    8020050e:	cae080e7          	jalr	-850(ra) # 802021b8 <shutdown>
    80200512:	a831                	j	8020052e <bin_loader+0x1f4>
	     va += PGSIZE) {
    80200514:	6785                	lui	a5,0x1
    80200516:	99be                	add	s3,s3,a5
	for (uint64 va = p->ustack; va < p->ustack + USTACK_SIZE;
    80200518:	010a3703          	ld	a4,16(s4)
    8020051c:	97ba                	add	a5,a5,a4
    8020051e:	04f9fe63          	bgeu	s3,a5,8020057a <bin_loader+0x240>
		page = kalloc();
    80200522:	00002097          	auipc	ra,0x2
    80200526:	c2e080e7          	jalr	-978(ra) # 80202150 <kalloc>
    8020052a:	84aa                	mv	s1,a0
		if (page == 0) {
    8020052c:	d161                	beqz	a0,802004ec <bin_loader+0x1b2>
		}
		memset(page, 0, PGSIZE);
    8020052e:	6605                	lui	a2,0x1
    80200530:	4581                	li	a1,0
    80200532:	8526                	mv	a0,s1
    80200534:	00000097          	auipc	ra,0x0
    80200538:	1b0080e7          	jalr	432(ra) # 802006e4 <memset>
		if (mappages(p->pagetable, va, PGSIZE, (uint64)page,
    8020053c:	4759                	li	a4,22
    8020053e:	86a6                	mv	a3,s1
    80200540:	6605                	lui	a2,0x1
    80200542:	85ce                	mv	a1,s3
    80200544:	008a3503          	ld	a0,8(s4)
    80200548:	00001097          	auipc	ra,0x1
    8020054c:	0ee080e7          	jalr	238(ra) # 80201636 <mappages>
    80200550:	d171                	beqz	a0,80200514 <bin_loader+0x1da>
			     PTE_U | PTE_R | PTE_W) != 0)
			panic("...");
    80200552:	00002097          	auipc	ra,0x2
    80200556:	c94080e7          	jalr	-876(ra) # 802021e6 <threadid>
    8020055a:	86aa                	mv	a3,a0
    8020055c:	04e00793          	li	a5,78
    80200560:	875a                	mv	a4,s6
    80200562:	8656                	mv	a2,s5
    80200564:	45fd                	li	a1,31
    80200566:	854a                	mv	a0,s2
    80200568:	00002097          	auipc	ra,0x2
    8020056c:	402080e7          	jalr	1026(ra) # 8020296a <printf>
    80200570:	00002097          	auipc	ra,0x2
    80200574:	c48080e7          	jalr	-952(ra) # 802021b8 <shutdown>
    80200578:	bf71                	j	80200514 <bin_loader+0x1da>
	}
	p->trapframe->sp = p->ustack + USTACK_SIZE;
    8020057a:	020a3703          	ld	a4,32(s4)
    8020057e:	fb1c                	sd	a5,48(a4)
	p->trapframe->epc = va_start;
    80200580:	020a3783          	ld	a5,32(s4)
    80200584:	6685                	lui	a3,0x1
    80200586:	ef94                	sd	a3,24(a5)
	p->max_page = PGROUNDUP(p->ustack + USTACK_SIZE - 1) / PAGE_SIZE;
    80200588:	010a3703          	ld	a4,16(s4)
    8020058c:	6789                	lui	a5,0x2
    8020058e:	17f9                	addi	a5,a5,-2
    80200590:	97ba                	add	a5,a5,a4
    80200592:	83b1                	srli	a5,a5,0xc
    80200594:	08fa3c23          	sd	a5,152(s4)
	p->program_brk = p->ustack + USTACK_SIZE;
    80200598:	00d707b3          	add	a5,a4,a3
    8020059c:	14fa3423          	sd	a5,328(s4)
	p->heap_bottom = p->ustack + USTACK_SIZE;
    802005a0:	14fa3823          	sd	a5,336(s4)
	p->state = RUNNABLE;
    802005a4:	478d                	li	a5,3
    802005a6:	00fa2023          	sw	a5,0(s4)
	p->stride = 0;
    802005aa:	0a0a3423          	sd	zero,168(s4)
	p->prio = 16;
    802005ae:	47c1                	li	a5,16
    802005b0:	0afa3023          	sd	a5,160(s4)
	p->pass = BIG_STRIDE / p->prio;
    802005b4:	0ada3823          	sd	a3,176(s4)
	return 0;
}
    802005b8:	4501                	li	a0,0
    802005ba:	70e6                	ld	ra,120(sp)
    802005bc:	7446                	ld	s0,112(sp)
    802005be:	74a6                	ld	s1,104(sp)
    802005c0:	7906                	ld	s2,96(sp)
    802005c2:	69e6                	ld	s3,88(sp)
    802005c4:	6a46                	ld	s4,80(sp)
    802005c6:	6aa6                	ld	s5,72(sp)
    802005c8:	6b06                	ld	s6,64(sp)
    802005ca:	7be2                	ld	s7,56(sp)
    802005cc:	7c42                	ld	s8,48(sp)
    802005ce:	7ca2                	ld	s9,40(sp)
    802005d0:	7d02                	ld	s10,32(sp)
    802005d2:	6de2                	ld	s11,24(sp)
    802005d4:	6109                	addi	sp,sp,128
    802005d6:	8082                	ret

00000000802005d8 <loader>:

int
loader(int app_id, struct proc *p)
{
    802005d8:	1141                	addi	sp,sp,-16
    802005da:	e406                	sd	ra,8(sp)
    802005dc:	e022                	sd	s0,0(sp)
    802005de:	0800                	addi	s0,sp,16
    802005e0:	862e                	mv	a2,a1
	return bin_loader(app_info_ptr[app_id], app_info_ptr[app_id + 1], p);
    802005e2:	00351793          	slli	a5,a0,0x3
    802005e6:	00497517          	auipc	a0,0x497
    802005ea:	a1a53503          	ld	a0,-1510(a0) # 80697000 <app_info_ptr>
    802005ee:	953e                	add	a0,a0,a5
    802005f0:	650c                	ld	a1,8(a0)
    802005f2:	6108                	ld	a0,0(a0)
    802005f4:	00000097          	auipc	ra,0x0
    802005f8:	d46080e7          	jalr	-698(ra) # 8020033a <bin_loader>
}
    802005fc:	60a2                	ld	ra,8(sp)
    802005fe:	6402                	ld	s0,0(sp)
    80200600:	0141                	addi	sp,sp,16
    80200602:	8082                	ret

0000000080200604 <load_init_app>:

// load all apps and init the corresponding `proc` structure.
int
load_init_app()
{
    80200604:	1101                	addi	sp,sp,-32
    80200606:	ec06                	sd	ra,24(sp)
    80200608:	e822                	sd	s0,16(sp)
    8020060a:	e426                	sd	s1,8(sp)
    8020060c:	e04a                	sd	s2,0(sp)
    8020060e:	1000                	addi	s0,sp,32
	int id = get_id_by_name(INIT_PROC);
    80200610:	00005517          	auipc	a0,0x5
    80200614:	d0f50513          	addi	a0,a0,-753 # 8020531f <INIT_PROC>
    80200618:	00000097          	auipc	ra,0x0
    8020061c:	cb2080e7          	jalr	-846(ra) # 802002ca <get_id_by_name>
    80200620:	892a                	mv	s2,a0
	if (id < 0)
    80200622:	04054363          	bltz	a0,80200668 <load_init_app+0x64>
		panic("Cannpt find INIT_PROC %s", INIT_PROC);
	struct proc *p = allocproc();
    80200626:	00002097          	auipc	ra,0x2
    8020062a:	d42080e7          	jalr	-702(ra) # 80202368 <allocproc>
    8020062e:	84aa                	mv	s1,a0
	if (p == NULL) {
    80200630:	cd2d                	beqz	a0,802006aa <load_init_app+0xa6>
		panic("allocproc\n");
	}
	debugf("load init proc %s", INIT_PROC);
    80200632:	00005597          	auipc	a1,0x5
    80200636:	ced58593          	addi	a1,a1,-787 # 8020531f <INIT_PROC>
    8020063a:	4501                	li	a0,0
    8020063c:	00000097          	auipc	ra,0x0
    80200640:	256080e7          	jalr	598(ra) # 80200892 <dummy>
	loader(id, p);
    80200644:	85a6                	mv	a1,s1
    80200646:	854a                	mv	a0,s2
    80200648:	00000097          	auipc	ra,0x0
    8020064c:	f90080e7          	jalr	-112(ra) # 802005d8 <loader>
	add_task(p);
    80200650:	8526                	mv	a0,s1
    80200652:	00002097          	auipc	ra,0x2
    80200656:	cbc080e7          	jalr	-836(ra) # 8020230e <add_task>
	return 0;
}
    8020065a:	4501                	li	a0,0
    8020065c:	60e2                	ld	ra,24(sp)
    8020065e:	6442                	ld	s0,16(sp)
    80200660:	64a2                	ld	s1,8(sp)
    80200662:	6902                	ld	s2,0(sp)
    80200664:	6105                	addi	sp,sp,32
    80200666:	8082                	ret
		panic("Cannpt find INIT_PROC %s", INIT_PROC);
    80200668:	00002097          	auipc	ra,0x2
    8020066c:	b7e080e7          	jalr	-1154(ra) # 802021e6 <threadid>
    80200670:	86aa                	mv	a3,a0
    80200672:	00005817          	auipc	a6,0x5
    80200676:	cad80813          	addi	a6,a6,-851 # 8020531f <INIT_PROC>
    8020067a:	06800793          	li	a5,104
    8020067e:	00004717          	auipc	a4,0x4
    80200682:	9ea70713          	addi	a4,a4,-1558 # 80204068 <e_text+0x68>
    80200686:	00004617          	auipc	a2,0x4
    8020068a:	98a60613          	addi	a2,a2,-1654 # 80204010 <e_text+0x10>
    8020068e:	45fd                	li	a1,31
    80200690:	00004517          	auipc	a0,0x4
    80200694:	a0850513          	addi	a0,a0,-1528 # 80204098 <e_text+0x98>
    80200698:	00002097          	auipc	ra,0x2
    8020069c:	2d2080e7          	jalr	722(ra) # 8020296a <printf>
    802006a0:	00002097          	auipc	ra,0x2
    802006a4:	b18080e7          	jalr	-1256(ra) # 802021b8 <shutdown>
    802006a8:	bfbd                	j	80200626 <load_init_app+0x22>
		panic("allocproc\n");
    802006aa:	00002097          	auipc	ra,0x2
    802006ae:	b3c080e7          	jalr	-1220(ra) # 802021e6 <threadid>
    802006b2:	86aa                	mv	a3,a0
    802006b4:	06b00793          	li	a5,107
    802006b8:	00004717          	auipc	a4,0x4
    802006bc:	9b070713          	addi	a4,a4,-1616 # 80204068 <e_text+0x68>
    802006c0:	00004617          	auipc	a2,0x4
    802006c4:	95060613          	addi	a2,a2,-1712 # 80204010 <e_text+0x10>
    802006c8:	45fd                	li	a1,31
    802006ca:	00004517          	auipc	a0,0x4
    802006ce:	a0650513          	addi	a0,a0,-1530 # 802040d0 <e_text+0xd0>
    802006d2:	00002097          	auipc	ra,0x2
    802006d6:	298080e7          	jalr	664(ra) # 8020296a <printf>
    802006da:	00002097          	auipc	ra,0x2
    802006de:	ade080e7          	jalr	-1314(ra) # 802021b8 <shutdown>
    802006e2:	bf81                	j	80200632 <load_init_app+0x2e>

00000000802006e4 <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    802006e4:	1141                	addi	sp,sp,-16
    802006e6:	e422                	sd	s0,8(sp)
    802006e8:	0800                	addi	s0,sp,16
	char *cdst = (char *)dst;
	int i;
	for (i = 0; i < n; i++) {
    802006ea:	ca19                	beqz	a2,80200700 <memset+0x1c>
    802006ec:	87aa                	mv	a5,a0
    802006ee:	1602                	slli	a2,a2,0x20
    802006f0:	9201                	srli	a2,a2,0x20
    802006f2:	00a60733          	add	a4,a2,a0
		cdst[i] = c;
    802006f6:	00b78023          	sb	a1,0(a5) # 2000 <_entry-0x801fe000>
	for (i = 0; i < n; i++) {
    802006fa:	0785                	addi	a5,a5,1
    802006fc:	fee79de3          	bne	a5,a4,802006f6 <memset+0x12>
	}
	return dst;
}
    80200700:	6422                	ld	s0,8(sp)
    80200702:	0141                	addi	sp,sp,16
    80200704:	8082                	ret

0000000080200706 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    80200706:	1141                	addi	sp,sp,-16
    80200708:	e422                	sd	s0,8(sp)
    8020070a:	0800                	addi	s0,sp,16
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
    8020070c:	ca05                	beqz	a2,8020073c <memcmp+0x36>
    8020070e:	fff6069b          	addiw	a3,a2,-1
    80200712:	1682                	slli	a3,a3,0x20
    80200714:	9281                	srli	a3,a3,0x20
    80200716:	0685                	addi	a3,a3,1
    80200718:	96aa                	add	a3,a3,a0
		if (*s1 != *s2)
    8020071a:	00054783          	lbu	a5,0(a0)
    8020071e:	0005c703          	lbu	a4,0(a1)
    80200722:	00e79863          	bne	a5,a4,80200732 <memcmp+0x2c>
			return *s1 - *s2;
		s1++, s2++;
    80200726:	0505                	addi	a0,a0,1
    80200728:	0585                	addi	a1,a1,1
	while (n-- > 0) {
    8020072a:	fed518e3          	bne	a0,a3,8020071a <memcmp+0x14>
	}

	return 0;
    8020072e:	4501                	li	a0,0
    80200730:	a019                	j	80200736 <memcmp+0x30>
			return *s1 - *s2;
    80200732:	40e7853b          	subw	a0,a5,a4
}
    80200736:	6422                	ld	s0,8(sp)
    80200738:	0141                	addi	sp,sp,16
    8020073a:	8082                	ret
	return 0;
    8020073c:	4501                	li	a0,0
    8020073e:	bfe5                	j	80200736 <memcmp+0x30>

0000000080200740 <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    80200740:	1141                	addi	sp,sp,-16
    80200742:	e422                	sd	s0,8(sp)
    80200744:	0800                	addi	s0,sp,16
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
    80200746:	02a5e563          	bltu	a1,a0,80200770 <memmove+0x30>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
    8020074a:	fff6069b          	addiw	a3,a2,-1
    8020074e:	ce11                	beqz	a2,8020076a <memmove+0x2a>
    80200750:	1682                	slli	a3,a3,0x20
    80200752:	9281                	srli	a3,a3,0x20
    80200754:	0685                	addi	a3,a3,1
    80200756:	96ae                	add	a3,a3,a1
    80200758:	87aa                	mv	a5,a0
			*d++ = *s++;
    8020075a:	0585                	addi	a1,a1,1
    8020075c:	0785                	addi	a5,a5,1
    8020075e:	fff5c703          	lbu	a4,-1(a1)
    80200762:	fee78fa3          	sb	a4,-1(a5)
		while (n-- > 0)
    80200766:	fed59ae3          	bne	a1,a3,8020075a <memmove+0x1a>

	return dst;
}
    8020076a:	6422                	ld	s0,8(sp)
    8020076c:	0141                	addi	sp,sp,16
    8020076e:	8082                	ret
	if (s < d && s + n > d) {
    80200770:	02061713          	slli	a4,a2,0x20
    80200774:	9301                	srli	a4,a4,0x20
    80200776:	00e587b3          	add	a5,a1,a4
    8020077a:	fcf578e3          	bgeu	a0,a5,8020074a <memmove+0xa>
		d += n;
    8020077e:	972a                	add	a4,a4,a0
		while (n-- > 0)
    80200780:	fff6069b          	addiw	a3,a2,-1
    80200784:	d27d                	beqz	a2,8020076a <memmove+0x2a>
    80200786:	02069613          	slli	a2,a3,0x20
    8020078a:	9201                	srli	a2,a2,0x20
    8020078c:	fff64613          	not	a2,a2
    80200790:	963e                	add	a2,a2,a5
			*--d = *--s;
    80200792:	17fd                	addi	a5,a5,-1
    80200794:	177d                	addi	a4,a4,-1
    80200796:	0007c683          	lbu	a3,0(a5)
    8020079a:	00d70023          	sb	a3,0(a4)
		while (n-- > 0)
    8020079e:	fef61ae3          	bne	a2,a5,80200792 <memmove+0x52>
    802007a2:	b7e1                	j	8020076a <memmove+0x2a>

00000000802007a4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    802007a4:	1141                	addi	sp,sp,-16
    802007a6:	e406                	sd	ra,8(sp)
    802007a8:	e022                	sd	s0,0(sp)
    802007aa:	0800                	addi	s0,sp,16
	return memmove(dst, src, n);
    802007ac:	00000097          	auipc	ra,0x0
    802007b0:	f94080e7          	jalr	-108(ra) # 80200740 <memmove>
}
    802007b4:	60a2                	ld	ra,8(sp)
    802007b6:	6402                	ld	s0,0(sp)
    802007b8:	0141                	addi	sp,sp,16
    802007ba:	8082                	ret

00000000802007bc <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    802007bc:	1141                	addi	sp,sp,-16
    802007be:	e422                	sd	s0,8(sp)
    802007c0:	0800                	addi	s0,sp,16
	while (n > 0 && *p && *p == *q)
    802007c2:	ce11                	beqz	a2,802007de <strncmp+0x22>
    802007c4:	00054783          	lbu	a5,0(a0)
    802007c8:	cf89                	beqz	a5,802007e2 <strncmp+0x26>
    802007ca:	0005c703          	lbu	a4,0(a1)
    802007ce:	00f71a63          	bne	a4,a5,802007e2 <strncmp+0x26>
		n--, p++, q++;
    802007d2:	367d                	addiw	a2,a2,-1
    802007d4:	0505                	addi	a0,a0,1
    802007d6:	0585                	addi	a1,a1,1
	while (n > 0 && *p && *p == *q)
    802007d8:	f675                	bnez	a2,802007c4 <strncmp+0x8>
	if (n == 0)
		return 0;
    802007da:	4501                	li	a0,0
    802007dc:	a809                	j	802007ee <strncmp+0x32>
    802007de:	4501                	li	a0,0
    802007e0:	a039                	j	802007ee <strncmp+0x32>
	if (n == 0)
    802007e2:	ca09                	beqz	a2,802007f4 <strncmp+0x38>
	return (uchar)*p - (uchar)*q;
    802007e4:	00054503          	lbu	a0,0(a0)
    802007e8:	0005c783          	lbu	a5,0(a1)
    802007ec:	9d1d                	subw	a0,a0,a5
}
    802007ee:	6422                	ld	s0,8(sp)
    802007f0:	0141                	addi	sp,sp,16
    802007f2:	8082                	ret
		return 0;
    802007f4:	4501                	li	a0,0
    802007f6:	bfe5                	j	802007ee <strncmp+0x32>

00000000802007f8 <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    802007f8:	1141                	addi	sp,sp,-16
    802007fa:	e422                	sd	s0,8(sp)
    802007fc:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
    802007fe:	872a                	mv	a4,a0
    80200800:	8832                	mv	a6,a2
    80200802:	367d                	addiw	a2,a2,-1
    80200804:	01005963          	blez	a6,80200816 <strncpy+0x1e>
    80200808:	0705                	addi	a4,a4,1
    8020080a:	0005c783          	lbu	a5,0(a1)
    8020080e:	fef70fa3          	sb	a5,-1(a4)
    80200812:	0585                	addi	a1,a1,1
    80200814:	f7f5                	bnez	a5,80200800 <strncpy+0x8>
		;
	while (n-- > 0)
    80200816:	86ba                	mv	a3,a4
    80200818:	00c05c63          	blez	a2,80200830 <strncpy+0x38>
		*s++ = 0;
    8020081c:	0685                	addi	a3,a3,1
    8020081e:	fe068fa3          	sb	zero,-1(a3) # fff <_entry-0x801ff001>
	while (n-- > 0)
    80200822:	fff6c793          	not	a5,a3
    80200826:	9fb9                	addw	a5,a5,a4
    80200828:	010787bb          	addw	a5,a5,a6
    8020082c:	fef048e3          	bgtz	a5,8020081c <strncpy+0x24>
	return os;
}
    80200830:	6422                	ld	s0,8(sp)
    80200832:	0141                	addi	sp,sp,16
    80200834:	8082                	ret

0000000080200836 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    80200836:	1141                	addi	sp,sp,-16
    80200838:	e422                	sd	s0,8(sp)
    8020083a:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	if (n <= 0)
    8020083c:	02c05363          	blez	a2,80200862 <safestrcpy+0x2c>
    80200840:	fff6069b          	addiw	a3,a2,-1
    80200844:	1682                	slli	a3,a3,0x20
    80200846:	9281                	srli	a3,a3,0x20
    80200848:	96ae                	add	a3,a3,a1
    8020084a:	87aa                	mv	a5,a0
		return os;
	while (--n > 0 && (*s++ = *t++) != 0)
    8020084c:	00d58963          	beq	a1,a3,8020085e <safestrcpy+0x28>
    80200850:	0585                	addi	a1,a1,1
    80200852:	0785                	addi	a5,a5,1
    80200854:	fff5c703          	lbu	a4,-1(a1)
    80200858:	fee78fa3          	sb	a4,-1(a5)
    8020085c:	fb65                	bnez	a4,8020084c <safestrcpy+0x16>
		;
	*s = 0;
    8020085e:	00078023          	sb	zero,0(a5)
	return os;
}
    80200862:	6422                	ld	s0,8(sp)
    80200864:	0141                	addi	sp,sp,16
    80200866:	8082                	ret

0000000080200868 <strlen>:

int strlen(const char *s)
{
    80200868:	1141                	addi	sp,sp,-16
    8020086a:	e422                	sd	s0,8(sp)
    8020086c:	0800                	addi	s0,sp,16
	int n;

	for (n = 0; s[n]; n++)
    8020086e:	00054783          	lbu	a5,0(a0)
    80200872:	cf91                	beqz	a5,8020088e <strlen+0x26>
    80200874:	0505                	addi	a0,a0,1
    80200876:	87aa                	mv	a5,a0
    80200878:	4685                	li	a3,1
    8020087a:	9e89                	subw	a3,a3,a0
    8020087c:	00f6853b          	addw	a0,a3,a5
    80200880:	0785                	addi	a5,a5,1
    80200882:	fff7c703          	lbu	a4,-1(a5)
    80200886:	fb7d                	bnez	a4,8020087c <strlen+0x14>
		;
	return n;
}
    80200888:	6422                	ld	s0,8(sp)
    8020088a:	0141                	addi	sp,sp,16
    8020088c:	8082                	ret
	for (n = 0; s[n]; n++)
    8020088e:	4501                	li	a0,0
    80200890:	bfe5                	j	80200888 <strlen+0x20>

0000000080200892 <dummy>:

void dummy(int _, ...)
{
    80200892:	715d                	addi	sp,sp,-80
    80200894:	e422                	sd	s0,8(sp)
    80200896:	0800                	addi	s0,sp,16
    80200898:	e40c                	sd	a1,8(s0)
    8020089a:	e810                	sd	a2,16(s0)
    8020089c:	ec14                	sd	a3,24(s0)
    8020089e:	f018                	sd	a4,32(s0)
    802008a0:	f41c                	sd	a5,40(s0)
    802008a2:	03043823          	sd	a6,48(s0)
    802008a6:	03143c23          	sd	a7,56(s0)
    802008aa:	6422                	ld	s0,8(sp)
    802008ac:	6161                	addi	sp,sp,80
    802008ae:	8082                	ret

00000000802008b0 <kerneltrap>:
extern char trampoline[], uservec[];
extern char userret[];

void
kerneltrap()
{
    802008b0:	1141                	addi	sp,sp,-16
    802008b2:	e406                	sd	ra,8(sp)
    802008b4:	e022                	sd	s0,0(sp)
    802008b6:	0800                	addi	s0,sp,16
#define SSTATUS_UIE (1L << 0) // User Interrupt Enable

static inline uint64 r_sstatus()
{
	uint64 x;
	asm volatile("csrr %0, sstatus" : "=r"(x));
    802008b8:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) == 0)
    802008bc:	1007f793          	andi	a5,a5,256
    802008c0:	c3a1                	beqz	a5,80200900 <kerneltrap+0x50>
		panic("kerneltrap: not from supervisor mode");
	panic("trap from kerne");
    802008c2:	00002097          	auipc	ra,0x2
    802008c6:	924080e7          	jalr	-1756(ra) # 802021e6 <threadid>
    802008ca:	86aa                	mv	a3,a0
    802008cc:	47c5                	li	a5,17
    802008ce:	00004717          	auipc	a4,0x4
    802008d2:	82a70713          	addi	a4,a4,-2006 # 802040f8 <e_text+0xf8>
    802008d6:	00003617          	auipc	a2,0x3
    802008da:	73a60613          	addi	a2,a2,1850 # 80204010 <e_text+0x10>
    802008de:	45fd                	li	a1,31
    802008e0:	00004517          	auipc	a0,0x4
    802008e4:	86850513          	addi	a0,a0,-1944 # 80204148 <e_text+0x148>
    802008e8:	00002097          	auipc	ra,0x2
    802008ec:	082080e7          	jalr	130(ra) # 8020296a <printf>
    802008f0:	00002097          	auipc	ra,0x2
    802008f4:	8c8080e7          	jalr	-1848(ra) # 802021b8 <shutdown>
}
    802008f8:	60a2                	ld	ra,8(sp)
    802008fa:	6402                	ld	s0,0(sp)
    802008fc:	0141                	addi	sp,sp,16
    802008fe:	8082                	ret
		panic("kerneltrap: not from supervisor mode");
    80200900:	00002097          	auipc	ra,0x2
    80200904:	8e6080e7          	jalr	-1818(ra) # 802021e6 <threadid>
    80200908:	86aa                	mv	a3,a0
    8020090a:	47c1                	li	a5,16
    8020090c:	00003717          	auipc	a4,0x3
    80200910:	7ec70713          	addi	a4,a4,2028 # 802040f8 <e_text+0xf8>
    80200914:	00003617          	auipc	a2,0x3
    80200918:	6fc60613          	addi	a2,a2,1788 # 80204010 <e_text+0x10>
    8020091c:	45fd                	li	a1,31
    8020091e:	00003517          	auipc	a0,0x3
    80200922:	7ea50513          	addi	a0,a0,2026 # 80204108 <e_text+0x108>
    80200926:	00002097          	auipc	ra,0x2
    8020092a:	044080e7          	jalr	68(ra) # 8020296a <printf>
    8020092e:	00002097          	auipc	ra,0x2
    80200932:	88a080e7          	jalr	-1910(ra) # 802021b8 <shutdown>
    80200936:	b771                	j	802008c2 <kerneltrap+0x12>

0000000080200938 <set_usertrap>:

// set up to take exceptions and traps while in the kernel.
void
set_usertrap()
{
    80200938:	1141                	addi	sp,sp,-16
    8020093a:	e422                	sd	s0,8(sp)
    8020093c:	0800                	addi	s0,sp,16
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    8020093e:	04000737          	lui	a4,0x4000
    80200942:	00002797          	auipc	a5,0x2
    80200946:	6be78793          	addi	a5,a5,1726 # 80203000 <trampoline>
    8020094a:	00002697          	auipc	a3,0x2
    8020094e:	6b668693          	addi	a3,a3,1718 # 80203000 <trampoline>
    80200952:	8f95                	sub	a5,a5,a3
    80200954:	177d                	addi	a4,a4,-1
    80200956:	0732                	slli	a4,a4,0xc
    80200958:	97ba                	add	a5,a5,a4
    8020095a:	9bf1                	andi	a5,a5,-4

// Supervisor Trap-Vector Base Address
// low two bits are mode.
static inline void w_stvec(uint64 x)
{
	asm volatile("csrw stvec, %0" : : "r"(x));
    8020095c:	10579073          	csrw	stvec,a5
}
    80200960:	6422                	ld	s0,8(sp)
    80200962:	0141                	addi	sp,sp,16
    80200964:	8082                	ret

0000000080200966 <set_kerneltrap>:

void
set_kerneltrap()
{
    80200966:	1141                	addi	sp,sp,-16
    80200968:	e422                	sd	s0,8(sp)
    8020096a:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    8020096c:	00000797          	auipc	a5,0x0
    80200970:	f4478793          	addi	a5,a5,-188 # 802008b0 <kerneltrap>
    80200974:	9bf1                	andi	a5,a5,-4
    80200976:	10579073          	csrw	stvec,a5
}
    8020097a:	6422                	ld	s0,8(sp)
    8020097c:	0141                	addi	sp,sp,16
    8020097e:	8082                	ret

0000000080200980 <trap_init>:

// set up to take exceptions and traps while in the kernel.
void
trap_init()
{
    80200980:	1141                	addi	sp,sp,-16
    80200982:	e422                	sd	s0,8(sp)
    80200984:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80200986:	00000797          	auipc	a5,0x0
    8020098a:	f2a78793          	addi	a5,a5,-214 # 802008b0 <kerneltrap>
    8020098e:	9bf1                	andi	a5,a5,-4
    80200990:	10579073          	csrw	stvec,a5
	// intr_on();
	set_kerneltrap();
}
    80200994:	6422                	ld	s0,8(sp)
    80200996:	0141                	addi	sp,sp,16
    80200998:	8082                	ret

000000008020099a <unknown_trap>:

void
unknown_trap()
{
    8020099a:	1141                	addi	sp,sp,-16
    8020099c:	e406                	sd	ra,8(sp)
    8020099e:	e022                	sd	s0,0(sp)
    802009a0:	0800                	addi	s0,sp,16
	errorf("unknown trap: %p, stval = %p", r_scause(), r_stval());
    802009a2:	00002097          	auipc	ra,0x2
    802009a6:	844080e7          	jalr	-1980(ra) # 802021e6 <threadid>
    802009aa:	86aa                	mv	a3,a0

// Supervisor Trap Cause
static inline uint64 r_scause()
{
	uint64 x;
	asm volatile("csrr %0, scause" : "=r"(x));
    802009ac:	14202773          	csrr	a4,scause

// Supervisor Trap Value
static inline uint64 r_stval()
{
	uint64 x;
	asm volatile("csrr %0, stval" : "=r"(x));
    802009b0:	143027f3          	csrr	a5,stval
    802009b4:	00003617          	auipc	a2,0x3
    802009b8:	7c460613          	addi	a2,a2,1988 # 80204178 <e_text+0x178>
    802009bc:	45fd                	li	a1,31
    802009be:	00003517          	auipc	a0,0x3
    802009c2:	7c250513          	addi	a0,a0,1986 # 80204180 <e_text+0x180>
    802009c6:	00002097          	auipc	ra,0x2
    802009ca:	fa4080e7          	jalr	-92(ra) # 8020296a <printf>
	exit(-1);
    802009ce:	557d                	li	a0,-1
    802009d0:	00002097          	auipc	ra,0x2
    802009d4:	e22080e7          	jalr	-478(ra) # 802027f2 <exit>
}
    802009d8:	60a2                	ld	ra,8(sp)
    802009da:	6402                	ld	s0,0(sp)
    802009dc:	0141                	addi	sp,sp,16
    802009de:	8082                	ret

00000000802009e0 <usertrapret>:
//
// return to user space
//
void
usertrapret()
{
    802009e0:	7179                	addi	sp,sp,-48
    802009e2:	f406                	sd	ra,40(sp)
    802009e4:	f022                	sd	s0,32(sp)
    802009e6:	ec26                	sd	s1,24(sp)
    802009e8:	e84a                	sd	s2,16(sp)
    802009ea:	e44e                	sd	s3,8(sp)
    802009ec:	e052                	sd	s4,0(sp)
    802009ee:	1800                	addi	s0,sp,48
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    802009f0:	00002a17          	auipc	s4,0x2
    802009f4:	610a0a13          	addi	s4,s4,1552 # 80203000 <trampoline>
    802009f8:	00002797          	auipc	a5,0x2
    802009fc:	60878793          	addi	a5,a5,1544 # 80203000 <trampoline>
    80200a00:	414787b3          	sub	a5,a5,s4
    80200a04:	040004b7          	lui	s1,0x4000
    80200a08:	14fd                	addi	s1,s1,-1
    80200a0a:	04b2                	slli	s1,s1,0xc
    80200a0c:	97a6                	add	a5,a5,s1
    80200a0e:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80200a10:	10579073          	csrw	stvec,a5
	set_usertrap();
	struct trapframe *trapframe = curr_proc()->trapframe;
    80200a14:	00001097          	auipc	ra,0x1
    80200a18:	7e8080e7          	jalr	2024(ra) # 802021fc <curr_proc>
    80200a1c:	02053903          	ld	s2,32(a0)
	asm volatile("csrr %0, satp" : "=r"(x));
    80200a20:	180027f3          	csrr	a5,satp
	trapframe->kernel_satp = r_satp(); // kernel page table
    80200a24:	00f93023          	sd	a5,0(s2)
	trapframe->kernel_sp =
		curr_proc()->kstack + KSTACK_SIZE; // process's kernel stack
    80200a28:	00001097          	auipc	ra,0x1
    80200a2c:	7d4080e7          	jalr	2004(ra) # 802021fc <curr_proc>
    80200a30:	6d1c                	ld	a5,24(a0)
    80200a32:	6705                	lui	a4,0x1
    80200a34:	97ba                	add	a5,a5,a4
	trapframe->kernel_sp =
    80200a36:	00f93423          	sd	a5,8(s2)
	trapframe->kernel_trap = (uint64)usertrap;
    80200a3a:	00000797          	auipc	a5,0x0
    80200a3e:	07a78793          	addi	a5,a5,122 # 80200ab4 <usertrap>
    80200a42:	00f93823          	sd	a5,16(s2)
// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[].
static inline uint64 r_tp()
{
	uint64 x;
	asm volatile("mv %0, tp" : "=r"(x));
    80200a46:	8792                	mv	a5,tp
	trapframe->kernel_hartid = r_tp(); // unuesd
    80200a48:	02f93023          	sd	a5,32(s2)
	asm volatile("csrw sepc, %0" : : "r"(x));
    80200a4c:	01893783          	ld	a5,24(s2)
    80200a50:	14179073          	csrw	sepc,a5
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200a54:	100027f3          	csrr	a5,sstatus
	// set up the registers that trampoline.S's sret will use
	// to get to user space.

	// set S Previous Privilege mode to User.
	uint64 x = r_sstatus();
	x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80200a58:	eff7f793          	andi	a5,a5,-257
	x |= SSTATUS_SPIE; // enable interrupts in user mode
    80200a5c:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80200a60:	10079073          	csrw	sstatus,a5
	w_sstatus(x);

	// tell trampoline.S the user page table to switch to.
	uint64 satp = MAKE_SATP(curr_proc()->pagetable);
    80200a64:	00001097          	auipc	ra,0x1
    80200a68:	798080e7          	jalr	1944(ra) # 802021fc <curr_proc>
    80200a6c:	00853983          	ld	s3,8(a0)
    80200a70:	00c9d993          	srli	s3,s3,0xc
    80200a74:	57fd                	li	a5,-1
    80200a76:	17fe                	slli	a5,a5,0x3f
    80200a78:	00f9e9b3          	or	s3,s3,a5
	uint64 fn = TRAMPOLINE + (userret - trampoline);
	tracef("return to user @ %p", trapframe->epc);
    80200a7c:	01893583          	ld	a1,24(s2)
    80200a80:	4501                	li	a0,0
    80200a82:	00000097          	auipc	ra,0x0
    80200a86:	e10080e7          	jalr	-496(ra) # 80200892 <dummy>
	uint64 fn = TRAMPOLINE + (userret - trampoline);
    80200a8a:	00002797          	auipc	a5,0x2
    80200a8e:	60e78793          	addi	a5,a5,1550 # 80203098 <userret>
    80200a92:	414787b3          	sub	a5,a5,s4
    80200a96:	94be                	add	s1,s1,a5
	((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80200a98:	85ce                	mv	a1,s3
    80200a9a:	02000537          	lui	a0,0x2000
    80200a9e:	157d                	addi	a0,a0,-1
    80200aa0:	0536                	slli	a0,a0,0xd
    80200aa2:	9482                	jalr	s1
}
    80200aa4:	70a2                	ld	ra,40(sp)
    80200aa6:	7402                	ld	s0,32(sp)
    80200aa8:	64e2                	ld	s1,24(sp)
    80200aaa:	6942                	ld	s2,16(sp)
    80200aac:	69a2                	ld	s3,8(sp)
    80200aae:	6a02                	ld	s4,0(sp)
    80200ab0:	6145                	addi	sp,sp,48
    80200ab2:	8082                	ret

0000000080200ab4 <usertrap>:
{
    80200ab4:	7179                	addi	sp,sp,-48
    80200ab6:	f406                	sd	ra,40(sp)
    80200ab8:	f022                	sd	s0,32(sp)
    80200aba:	ec26                	sd	s1,24(sp)
    80200abc:	e84a                	sd	s2,16(sp)
    80200abe:	e44e                	sd	s3,8(sp)
    80200ac0:	e052                	sd	s4,0(sp)
    80200ac2:	1800                	addi	s0,sp,48
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80200ac4:	00000797          	auipc	a5,0x0
    80200ac8:	dec78793          	addi	a5,a5,-532 # 802008b0 <kerneltrap>
    80200acc:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80200ace:	10579073          	csrw	stvec,a5
	struct trapframe *trapframe = curr_proc()->trapframe;
    80200ad2:	00001097          	auipc	ra,0x1
    80200ad6:	72a080e7          	jalr	1834(ra) # 802021fc <curr_proc>
    80200ada:	02053903          	ld	s2,32(a0) # 2000020 <_entry-0x7e1fffe0>
	tracef("trap from user epc = %p", trapframe->epc);
    80200ade:	01893583          	ld	a1,24(s2)
    80200ae2:	4501                	li	a0,0
    80200ae4:	00000097          	auipc	ra,0x0
    80200ae8:	dae080e7          	jalr	-594(ra) # 80200892 <dummy>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200aec:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) != 0)
    80200af0:	1007f793          	andi	a5,a5,256
    80200af4:	e395                	bnez	a5,80200b18 <usertrap+0x64>
	asm volatile("csrr %0, scause" : "=r"(x));
    80200af6:	142024f3          	csrr	s1,scause
	if (cause & (1ULL << 63)) {
    80200afa:	0404cc63          	bltz	s1,80200b52 <usertrap+0x9e>
		switch (cause) {
    80200afe:	47bd                	li	a5,15
    80200b00:	1a97ef63          	bltu	a5,s1,80200cbe <usertrap+0x20a>
    80200b04:	00249713          	slli	a4,s1,0x2
    80200b08:	00003697          	auipc	a3,0x3
    80200b0c:	7fc68693          	addi	a3,a3,2044 # 80204304 <e_text+0x304>
    80200b10:	9736                	add	a4,a4,a3
    80200b12:	431c                	lw	a5,0(a4)
    80200b14:	97b6                	add	a5,a5,a3
    80200b16:	8782                	jr	a5
		panic("usertrap: not from user mode");
    80200b18:	00001097          	auipc	ra,0x1
    80200b1c:	6ce080e7          	jalr	1742(ra) # 802021e6 <threadid>
    80200b20:	86aa                	mv	a3,a0
    80200b22:	03b00793          	li	a5,59
    80200b26:	00003717          	auipc	a4,0x3
    80200b2a:	5d270713          	addi	a4,a4,1490 # 802040f8 <e_text+0xf8>
    80200b2e:	00003617          	auipc	a2,0x3
    80200b32:	4e260613          	addi	a2,a2,1250 # 80204010 <e_text+0x10>
    80200b36:	45fd                	li	a1,31
    80200b38:	00003517          	auipc	a0,0x3
    80200b3c:	67850513          	addi	a0,a0,1656 # 802041b0 <e_text+0x1b0>
    80200b40:	00002097          	auipc	ra,0x2
    80200b44:	e2a080e7          	jalr	-470(ra) # 8020296a <printf>
    80200b48:	00001097          	auipc	ra,0x1
    80200b4c:	670080e7          	jalr	1648(ra) # 802021b8 <shutdown>
    80200b50:	b75d                	j	80200af6 <usertrap+0x42>
		cause &= ~(1ULL << 63);
    80200b52:	0486                	slli	s1,s1,0x1
    80200b54:	8085                	srli	s1,s1,0x1
		switch (cause) {
    80200b56:	4795                	li	a5,5
    80200b58:	02f48263          	beq	s1,a5,80200b7c <usertrap+0xc8>
			unknown_trap();
    80200b5c:	00000097          	auipc	ra,0x0
    80200b60:	e3e080e7          	jalr	-450(ra) # 8020099a <unknown_trap>
	usertrapret();
    80200b64:	00000097          	auipc	ra,0x0
    80200b68:	e7c080e7          	jalr	-388(ra) # 802009e0 <usertrapret>
}
    80200b6c:	70a2                	ld	ra,40(sp)
    80200b6e:	7402                	ld	s0,32(sp)
    80200b70:	64e2                	ld	s1,24(sp)
    80200b72:	6942                	ld	s2,16(sp)
    80200b74:	69a2                	ld	s3,8(sp)
    80200b76:	6a02                	ld	s4,0(sp)
    80200b78:	6145                	addi	sp,sp,48
    80200b7a:	8082                	ret
			tracef("time interrupt!");
    80200b7c:	4501                	li	a0,0
    80200b7e:	00000097          	auipc	ra,0x0
    80200b82:	d14080e7          	jalr	-748(ra) # 80200892 <dummy>
			set_next_timer();
    80200b86:	00002097          	auipc	ra,0x2
    80200b8a:	fca080e7          	jalr	-54(ra) # 80202b50 <set_next_timer>
			yield();
    80200b8e:	00002097          	auipc	ra,0x2
    80200b92:	9a8080e7          	jalr	-1624(ra) # 80202536 <yield>
			break;
    80200b96:	b7f9                	j	80200b64 <usertrap+0xb0>
			trapframe->epc += 4;
    80200b98:	01893783          	ld	a5,24(s2)
    80200b9c:	0791                	addi	a5,a5,4
    80200b9e:	00f93c23          	sd	a5,24(s2)
			syscall();
    80200ba2:	00000097          	auipc	ra,0x0
    80200ba6:	73a080e7          	jalr	1850(ra) # 802012dc <syscall>
			break;
    80200baa:	bf6d                	j	80200b64 <usertrap+0xb0>
			errorf("pagefault at %p, instruction at: %p", r_stval(),
    80200bac:	00001097          	auipc	ra,0x1
    80200bb0:	63a080e7          	jalr	1594(ra) # 802021e6 <threadid>
    80200bb4:	86aa                	mv	a3,a0
	asm volatile("csrr %0, stval" : "=r"(x));
    80200bb6:	14302773          	csrr	a4,stval
    80200bba:	01893783          	ld	a5,24(s2)
    80200bbe:	00003617          	auipc	a2,0x3
    80200bc2:	5ba60613          	addi	a2,a2,1466 # 80204178 <e_text+0x178>
    80200bc6:	45fd                	li	a1,31
    80200bc8:	00003517          	auipc	a0,0x3
    80200bcc:	62050513          	addi	a0,a0,1568 # 802041e8 <e_text+0x1e8>
    80200bd0:	00002097          	auipc	ra,0x2
    80200bd4:	d9a080e7          	jalr	-614(ra) # 8020296a <printf>
			void *mem = kalloc();
    80200bd8:	00001097          	auipc	ra,0x1
    80200bdc:	578080e7          	jalr	1400(ra) # 80202150 <kalloc>
    80200be0:	89aa                	mv	s3,a0
    80200be2:	14302a73          	csrr	s4,stval
    80200be6:	143025f3          	csrr	a1,stval
			debugf("handling pagefault at %p, cause: %d", r_stval(),
    80200bea:	8626                	mv	a2,s1
    80200bec:	4501                	li	a0,0
    80200bee:	00000097          	auipc	ra,0x0
    80200bf2:	ca4080e7          	jalr	-860(ra) # 80200892 <dummy>
			if (user_pagefault(curr_proc()->pagetable, fpage,
    80200bf6:	00001097          	auipc	ra,0x1
    80200bfa:	606080e7          	jalr	1542(ra) # 802021fc <curr_proc>
    80200bfe:	864e                	mv	a2,s3
    80200c00:	75fd                	lui	a1,0xfffff
    80200c02:	00ba75b3          	and	a1,s4,a1
    80200c06:	6508                	ld	a0,8(a0)
    80200c08:	00001097          	auipc	ra,0x1
    80200c0c:	ca8080e7          	jalr	-856(ra) # 802018b0 <user_pagefault>
    80200c10:	d931                	beqz	a0,80200b64 <usertrap+0xb0>
				kfree(mem);
    80200c12:	854e                	mv	a0,s3
    80200c14:	00001097          	auipc	ra,0x1
    80200c18:	44a080e7          	jalr	1098(ra) # 8020205e <kfree>
				errorf("can't handle pagefault at %p, instruction at: %p",
    80200c1c:	00001097          	auipc	ra,0x1
    80200c20:	5ca080e7          	jalr	1482(ra) # 802021e6 <threadid>
    80200c24:	86aa                	mv	a3,a0
    80200c26:	14302773          	csrr	a4,stval
    80200c2a:	01893783          	ld	a5,24(s2)
    80200c2e:	00003617          	auipc	a2,0x3
    80200c32:	54a60613          	addi	a2,a2,1354 # 80204178 <e_text+0x178>
    80200c36:	45fd                	li	a1,31
    80200c38:	00003517          	auipc	a0,0x3
    80200c3c:	5e850513          	addi	a0,a0,1512 # 80204220 <e_text+0x220>
    80200c40:	00002097          	auipc	ra,0x2
    80200c44:	d2a080e7          	jalr	-726(ra) # 8020296a <printf>
				exit(-4);
    80200c48:	5571                	li	a0,-4
    80200c4a:	00002097          	auipc	ra,0x2
    80200c4e:	ba8080e7          	jalr	-1112(ra) # 802027f2 <exit>
    80200c52:	bf09                	j	80200b64 <usertrap+0xb0>
			errorf("%d in application, bad addr = %p, bad instruction = %p, "
    80200c54:	00001097          	auipc	ra,0x1
    80200c58:	592080e7          	jalr	1426(ra) # 802021e6 <threadid>
    80200c5c:	86aa                	mv	a3,a0
    80200c5e:	143027f3          	csrr	a5,stval
    80200c62:	01893803          	ld	a6,24(s2)
    80200c66:	8726                	mv	a4,s1
    80200c68:	00003617          	auipc	a2,0x3
    80200c6c:	51060613          	addi	a2,a2,1296 # 80204178 <e_text+0x178>
    80200c70:	45fd                	li	a1,31
    80200c72:	00003517          	auipc	a0,0x3
    80200c76:	5f650513          	addi	a0,a0,1526 # 80204268 <e_text+0x268>
    80200c7a:	00002097          	auipc	ra,0x2
    80200c7e:	cf0080e7          	jalr	-784(ra) # 8020296a <printf>
			exit(-2);
    80200c82:	5579                	li	a0,-2
    80200c84:	00002097          	auipc	ra,0x2
    80200c88:	b6e080e7          	jalr	-1170(ra) # 802027f2 <exit>
			break;
    80200c8c:	bde1                	j	80200b64 <usertrap+0xb0>
			errorf("IllegalInstruction in application, core dumped.");
    80200c8e:	00001097          	auipc	ra,0x1
    80200c92:	558080e7          	jalr	1368(ra) # 802021e6 <threadid>
    80200c96:	86aa                	mv	a3,a0
    80200c98:	00003617          	auipc	a2,0x3
    80200c9c:	4e060613          	addi	a2,a2,1248 # 80204178 <e_text+0x178>
    80200ca0:	45fd                	li	a1,31
    80200ca2:	00003517          	auipc	a0,0x3
    80200ca6:	61e50513          	addi	a0,a0,1566 # 802042c0 <e_text+0x2c0>
    80200caa:	00002097          	auipc	ra,0x2
    80200cae:	cc0080e7          	jalr	-832(ra) # 8020296a <printf>
			exit(-3);
    80200cb2:	5575                	li	a0,-3
    80200cb4:	00002097          	auipc	ra,0x2
    80200cb8:	b3e080e7          	jalr	-1218(ra) # 802027f2 <exit>
			break;
    80200cbc:	b565                	j	80200b64 <usertrap+0xb0>
			unknown_trap();
    80200cbe:	00000097          	auipc	ra,0x0
    80200cc2:	cdc080e7          	jalr	-804(ra) # 8020099a <unknown_trap>
			break;
    80200cc6:	bd79                	j	80200b64 <usertrap+0xb0>

0000000080200cc8 <consputc>:
#include "console.h"
#include "sbi.h"

void consputc(int c)
{
    80200cc8:	1141                	addi	sp,sp,-16
    80200cca:	e406                	sd	ra,8(sp)
    80200ccc:	e022                	sd	s0,0(sp)
    80200cce:	0800                	addi	s0,sp,16
	console_putchar(c);
    80200cd0:	00001097          	auipc	ra,0x1
    80200cd4:	4b8080e7          	jalr	1208(ra) # 80202188 <console_putchar>
}
    80200cd8:	60a2                	ld	ra,8(sp)
    80200cda:	6402                	ld	s0,0(sp)
    80200cdc:	0141                	addi	sp,sp,16
    80200cde:	8082                	ret

0000000080200ce0 <console_init>:

void console_init()
{
    80200ce0:	1141                	addi	sp,sp,-16
    80200ce2:	e422                	sd	s0,8(sp)
    80200ce4:	0800                	addi	s0,sp,16
	// DO NOTHING
}
    80200ce6:	6422                	ld	s0,8(sp)
    80200ce8:	0141                	addi	sp,sp,16
    80200cea:	8082                	ret

0000000080200cec <consgetc>:

int consgetc()
{
    80200cec:	1141                	addi	sp,sp,-16
    80200cee:	e406                	sd	ra,8(sp)
    80200cf0:	e022                	sd	s0,0(sp)
    80200cf2:	0800                	addi	s0,sp,16
	return console_getchar();
    80200cf4:	00001097          	auipc	ra,0x1
    80200cf8:	4aa080e7          	jalr	1194(ra) # 8020219e <console_getchar>
    80200cfc:	60a2                	ld	ra,8(sp)
    80200cfe:	6402                	ld	s0,0(sp)
    80200d00:	0141                	addi	sp,sp,16
    80200d02:	8082                	ret

0000000080200d04 <clean_bss>:
#include "loader.h"
#include "timer.h"
#include "trap.h"

void clean_bss()
{
    80200d04:	1141                	addi	sp,sp,-16
    80200d06:	e406                	sd	ra,8(sp)
    80200d08:	e022                	sd	s0,0(sp)
    80200d0a:	0800                	addi	s0,sp,16
	extern char s_bss[];
	extern char e_bss[];
	memset(s_bss, 0, e_bss - s_bss);
    80200d0c:	00065517          	auipc	a0,0x65
    80200d10:	2f450513          	addi	a0,a0,756 # 80266000 <names>
    80200d14:	00497617          	auipc	a2,0x497
    80200d18:	2ec60613          	addi	a2,a2,748 # 80698000 <e_bss>
    80200d1c:	9e09                	subw	a2,a2,a0
    80200d1e:	4581                	li	a1,0
    80200d20:	00000097          	auipc	ra,0x0
    80200d24:	9c4080e7          	jalr	-1596(ra) # 802006e4 <memset>
}
    80200d28:	60a2                	ld	ra,8(sp)
    80200d2a:	6402                	ld	s0,0(sp)
    80200d2c:	0141                	addi	sp,sp,16
    80200d2e:	8082                	ret

0000000080200d30 <main>:

void main()
{
    80200d30:	1141                	addi	sp,sp,-16
    80200d32:	e406                	sd	ra,8(sp)
    80200d34:	e022                	sd	s0,0(sp)
    80200d36:	0800                	addi	s0,sp,16
	clean_bss();
    80200d38:	00000097          	auipc	ra,0x0
    80200d3c:	fcc080e7          	jalr	-52(ra) # 80200d04 <clean_bss>
	printf("hello world!\n");
    80200d40:	00003517          	auipc	a0,0x3
    80200d44:	60850513          	addi	a0,a0,1544 # 80204348 <e_text+0x348>
    80200d48:	00002097          	auipc	ra,0x2
    80200d4c:	c22080e7          	jalr	-990(ra) # 8020296a <printf>
	proc_init();
    80200d50:	00001097          	auipc	ra,0x1
    80200d54:	4c0080e7          	jalr	1216(ra) # 80202210 <proc_init>
	kinit();
    80200d58:	00001097          	auipc	ra,0x1
    80200d5c:	3d4080e7          	jalr	980(ra) # 8020212c <kinit>
	kvm_init();
    80200d60:	00001097          	auipc	ra,0x1
    80200d64:	a86080e7          	jalr	-1402(ra) # 802017e6 <kvm_init>
	loader_init();
    80200d68:	fffff097          	auipc	ra,0xfffff
    80200d6c:	492080e7          	jalr	1170(ra) # 802001fa <loader_init>
	trap_init();
    80200d70:	00000097          	auipc	ra,0x0
    80200d74:	c10080e7          	jalr	-1008(ra) # 80200980 <trap_init>
	timer_init();
    80200d78:	00002097          	auipc	ra,0x2
    80200d7c:	dfc080e7          	jalr	-516(ra) # 80202b74 <timer_init>
	load_init_app();
    80200d80:	00000097          	auipc	ra,0x0
    80200d84:	884080e7          	jalr	-1916(ra) # 80200604 <load_init_app>
	infof("start scheduler!");
    80200d88:	4501                	li	a0,0
    80200d8a:	00000097          	auipc	ra,0x0
    80200d8e:	b08080e7          	jalr	-1272(ra) # 80200892 <dummy>
	scheduler();
    80200d92:	00001097          	auipc	ra,0x1
    80200d96:	67e080e7          	jalr	1662(ra) # 80202410 <scheduler>

0000000080200d9a <sys_write>:
#include "timer.h"
#include "trap.h"

uint64
sys_write(int fd, uint64 va, uint len)
{
    80200d9a:	7111                	addi	sp,sp,-256
    80200d9c:	fd86                	sd	ra,248(sp)
    80200d9e:	f9a2                	sd	s0,240(sp)
    80200da0:	f5a6                	sd	s1,232(sp)
    80200da2:	f1ca                	sd	s2,224(sp)
    80200da4:	edce                	sd	s3,216(sp)
    80200da6:	0200                	addi	s0,sp,256
    80200da8:	84aa                	mv	s1,a0
    80200daa:	89ae                	mv	s3,a1
    80200dac:	8932                	mv	s2,a2
	debugf("sys_write fd = %d str = %x, len = %d", fd, va, len);
    80200dae:	86b2                	mv	a3,a2
    80200db0:	862e                	mv	a2,a1
    80200db2:	85aa                	mv	a1,a0
    80200db4:	4501                	li	a0,0
    80200db6:	00000097          	auipc	ra,0x0
    80200dba:	adc080e7          	jalr	-1316(ra) # 80200892 <dummy>
	if (fd != STDOUT)
    80200dbe:	4785                	li	a5,1
		return -1;
    80200dc0:	557d                	li	a0,-1
	if (fd != STDOUT)
    80200dc2:	00f48963          	beq	s1,a5,80200dd4 <sys_write+0x3a>
	debugf("size = %d", size);
	for (int i = 0; i < size; ++i) {
		console_putchar(str[i]);
	}
	return size;
}
    80200dc6:	70ee                	ld	ra,248(sp)
    80200dc8:	744e                	ld	s0,240(sp)
    80200dca:	74ae                	ld	s1,232(sp)
    80200dcc:	790e                	ld	s2,224(sp)
    80200dce:	69ee                	ld	s3,216(sp)
    80200dd0:	6111                	addi	sp,sp,256
    80200dd2:	8082                	ret
	struct proc *p = curr_proc();
    80200dd4:	00001097          	auipc	ra,0x1
    80200dd8:	428080e7          	jalr	1064(ra) # 802021fc <curr_proc>
	int size = copyinstr(p->pagetable, str, va, MIN(len, MAX_STR_LEN));
    80200ddc:	86ca                	mv	a3,s2
    80200dde:	0c800793          	li	a5,200
    80200de2:	0127f463          	bgeu	a5,s2,80200dea <sys_write+0x50>
    80200de6:	0c800693          	li	a3,200
    80200dea:	1682                	slli	a3,a3,0x20
    80200dec:	9281                	srli	a3,a3,0x20
    80200dee:	864e                	mv	a2,s3
    80200df0:	f0840593          	addi	a1,s0,-248
    80200df4:	6508                	ld	a0,8(a0)
    80200df6:	00001097          	auipc	ra,0x1
    80200dfa:	0c4080e7          	jalr	196(ra) # 80201eba <copyinstr>
    80200dfe:	892a                	mv	s2,a0
	debugf("size = %d", size);
    80200e00:	85aa                	mv	a1,a0
    80200e02:	4501                	li	a0,0
    80200e04:	00000097          	auipc	ra,0x0
    80200e08:	a8e080e7          	jalr	-1394(ra) # 80200892 <dummy>
	for (int i = 0; i < size; ++i) {
    80200e0c:	03205563          	blez	s2,80200e36 <sys_write+0x9c>
    80200e10:	f0840493          	addi	s1,s0,-248
    80200e14:	fff9099b          	addiw	s3,s2,-1
    80200e18:	1982                	slli	s3,s3,0x20
    80200e1a:	0209d993          	srli	s3,s3,0x20
    80200e1e:	f0940793          	addi	a5,s0,-247
    80200e22:	99be                	add	s3,s3,a5
		console_putchar(str[i]);
    80200e24:	0004c503          	lbu	a0,0(s1) # 4000000 <_entry-0x7c200000>
    80200e28:	00001097          	auipc	ra,0x1
    80200e2c:	360080e7          	jalr	864(ra) # 80202188 <console_putchar>
	for (int i = 0; i < size; ++i) {
    80200e30:	0485                	addi	s1,s1,1
    80200e32:	ff3499e3          	bne	s1,s3,80200e24 <sys_write+0x8a>
	return size;
    80200e36:	854a                	mv	a0,s2
    80200e38:	b779                	j	80200dc6 <sys_write+0x2c>

0000000080200e3a <sys_read>:

uint64
sys_read(int fd, uint64 va, uint64 len)
{
    80200e3a:	716d                	addi	sp,sp,-272
    80200e3c:	e606                	sd	ra,264(sp)
    80200e3e:	e222                	sd	s0,256(sp)
    80200e40:	fda6                	sd	s1,248(sp)
    80200e42:	f9ca                	sd	s2,240(sp)
    80200e44:	f5ce                	sd	s3,232(sp)
    80200e46:	f1d2                	sd	s4,224(sp)
    80200e48:	edd6                	sd	s5,216(sp)
    80200e4a:	0a00                	addi	s0,sp,272
    80200e4c:	84aa                	mv	s1,a0
    80200e4e:	8a2e                	mv	s4,a1
    80200e50:	8932                	mv	s2,a2
	debugf("sys_read fd = %d str = %x, len = %d", fd, va, len);
    80200e52:	86b2                	mv	a3,a2
    80200e54:	862e                	mv	a2,a1
    80200e56:	85aa                	mv	a1,a0
    80200e58:	4501                	li	a0,0
    80200e5a:	00000097          	auipc	ra,0x0
    80200e5e:	a38080e7          	jalr	-1480(ra) # 80200892 <dummy>
	if (fd != STDIN)
		return -1;
    80200e62:	557d                	li	a0,-1
	if (fd != STDIN)
    80200e64:	e0a1                	bnez	s1,80200ea4 <sys_read+0x6a>
	struct proc *p = curr_proc();
    80200e66:	00001097          	auipc	ra,0x1
    80200e6a:	396080e7          	jalr	918(ra) # 802021fc <curr_proc>
    80200e6e:	8aaa                	mv	s5,a0
	char str[MAX_STR_LEN];
	for (int i = 0; i < len; ++i) {
    80200e70:	00090f63          	beqz	s2,80200e8e <sys_read+0x54>
    80200e74:	ef840493          	addi	s1,s0,-264
    80200e78:	009909b3          	add	s3,s2,s1
		int c = consgetc();
    80200e7c:	00000097          	auipc	ra,0x0
    80200e80:	e70080e7          	jalr	-400(ra) # 80200cec <consgetc>
		str[i] = c;
    80200e84:	00a48023          	sb	a0,0(s1)
	for (int i = 0; i < len; ++i) {
    80200e88:	0485                	addi	s1,s1,1
    80200e8a:	ff3499e3          	bne	s1,s3,80200e7c <sys_read+0x42>
	}
	copyout(p->pagetable, va, str, len);
    80200e8e:	86ca                	mv	a3,s2
    80200e90:	ef840613          	addi	a2,s0,-264
    80200e94:	85d2                	mv	a1,s4
    80200e96:	008ab503          	ld	a0,8(s5)
    80200e9a:	00001097          	auipc	ra,0x1
    80200e9e:	f06080e7          	jalr	-250(ra) # 80201da0 <copyout>
	return len;
    80200ea2:	854a                	mv	a0,s2
}
    80200ea4:	60b2                	ld	ra,264(sp)
    80200ea6:	6412                	ld	s0,256(sp)
    80200ea8:	74ee                	ld	s1,248(sp)
    80200eaa:	794e                	ld	s2,240(sp)
    80200eac:	79ae                	ld	s3,232(sp)
    80200eae:	7a0e                	ld	s4,224(sp)
    80200eb0:	6aee                	ld	s5,216(sp)
    80200eb2:	6151                	addi	sp,sp,272
    80200eb4:	8082                	ret

0000000080200eb6 <sys_exit>:

__attribute__((noreturn)) void
sys_exit(int code)
{
    80200eb6:	1141                	addi	sp,sp,-16
    80200eb8:	e406                	sd	ra,8(sp)
    80200eba:	e022                	sd	s0,0(sp)
    80200ebc:	0800                	addi	s0,sp,16
	exit(code);
    80200ebe:	00002097          	auipc	ra,0x2
    80200ec2:	934080e7          	jalr	-1740(ra) # 802027f2 <exit>

0000000080200ec6 <sys_sched_yield>:
	__builtin_unreachable();
}

uint64
sys_sched_yield()
{
    80200ec6:	1141                	addi	sp,sp,-16
    80200ec8:	e406                	sd	ra,8(sp)
    80200eca:	e022                	sd	s0,0(sp)
    80200ecc:	0800                	addi	s0,sp,16
	yield();
    80200ece:	00001097          	auipc	ra,0x1
    80200ed2:	668080e7          	jalr	1640(ra) # 80202536 <yield>
	return 0;
}
    80200ed6:	4501                	li	a0,0
    80200ed8:	60a2                	ld	ra,8(sp)
    80200eda:	6402                	ld	s0,0(sp)
    80200edc:	0141                	addi	sp,sp,16
    80200ede:	8082                	ret

0000000080200ee0 <sys_gettimeofday>:

uint64
sys_gettimeofday(uint64 val, int _tz)
{
    80200ee0:	7179                	addi	sp,sp,-48
    80200ee2:	f406                	sd	ra,40(sp)
    80200ee4:	f022                	sd	s0,32(sp)
    80200ee6:	ec26                	sd	s1,24(sp)
    80200ee8:	e84a                	sd	s2,16(sp)
    80200eea:	1800                	addi	s0,sp,48
    80200eec:	892a                	mv	s2,a0
	struct proc *p = curr_proc();
    80200eee:	00001097          	auipc	ra,0x1
    80200ef2:	30e080e7          	jalr	782(ra) # 802021fc <curr_proc>
    80200ef6:	84aa                	mv	s1,a0
	uint64 cycle = get_cycle();
    80200ef8:	00002097          	auipc	ra,0x2
    80200efc:	c48080e7          	jalr	-952(ra) # 80202b40 <get_cycle>
	TimeVal t;
	t.sec = cycle / CPU_FREQ;
    80200f00:	00bec737          	lui	a4,0xbec
    80200f04:	c2070713          	addi	a4,a4,-992 # bebc20 <_entry-0x7f6143e0>
    80200f08:	02e556b3          	divu	a3,a0,a4
    80200f0c:	fcd43823          	sd	a3,-48(s0)
	t.usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
    80200f10:	02e577b3          	remu	a5,a0,a4
    80200f14:	000f4537          	lui	a0,0xf4
    80200f18:	24050513          	addi	a0,a0,576 # f4240 <_entry-0x8010bdc0>
    80200f1c:	02a787b3          	mul	a5,a5,a0
    80200f20:	02e7d7b3          	divu	a5,a5,a4
    80200f24:	fcf43c23          	sd	a5,-40(s0)
	copyout(p->pagetable, val, (char *)&t, sizeof(TimeVal));
    80200f28:	46c1                	li	a3,16
    80200f2a:	fd040613          	addi	a2,s0,-48
    80200f2e:	85ca                	mv	a1,s2
    80200f30:	6488                	ld	a0,8(s1)
    80200f32:	00001097          	auipc	ra,0x1
    80200f36:	e6e080e7          	jalr	-402(ra) # 80201da0 <copyout>
	return 0;
}
    80200f3a:	4501                	li	a0,0
    80200f3c:	70a2                	ld	ra,40(sp)
    80200f3e:	7402                	ld	s0,32(sp)
    80200f40:	64e2                	ld	s1,24(sp)
    80200f42:	6942                	ld	s2,16(sp)
    80200f44:	6145                	addi	sp,sp,48
    80200f46:	8082                	ret

0000000080200f48 <sys_getpid>:

uint64
sys_getpid()
{
    80200f48:	1141                	addi	sp,sp,-16
    80200f4a:	e406                	sd	ra,8(sp)
    80200f4c:	e022                	sd	s0,0(sp)
    80200f4e:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
    80200f50:	00001097          	auipc	ra,0x1
    80200f54:	2ac080e7          	jalr	684(ra) # 802021fc <curr_proc>
}
    80200f58:	4148                	lw	a0,4(a0)
    80200f5a:	60a2                	ld	ra,8(sp)
    80200f5c:	6402                	ld	s0,0(sp)
    80200f5e:	0141                	addi	sp,sp,16
    80200f60:	8082                	ret

0000000080200f62 <sys_getppid>:

uint64
sys_getppid()
{
    80200f62:	1141                	addi	sp,sp,-16
    80200f64:	e406                	sd	ra,8(sp)
    80200f66:	e022                	sd	s0,0(sp)
    80200f68:	0800                	addi	s0,sp,16
	struct proc *p = curr_proc();
    80200f6a:	00001097          	auipc	ra,0x1
    80200f6e:	292080e7          	jalr	658(ra) # 802021fc <curr_proc>
	return p->parent == NULL ? IDLE_PID : p->parent->pid;
    80200f72:	7d5c                	ld	a5,184(a0)
    80200f74:	4501                	li	a0,0
    80200f76:	c391                	beqz	a5,80200f7a <sys_getppid+0x18>
    80200f78:	43c8                	lw	a0,4(a5)
}
    80200f7a:	60a2                	ld	ra,8(sp)
    80200f7c:	6402                	ld	s0,0(sp)
    80200f7e:	0141                	addi	sp,sp,16
    80200f80:	8082                	ret

0000000080200f82 <sys_clone>:

uint64
sys_clone()
{
    80200f82:	1141                	addi	sp,sp,-16
    80200f84:	e406                	sd	ra,8(sp)
    80200f86:	e022                	sd	s0,0(sp)
    80200f88:	0800                	addi	s0,sp,16
	debugf("fork!\n");
    80200f8a:	4501                	li	a0,0
    80200f8c:	00000097          	auipc	ra,0x0
    80200f90:	906080e7          	jalr	-1786(ra) # 80200892 <dummy>
	return fork();
    80200f94:	00001097          	auipc	ra,0x1
    80200f98:	65e080e7          	jalr	1630(ra) # 802025f2 <fork>
}
    80200f9c:	60a2                	ld	ra,8(sp)
    80200f9e:	6402                	ld	s0,0(sp)
    80200fa0:	0141                	addi	sp,sp,16
    80200fa2:	8082                	ret

0000000080200fa4 <sys_mmap>:

int
sys_mmap(void *start, unsigned long long len, int port, int flag, int fd)
{
    80200fa4:	715d                	addi	sp,sp,-80
    80200fa6:	e486                	sd	ra,72(sp)
    80200fa8:	e0a2                	sd	s0,64(sp)
    80200faa:	fc26                	sd	s1,56(sp)
    80200fac:	f84a                	sd	s2,48(sp)
    80200fae:	f44e                	sd	s3,40(sp)
    80200fb0:	f052                	sd	s4,32(sp)
    80200fb2:	ec56                	sd	s5,24(sp)
    80200fb4:	e85a                	sd	s6,16(sp)
    80200fb6:	e45e                	sd	s7,8(sp)
    80200fb8:	0880                	addi	s0,sp,80
    80200fba:	89aa                	mv	s3,a0
    80200fbc:	84ae                	mv	s1,a1
    80200fbe:	8932                	mv	s2,a2
	debugf("mmap addr: %p, len: %d, port: %d", start, len, port);
    80200fc0:	86b2                	mv	a3,a2
    80200fc2:	862e                	mv	a2,a1
    80200fc4:	85aa                	mv	a1,a0
    80200fc6:	4501                	li	a0,0
    80200fc8:	00000097          	auipc	ra,0x0
    80200fcc:	8ca080e7          	jalr	-1846(ra) # 80200892 <dummy>
	if ((((uint64)start & 0xfff) != 0) || ((port & 0x7) == 0) ||
    80200fd0:	03499793          	slli	a5,s3,0x34
    80200fd4:	eba5                	bnez	a5,80201044 <sys_mmap+0xa0>
    80200fd6:	0347da13          	srli	s4,a5,0x34
    80200fda:	00797793          	andi	a5,s2,7
    80200fde:	c7ad                	beqz	a5,80201048 <sys_mmap+0xa4>
	    ((port & (~0x7)) != 0) || (len > (1 << 30))) {
    80200fe0:	ff897b93          	andi	s7,s2,-8
	if ((((uint64)start & 0xfff) != 0) || ((port & 0x7) == 0) ||
    80200fe4:	060b9463          	bnez	s7,8020104c <sys_mmap+0xa8>
	    ((port & (~0x7)) != 0) || (len > (1 << 30))) {
    80200fe8:	400007b7          	lui	a5,0x40000
    80200fec:	0697e263          	bltu	a5,s1,80201050 <sys_mmap+0xac>
		return -1;
	}

	if (len == 0) {
    80200ff0:	ec89                	bnez	s1,8020100a <sys_mmap+0x66>
	p->max_page = p->max_page > ((uint64)(start + len) / PAGE_SIZE) + 1 ?
			      p->max_page :
			      ((uint64)(start + len) / PAGE_SIZE) + 1;

	return 0;
}
    80200ff2:	855e                	mv	a0,s7
    80200ff4:	60a6                	ld	ra,72(sp)
    80200ff6:	6406                	ld	s0,64(sp)
    80200ff8:	74e2                	ld	s1,56(sp)
    80200ffa:	7942                	ld	s2,48(sp)
    80200ffc:	79a2                	ld	s3,40(sp)
    80200ffe:	7a02                	ld	s4,32(sp)
    80201000:	6ae2                	ld	s5,24(sp)
    80201002:	6b42                	ld	s6,16(sp)
    80201004:	6ba2                	ld	s7,8(sp)
    80201006:	6161                	addi	sp,sp,80
    80201008:	8082                	ret
	struct proc *p = curr_proc();
    8020100a:	00001097          	auipc	ra,0x1
    8020100e:	1f2080e7          	jalr	498(ra) # 802021fc <curr_proc>
    80201012:	8b2a                	mv	s6,a0
	len = (len & (~0xfff)) + ((len & 0xfff) > 0 ? PAGE_SIZE : 0);
    80201014:	7afd                	lui	s5,0xfffff
    80201016:	0154fab3          	and	s5,s1,s5
    8020101a:	03449593          	slli	a1,s1,0x34
    8020101e:	e99d                	bnez	a1,80201054 <sys_mmap+0xb0>
	for (uint64 i = 0; i < len; i += PAGE_SIZE) {
    80201020:	020a9c63          	bnez	s5,80201058 <sys_mmap+0xb4>
    80201024:	a8b9                	j	80201082 <sys_mmap+0xde>
			for (int j = 0; j < i - 1; j += PAGE_SIZE) {
    80201026:	14fd                	addi	s1,s1,-1
    80201028:	6905                	lui	s2,0x1
				lazy_uvmunmap(p->pagetable, (uint64)start + j);
    8020102a:	014985b3          	add	a1,s3,s4
    8020102e:	008b3503          	ld	a0,8(s6)
    80201032:	00001097          	auipc	ra,0x1
    80201036:	9d0080e7          	jalr	-1584(ra) # 80201a02 <lazy_uvmunmap>
			for (int j = 0; j < i - 1; j += PAGE_SIZE) {
    8020103a:	9a4a                	add	s4,s4,s2
    8020103c:	fe9a67e3          	bltu	s4,s1,8020102a <sys_mmap+0x86>
			return -1;
    80201040:	5bfd                	li	s7,-1
    80201042:	bf45                	j	80200ff2 <sys_mmap+0x4e>
		return -1;
    80201044:	5bfd                	li	s7,-1
    80201046:	b775                	j	80200ff2 <sys_mmap+0x4e>
    80201048:	5bfd                	li	s7,-1
    8020104a:	b765                	j	80200ff2 <sys_mmap+0x4e>
    8020104c:	5bfd                	li	s7,-1
    8020104e:	b755                	j	80200ff2 <sys_mmap+0x4e>
    80201050:	5bfd                	li	s7,-1
    80201052:	b745                	j	80200ff2 <sys_mmap+0x4e>
	len = (len & (~0xfff)) + ((len & 0xfff) > 0 ? PAGE_SIZE : 0);
    80201054:	6785                	lui	a5,0x1
    80201056:	9abe                	add	s5,s5,a5
					PAGE_SIZE, (port << 1) | PTE_U);
    80201058:	0019191b          	slliw	s2,s2,0x1
		result |= lazy_mappages(p->pagetable, (uint64)start + i,
    8020105c:	01096913          	ori	s2,s2,16
    80201060:	2901                	sext.w	s2,s2
    80201062:	84d2                	mv	s1,s4
    80201064:	86ca                	mv	a3,s2
    80201066:	6605                	lui	a2,0x1
    80201068:	009985b3          	add	a1,s3,s1
    8020106c:	008b3503          	ld	a0,8(s6)
    80201070:	00000097          	auipc	ra,0x0
    80201074:	7b4080e7          	jalr	1972(ra) # 80201824 <lazy_mappages>
		if (result != 0) {
    80201078:	f55d                	bnez	a0,80201026 <sys_mmap+0x82>
	for (uint64 i = 0; i < len; i += PAGE_SIZE) {
    8020107a:	6785                	lui	a5,0x1
    8020107c:	94be                	add	s1,s1,a5
    8020107e:	ff54e3e3          	bltu	s1,s5,80201064 <sys_mmap+0xc0>
	p->max_page = p->max_page > ((uint64)(start + len) / PAGE_SIZE) + 1 ?
    80201082:	015987b3          	add	a5,s3,s5
    80201086:	83b1                	srli	a5,a5,0xc
			      p->max_page :
    80201088:	098b3703          	ld	a4,152(s6)
    8020108c:	0785                	addi	a5,a5,1
    8020108e:	00e7f363          	bgeu	a5,a4,80201094 <sys_mmap+0xf0>
    80201092:	87ba                	mv	a5,a4
	p->max_page = p->max_page > ((uint64)(start + len) / PAGE_SIZE) + 1 ?
    80201094:	08fb3c23          	sd	a5,152(s6)
	return 0;
    80201098:	bfa9                	j	80200ff2 <sys_mmap+0x4e>

000000008020109a <sys_munmap>:

int
sys_munmap(void *start, unsigned long long len)
{
    8020109a:	7139                	addi	sp,sp,-64
    8020109c:	fc06                	sd	ra,56(sp)
    8020109e:	f822                	sd	s0,48(sp)
    802010a0:	f426                	sd	s1,40(sp)
    802010a2:	f04a                	sd	s2,32(sp)
    802010a4:	ec4e                	sd	s3,24(sp)
    802010a6:	e852                	sd	s4,16(sp)
    802010a8:	e456                	sd	s5,8(sp)
    802010aa:	0080                	addi	s0,sp,64
    802010ac:	84aa                	mv	s1,a0
    802010ae:	892e                	mv	s2,a1
	debugf("munmap addr: %p, len: %d", start, len);
    802010b0:	862e                	mv	a2,a1
    802010b2:	85aa                	mv	a1,a0
    802010b4:	4501                	li	a0,0
    802010b6:	fffff097          	auipc	ra,0xfffff
    802010ba:	7dc080e7          	jalr	2012(ra) # 80200892 <dummy>
	if ((((uint64)start & 0xfff) != 0) || (len > (1 << 30))) {
    802010be:	03449793          	slli	a5,s1,0x34
    802010c2:	e7d9                	bnez	a5,80201150 <sys_munmap+0xb6>
    802010c4:	89a6                	mv	s3,s1
    802010c6:	400007b7          	lui	a5,0x40000
    802010ca:	0927e563          	bltu	a5,s2,80201154 <sys_munmap+0xba>
		return -1;
	}
	if (len == 0) {
		return 0;
    802010ce:	4501                	li	a0,0
	if (len == 0) {
    802010d0:	00091b63          	bnez	s2,802010e6 <sys_munmap+0x4c>
		}
	}
#endif /* ifdef NOT_USE_LAZY_MMAP */

	return 0;
}
    802010d4:	70e2                	ld	ra,56(sp)
    802010d6:	7442                	ld	s0,48(sp)
    802010d8:	74a2                	ld	s1,40(sp)
    802010da:	7902                	ld	s2,32(sp)
    802010dc:	69e2                	ld	s3,24(sp)
    802010de:	6a42                	ld	s4,16(sp)
    802010e0:	6aa2                	ld	s5,8(sp)
    802010e2:	6121                	addi	sp,sp,64
    802010e4:	8082                	ret
	struct proc *p = curr_proc();
    802010e6:	00001097          	auipc	ra,0x1
    802010ea:	116080e7          	jalr	278(ra) # 802021fc <curr_proc>
    802010ee:	8a2a                	mv	s4,a0
	len = (len & (~0xfff)) + ((len & 0xfff) > 0 ? PAGE_SIZE : 0);
    802010f0:	757d                	lui	a0,0xfffff
    802010f2:	00a97533          	and	a0,s2,a0
    802010f6:	1952                	slli	s2,s2,0x34
    802010f8:	03495793          	srli	a5,s2,0x34
    802010fc:	00090363          	beqz	s2,80201102 <sys_munmap+0x68>
    80201100:	6785                	lui	a5,0x1
	for (; a < (uint64)start + len; a += PAGE_SIZE) {
    80201102:	94aa                	add	s1,s1,a0
    80201104:	94be                	add	s1,s1,a5
    80201106:	0499f963          	bgeu	s3,s1,80201158 <sys_munmap+0xbe>
		switch (walkaddr(p->pagetable, a)) {
    8020110a:	4905                	li	s2,1
	for (; a < (uint64)start + len; a += PAGE_SIZE) {
    8020110c:	6a85                	lui	s5,0x1
    8020110e:	a829                	j	80201128 <sys_munmap+0x8e>
			uvmunmap(p->pagetable, a, 1, 1);
    80201110:	86ca                	mv	a3,s2
    80201112:	864a                	mv	a2,s2
    80201114:	85ce                	mv	a1,s3
    80201116:	008a3503          	ld	a0,8(s4)
    8020111a:	00000097          	auipc	ra,0x0
    8020111e:	7d8080e7          	jalr	2008(ra) # 802018f2 <uvmunmap>
	for (; a < (uint64)start + len; a += PAGE_SIZE) {
    80201122:	99d6                	add	s3,s3,s5
    80201124:	0299f463          	bgeu	s3,s1,8020114c <sys_munmap+0xb2>
		switch (walkaddr(p->pagetable, a)) {
    80201128:	85ce                	mv	a1,s3
    8020112a:	008a3503          	ld	a0,8(s4)
    8020112e:	00000097          	auipc	ra,0x0
    80201132:	49a080e7          	jalr	1178(ra) # 802015c8 <walkaddr>
    80201136:	c11d                	beqz	a0,8020115c <sys_munmap+0xc2>
    80201138:	fd251ce3          	bne	a0,s2,80201110 <sys_munmap+0x76>
			lazy_uvmunmap(p->pagetable, a);
    8020113c:	85ce                	mv	a1,s3
    8020113e:	008a3503          	ld	a0,8(s4)
    80201142:	00001097          	auipc	ra,0x1
    80201146:	8c0080e7          	jalr	-1856(ra) # 80201a02 <lazy_uvmunmap>
			break;
    8020114a:	bfe1                	j	80201122 <sys_munmap+0x88>
	return 0;
    8020114c:	4501                	li	a0,0
    8020114e:	b759                	j	802010d4 <sys_munmap+0x3a>
		return -1;
    80201150:	557d                	li	a0,-1
    80201152:	b749                	j	802010d4 <sys_munmap+0x3a>
    80201154:	557d                	li	a0,-1
    80201156:	bfbd                	j	802010d4 <sys_munmap+0x3a>
	return 0;
    80201158:	4501                	li	a0,0
    8020115a:	bfad                	j	802010d4 <sys_munmap+0x3a>
		switch (walkaddr(p->pagetable, a)) {
    8020115c:	557d                	li	a0,-1
    8020115e:	bf9d                	j	802010d4 <sys_munmap+0x3a>

0000000080201160 <sys_exec>:

uint64
sys_exec(uint64 va)
{
    80201160:	7151                	addi	sp,sp,-240
    80201162:	f586                	sd	ra,232(sp)
    80201164:	f1a2                	sd	s0,224(sp)
    80201166:	eda6                	sd	s1,216(sp)
    80201168:	1980                	addi	s0,sp,240
    8020116a:	84aa                	mv	s1,a0
	struct proc *p = curr_proc();
    8020116c:	00001097          	auipc	ra,0x1
    80201170:	090080e7          	jalr	144(ra) # 802021fc <curr_proc>
	char name[200];
	copyinstr(p->pagetable, name, va, 200);
    80201174:	0c800693          	li	a3,200
    80201178:	8626                	mv	a2,s1
    8020117a:	f1840593          	addi	a1,s0,-232
    8020117e:	6508                	ld	a0,8(a0)
    80201180:	00001097          	auipc	ra,0x1
    80201184:	d3a080e7          	jalr	-710(ra) # 80201eba <copyinstr>
	debugf("sys_exec %s\n", name);
    80201188:	f1840593          	addi	a1,s0,-232
    8020118c:	4501                	li	a0,0
    8020118e:	fffff097          	auipc	ra,0xfffff
    80201192:	704080e7          	jalr	1796(ra) # 80200892 <dummy>
	return exec(name);
    80201196:	f1840513          	addi	a0,s0,-232
    8020119a:	00001097          	auipc	ra,0x1
    8020119e:	55a080e7          	jalr	1370(ra) # 802026f4 <exec>
}
    802011a2:	70ae                	ld	ra,232(sp)
    802011a4:	740e                	ld	s0,224(sp)
    802011a6:	64ee                	ld	s1,216(sp)
    802011a8:	616d                	addi	sp,sp,240
    802011aa:	8082                	ret

00000000802011ac <sys_wait>:

uint64
sys_wait(int pid, uint64 va)
{
    802011ac:	1101                	addi	sp,sp,-32
    802011ae:	ec06                	sd	ra,24(sp)
    802011b0:	e822                	sd	s0,16(sp)
    802011b2:	e426                	sd	s1,8(sp)
    802011b4:	e04a                	sd	s2,0(sp)
    802011b6:	1000                	addi	s0,sp,32
    802011b8:	84aa                	mv	s1,a0
    802011ba:	892e                	mv	s2,a1
	struct proc *p = curr_proc();
    802011bc:	00001097          	auipc	ra,0x1
    802011c0:	040080e7          	jalr	64(ra) # 802021fc <curr_proc>
	int *code = (int *)useraddr(p->pagetable, va);
    802011c4:	85ca                	mv	a1,s2
    802011c6:	6508                	ld	a0,8(a0)
    802011c8:	00000097          	auipc	ra,0x0
    802011cc:	446080e7          	jalr	1094(ra) # 8020160e <useraddr>
    802011d0:	85aa                	mv	a1,a0
	return wait(pid, code);
    802011d2:	8526                	mv	a0,s1
    802011d4:	00001097          	auipc	ra,0x1
    802011d8:	578080e7          	jalr	1400(ra) # 8020274c <wait>
}
    802011dc:	60e2                	ld	ra,24(sp)
    802011de:	6442                	ld	s0,16(sp)
    802011e0:	64a2                	ld	s1,8(sp)
    802011e2:	6902                	ld	s2,0(sp)
    802011e4:	6105                	addi	sp,sp,32
    802011e6:	8082                	ret

00000000802011e8 <sys_spawn>:

uint64
sys_spawn(uint64 va)
{
    802011e8:	7151                	addi	sp,sp,-240
    802011ea:	f586                	sd	ra,232(sp)
    802011ec:	f1a2                	sd	s0,224(sp)
    802011ee:	eda6                	sd	s1,216(sp)
    802011f0:	e9ca                	sd	s2,208(sp)
    802011f2:	1980                	addi	s0,sp,240
    802011f4:	84aa                	mv	s1,a0
	struct proc *np;
	struct proc *p = curr_proc();
    802011f6:	00001097          	auipc	ra,0x1
    802011fa:	006080e7          	jalr	6(ra) # 802021fc <curr_proc>
    802011fe:	892a                	mv	s2,a0

	char name[200];
	copyinstr(p->pagetable, name, va, 200);
    80201200:	0c800693          	li	a3,200
    80201204:	8626                	mv	a2,s1
    80201206:	f1840593          	addi	a1,s0,-232
    8020120a:	6508                	ld	a0,8(a0)
    8020120c:	00001097          	auipc	ra,0x1
    80201210:	cae080e7          	jalr	-850(ra) # 80201eba <copyinstr>
	debugf("sys_spawn %s\n", name);
    80201214:	f1840593          	addi	a1,s0,-232
    80201218:	4501                	li	a0,0
    8020121a:	fffff097          	auipc	ra,0xfffff
    8020121e:	678080e7          	jalr	1656(ra) # 80200892 <dummy>

	if ((np = allocproc()) == 0) {
    80201222:	00001097          	auipc	ra,0x1
    80201226:	146080e7          	jalr	326(ra) # 80202368 <allocproc>
    8020122a:	c121                	beqz	a0,8020126a <sys_spawn+0x82>
    8020122c:	84aa                	mv	s1,a0
		return -1;
	}

	int id = get_id_by_name(name);
    8020122e:	f1840513          	addi	a0,s0,-232
    80201232:	fffff097          	auipc	ra,0xfffff
    80201236:	098080e7          	jalr	152(ra) # 802002ca <get_id_by_name>
    8020123a:	87aa                	mv	a5,a0
	if (id < 0)
		return -1;
    8020123c:	557d                	li	a0,-1
	if (id < 0)
    8020123e:	0207c063          	bltz	a5,8020125e <sys_spawn+0x76>

	loader(id, np);
    80201242:	85a6                	mv	a1,s1
    80201244:	853e                	mv	a0,a5
    80201246:	fffff097          	auipc	ra,0xfffff
    8020124a:	392080e7          	jalr	914(ra) # 802005d8 <loader>
	np->parent = p;
    8020124e:	0b24bc23          	sd	s2,184(s1)

	add_task(np);
    80201252:	8526                	mv	a0,s1
    80201254:	00001097          	auipc	ra,0x1
    80201258:	0ba080e7          	jalr	186(ra) # 8020230e <add_task>
	return np->pid;
    8020125c:	40c8                	lw	a0,4(s1)
}
    8020125e:	70ae                	ld	ra,232(sp)
    80201260:	740e                	ld	s0,224(sp)
    80201262:	64ee                	ld	s1,216(sp)
    80201264:	694e                	ld	s2,208(sp)
    80201266:	616d                	addi	sp,sp,240
    80201268:	8082                	ret
		return -1;
    8020126a:	557d                	li	a0,-1
    8020126c:	bfcd                	j	8020125e <sys_spawn+0x76>

000000008020126e <sys_set_priority>:

uint64
sys_set_priority(long long prio)
{
	if (prio <= 1) {
    8020126e:	4785                	li	a5,1
    80201270:	02a7d763          	bge	a5,a0,8020129e <sys_set_priority+0x30>
{
    80201274:	1101                	addi	sp,sp,-32
    80201276:	ec06                	sd	ra,24(sp)
    80201278:	e822                	sd	s0,16(sp)
    8020127a:	e426                	sd	s1,8(sp)
    8020127c:	1000                	addi	s0,sp,32
    8020127e:	84aa                	mv	s1,a0
		return -1;
	}
	struct proc *p = curr_proc();
    80201280:	00001097          	auipc	ra,0x1
    80201284:	f7c080e7          	jalr	-132(ra) # 802021fc <curr_proc>
	p->prio = prio;
    80201288:	f144                	sd	s1,160(a0)
	p->pass = BIG_STRIDE / p->prio;
    8020128a:	67c1                	lui	a5,0x10
    8020128c:	0297c7b3          	div	a5,a5,s1
    80201290:	f95c                	sd	a5,176(a0)
	return prio;
    80201292:	8526                	mv	a0,s1
}
    80201294:	60e2                	ld	ra,24(sp)
    80201296:	6442                	ld	s0,16(sp)
    80201298:	64a2                	ld	s1,8(sp)
    8020129a:	6105                	addi	sp,sp,32
    8020129c:	8082                	ret
		return -1;
    8020129e:	557d                	li	a0,-1
}
    802012a0:	8082                	ret

00000000802012a2 <sys_sbrk>:

uint64
sys_sbrk(int n)
{
    802012a2:	1101                	addi	sp,sp,-32
    802012a4:	ec06                	sd	ra,24(sp)
    802012a6:	e822                	sd	s0,16(sp)
    802012a8:	e426                	sd	s1,8(sp)
    802012aa:	e04a                	sd	s2,0(sp)
    802012ac:	1000                	addi	s0,sp,32
    802012ae:	84aa                	mv	s1,a0
	uint64 addr;
	struct proc *p = curr_proc();
    802012b0:	00001097          	auipc	ra,0x1
    802012b4:	f4c080e7          	jalr	-180(ra) # 802021fc <curr_proc>
	addr = p->program_brk;
    802012b8:	14853903          	ld	s2,328(a0) # fffffffffffff148 <e_bss+0xffffffff7f967148>
	if (growproc(n) < 0)
    802012bc:	8526                	mv	a0,s1
    802012be:	00001097          	auipc	ra,0x1
    802012c2:	5a0080e7          	jalr	1440(ra) # 8020285e <growproc>
    802012c6:	00054963          	bltz	a0,802012d8 <sys_sbrk+0x36>
		return -1;
	return addr;
}
    802012ca:	854a                	mv	a0,s2
    802012cc:	60e2                	ld	ra,24(sp)
    802012ce:	6442                	ld	s0,16(sp)
    802012d0:	64a2                	ld	s1,8(sp)
    802012d2:	6902                	ld	s2,0(sp)
    802012d4:	6105                	addi	sp,sp,32
    802012d6:	8082                	ret
		return -1;
    802012d8:	597d                	li	s2,-1
    802012da:	bfc5                	j	802012ca <sys_sbrk+0x28>

00000000802012dc <syscall>:

extern char trap_page[];

void
syscall()
{
    802012dc:	715d                	addi	sp,sp,-80
    802012de:	e486                	sd	ra,72(sp)
    802012e0:	e0a2                	sd	s0,64(sp)
    802012e2:	fc26                	sd	s1,56(sp)
    802012e4:	f84a                	sd	s2,48(sp)
    802012e6:	f44e                	sd	s3,40(sp)
    802012e8:	f052                	sd	s4,32(sp)
    802012ea:	ec56                	sd	s5,24(sp)
    802012ec:	e85a                	sd	s6,16(sp)
    802012ee:	e45e                	sd	s7,8(sp)
    802012f0:	0880                	addi	s0,sp,80
	struct trapframe *trapframe = curr_proc()->trapframe;
    802012f2:	00001097          	auipc	ra,0x1
    802012f6:	f0a080e7          	jalr	-246(ra) # 802021fc <curr_proc>
    802012fa:	02053903          	ld	s2,32(a0)
	int id = trapframe->a7, ret;
    802012fe:	0a892483          	lw	s1,168(s2) # 10a8 <_entry-0x801fef58>
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
    80201302:	07093983          	ld	s3,112(s2)
    80201306:	07893a03          	ld	s4,120(s2)
    8020130a:	08093a83          	ld	s5,128(s2)
			   trapframe->a3, trapframe->a4, trapframe->a5 };
    8020130e:	08893b03          	ld	s6,136(s2)
    80201312:	09093b83          	ld	s7,144(s2)
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
    80201316:	09893883          	ld	a7,152(s2)
    8020131a:	885e                	mv	a6,s7
    8020131c:	87da                	mv	a5,s6
    8020131e:	8756                	mv	a4,s5
    80201320:	86d2                	mv	a3,s4
    80201322:	864e                	mv	a2,s3
    80201324:	85a6                	mv	a1,s1
    80201326:	4501                	li	a0,0
    80201328:	fffff097          	auipc	ra,0xfffff
    8020132c:	56a080e7          	jalr	1386(ra) # 80200892 <dummy>
	       args[1], args[2], args[3], args[4], args[5]);
	switch (id) {
    80201330:	0de00793          	li	a5,222
    80201334:	0a97c563          	blt	a5,s1,802013de <syscall+0x102>
    80201338:	0a800793          	li	a5,168
    8020133c:	0297d663          	bge	a5,s1,80201368 <syscall+0x8c>
    80201340:	f574879b          	addiw	a5,s1,-169
    80201344:	0007869b          	sext.w	a3,a5
    80201348:	03500713          	li	a4,53
    8020134c:	18d76063          	bltu	a4,a3,802014cc <syscall+0x1f0>
    80201350:	02079713          	slli	a4,a5,0x20
    80201354:	01e75793          	srli	a5,a4,0x1e
    80201358:	00003717          	auipc	a4,0x3
    8020135c:	02470713          	addi	a4,a4,36 # 8020437c <e_text+0x37c>
    80201360:	97ba                	add	a5,a5,a4
    80201362:	439c                	lw	a5,0(a5)
    80201364:	97ba                	add	a5,a5,a4
    80201366:	8782                	jr	a5
    80201368:	05d00793          	li	a5,93
    8020136c:	0af48463          	beq	s1,a5,80201414 <syscall+0x138>
    80201370:	0297d263          	bge	a5,s1,80201394 <syscall+0xb8>
    80201374:	07c00793          	li	a5,124
    80201378:	0af48463          	beq	s1,a5,80201420 <syscall+0x144>
    8020137c:	08c00793          	li	a5,140
    80201380:	14f49663          	bne	s1,a5,802014cc <syscall+0x1f0>
		// __builtin_unreachable();
	case SYS_sched_yield:
		ret = sys_sched_yield();
		break;
	case SYS_setpriority:
		ret = sys_set_priority(args[0]);
    80201384:	854e                	mv	a0,s3
    80201386:	00000097          	auipc	ra,0x0
    8020138a:	ee8080e7          	jalr	-280(ra) # 8020126e <sys_set_priority>
    8020138e:	0005059b          	sext.w	a1,a0
		break;
    80201392:	a025                	j	802013ba <syscall+0xde>
	switch (id) {
    80201394:	03f00793          	li	a5,63
    80201398:	06f48363          	beq	s1,a5,802013fe <syscall+0x122>
    8020139c:	04000793          	li	a5,64
    802013a0:	12f49663          	bne	s1,a5,802014cc <syscall+0x1f0>
		ret = sys_write(args[0], args[1], args[2]);
    802013a4:	000a861b          	sext.w	a2,s5
    802013a8:	85d2                	mv	a1,s4
    802013aa:	0009851b          	sext.w	a0,s3
    802013ae:	00000097          	auipc	ra,0x0
    802013b2:	9ec080e7          	jalr	-1556(ra) # 80200d9a <sys_write>
    802013b6:	0005059b          	sext.w	a1,a0
		break;
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
    802013ba:	06b93823          	sd	a1,112(s2)
	tracef("syscall ret %d", ret);
    802013be:	4501                	li	a0,0
    802013c0:	fffff097          	auipc	ra,0xfffff
    802013c4:	4d2080e7          	jalr	1234(ra) # 80200892 <dummy>
}
    802013c8:	60a6                	ld	ra,72(sp)
    802013ca:	6406                	ld	s0,64(sp)
    802013cc:	74e2                	ld	s1,56(sp)
    802013ce:	7942                	ld	s2,48(sp)
    802013d0:	79a2                	ld	s3,40(sp)
    802013d2:	7a02                	ld	s4,32(sp)
    802013d4:	6ae2                	ld	s5,24(sp)
    802013d6:	6b42                	ld	s6,16(sp)
    802013d8:	6ba2                	ld	s7,8(sp)
    802013da:	6161                	addi	sp,sp,80
    802013dc:	8082                	ret
	switch (id) {
    802013de:	10400793          	li	a5,260
    802013e2:	08f48c63          	beq	s1,a5,8020147a <syscall+0x19e>
    802013e6:	19000793          	li	a5,400
    802013ea:	0ef49163          	bne	s1,a5,802014cc <syscall+0x1f0>
		ret = sys_spawn(args[0]);
    802013ee:	854e                	mv	a0,s3
    802013f0:	00000097          	auipc	ra,0x0
    802013f4:	df8080e7          	jalr	-520(ra) # 802011e8 <sys_spawn>
    802013f8:	0005059b          	sext.w	a1,a0
		break;
    802013fc:	bf7d                	j	802013ba <syscall+0xde>
		ret = sys_read(args[0], args[1], args[2]);
    802013fe:	8656                	mv	a2,s5
    80201400:	85d2                	mv	a1,s4
    80201402:	0009851b          	sext.w	a0,s3
    80201406:	00000097          	auipc	ra,0x0
    8020140a:	a34080e7          	jalr	-1484(ra) # 80200e3a <sys_read>
    8020140e:	0005059b          	sext.w	a1,a0
		break;
    80201412:	b765                	j	802013ba <syscall+0xde>
	exit(code);
    80201414:	0009851b          	sext.w	a0,s3
    80201418:	00001097          	auipc	ra,0x1
    8020141c:	3da080e7          	jalr	986(ra) # 802027f2 <exit>
	yield();
    80201420:	00001097          	auipc	ra,0x1
    80201424:	116080e7          	jalr	278(ra) # 80202536 <yield>
		ret = sys_sched_yield();
    80201428:	4581                	li	a1,0
		break;
    8020142a:	bf41                	j	802013ba <syscall+0xde>
		ret = sys_gettimeofday(args[0], args[1]);
    8020142c:	000a059b          	sext.w	a1,s4
    80201430:	854e                	mv	a0,s3
    80201432:	00000097          	auipc	ra,0x0
    80201436:	aae080e7          	jalr	-1362(ra) # 80200ee0 <sys_gettimeofday>
    8020143a:	0005059b          	sext.w	a1,a0
		break;
    8020143e:	bfb5                	j	802013ba <syscall+0xde>
		ret = sys_getpid();
    80201440:	00000097          	auipc	ra,0x0
    80201444:	b08080e7          	jalr	-1272(ra) # 80200f48 <sys_getpid>
    80201448:	0005059b          	sext.w	a1,a0
		break;
    8020144c:	b7bd                	j	802013ba <syscall+0xde>
		ret = sys_getppid();
    8020144e:	00000097          	auipc	ra,0x0
    80201452:	b14080e7          	jalr	-1260(ra) # 80200f62 <sys_getppid>
    80201456:	0005059b          	sext.w	a1,a0
		break;
    8020145a:	b785                	j	802013ba <syscall+0xde>
		ret = sys_clone();
    8020145c:	00000097          	auipc	ra,0x0
    80201460:	b26080e7          	jalr	-1242(ra) # 80200f82 <sys_clone>
    80201464:	0005059b          	sext.w	a1,a0
		break;
    80201468:	bf89                	j	802013ba <syscall+0xde>
		ret = sys_exec(args[0]);
    8020146a:	854e                	mv	a0,s3
    8020146c:	00000097          	auipc	ra,0x0
    80201470:	cf4080e7          	jalr	-780(ra) # 80201160 <sys_exec>
    80201474:	0005059b          	sext.w	a1,a0
		break;
    80201478:	b789                	j	802013ba <syscall+0xde>
		ret = sys_wait(args[0], args[1]);
    8020147a:	85d2                	mv	a1,s4
    8020147c:	0009851b          	sext.w	a0,s3
    80201480:	00000097          	auipc	ra,0x0
    80201484:	d2c080e7          	jalr	-724(ra) # 802011ac <sys_wait>
    80201488:	0005059b          	sext.w	a1,a0
		break;
    8020148c:	b73d                	j	802013ba <syscall+0xde>
		ret = sys_sbrk(args[0]);
    8020148e:	0009851b          	sext.w	a0,s3
    80201492:	00000097          	auipc	ra,0x0
    80201496:	e10080e7          	jalr	-496(ra) # 802012a2 <sys_sbrk>
    8020149a:	0005059b          	sext.w	a1,a0
		break;
    8020149e:	bf31                	j	802013ba <syscall+0xde>
		ret = sys_mmap((void *)args[0], args[1], args[2], args[3],
    802014a0:	000b871b          	sext.w	a4,s7
    802014a4:	000b069b          	sext.w	a3,s6
    802014a8:	000a861b          	sext.w	a2,s5
    802014ac:	85d2                	mv	a1,s4
    802014ae:	854e                	mv	a0,s3
    802014b0:	00000097          	auipc	ra,0x0
    802014b4:	af4080e7          	jalr	-1292(ra) # 80200fa4 <sys_mmap>
    802014b8:	85aa                	mv	a1,a0
		break;
    802014ba:	b701                	j	802013ba <syscall+0xde>
		ret = sys_munmap((void *)args[0], args[1]);
    802014bc:	85d2                	mv	a1,s4
    802014be:	854e                	mv	a0,s3
    802014c0:	00000097          	auipc	ra,0x0
    802014c4:	bda080e7          	jalr	-1062(ra) # 8020109a <sys_munmap>
    802014c8:	85aa                	mv	a1,a0
		break;
    802014ca:	bdc5                	j	802013ba <syscall+0xde>
		errorf("unknown syscall %d", id);
    802014cc:	00001097          	auipc	ra,0x1
    802014d0:	d1a080e7          	jalr	-742(ra) # 802021e6 <threadid>
    802014d4:	86aa                	mv	a3,a0
    802014d6:	8726                	mv	a4,s1
    802014d8:	00003617          	auipc	a2,0x3
    802014dc:	ca060613          	addi	a2,a2,-864 # 80204178 <e_text+0x178>
    802014e0:	45fd                	li	a1,31
    802014e2:	00003517          	auipc	a0,0x3
    802014e6:	e7650513          	addi	a0,a0,-394 # 80204358 <e_text+0x358>
    802014ea:	00001097          	auipc	ra,0x1
    802014ee:	480080e7          	jalr	1152(ra) # 8020296a <printf>
		ret = -1;
    802014f2:	55fd                	li	a1,-1
    802014f4:	b5d9                	j	802013ba <syscall+0xde>

00000000802014f6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    802014f6:	7139                	addi	sp,sp,-64
    802014f8:	fc06                	sd	ra,56(sp)
    802014fa:	f822                	sd	s0,48(sp)
    802014fc:	f426                	sd	s1,40(sp)
    802014fe:	f04a                	sd	s2,32(sp)
    80201500:	ec4e                	sd	s3,24(sp)
    80201502:	e852                	sd	s4,16(sp)
    80201504:	e456                	sd	s5,8(sp)
    80201506:	e05a                	sd	s6,0(sp)
    80201508:	0080                	addi	s0,sp,64
    8020150a:	84aa                	mv	s1,a0
    8020150c:	89ae                	mv	s3,a1
    8020150e:	8ab2                	mv	s5,a2
	if (va >= MAXVA)
    80201510:	57fd                	li	a5,-1
    80201512:	83e9                	srli	a5,a5,0x1a
    80201514:	00b7e563          	bltu	a5,a1,8020151e <walk+0x28>
{
    80201518:	4a79                	li	s4,30
		panic("walk");

	for (int level = 2; level > 0; level--) {
    8020151a:	4b31                	li	s6,12
    8020151c:	a0b5                	j	80201588 <walk+0x92>
		panic("walk");
    8020151e:	00001097          	auipc	ra,0x1
    80201522:	cc8080e7          	jalr	-824(ra) # 802021e6 <threadid>
    80201526:	86aa                	mv	a3,a0
    80201528:	03700793          	li	a5,55
    8020152c:	00003717          	auipc	a4,0x3
    80201530:	f2c70713          	addi	a4,a4,-212 # 80204458 <e_text+0x458>
    80201534:	00003617          	auipc	a2,0x3
    80201538:	adc60613          	addi	a2,a2,-1316 # 80204010 <e_text+0x10>
    8020153c:	45fd                	li	a1,31
    8020153e:	00003517          	auipc	a0,0x3
    80201542:	f2250513          	addi	a0,a0,-222 # 80204460 <e_text+0x460>
    80201546:	00001097          	auipc	ra,0x1
    8020154a:	424080e7          	jalr	1060(ra) # 8020296a <printf>
    8020154e:	00001097          	auipc	ra,0x1
    80201552:	c6a080e7          	jalr	-918(ra) # 802021b8 <shutdown>
    80201556:	b7c9                	j	80201518 <walk+0x22>
		pte_t *pte = &pagetable[PX(level, va)];
		if (*pte & PTE_V) {
			pagetable = (pagetable_t)PTE2PA(*pte);
		} else {
			if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80201558:	060a8663          	beqz	s5,802015c4 <walk+0xce>
    8020155c:	00001097          	auipc	ra,0x1
    80201560:	bf4080e7          	jalr	-1036(ra) # 80202150 <kalloc>
    80201564:	84aa                	mv	s1,a0
    80201566:	c529                	beqz	a0,802015b0 <walk+0xba>
				return 0;
			memset(pagetable, 0, PGSIZE);
    80201568:	6605                	lui	a2,0x1
    8020156a:	4581                	li	a1,0
    8020156c:	fffff097          	auipc	ra,0xfffff
    80201570:	178080e7          	jalr	376(ra) # 802006e4 <memset>
			*pte = PA2PTE(pagetable) | PTE_V;
    80201574:	00c4d793          	srli	a5,s1,0xc
    80201578:	07aa                	slli	a5,a5,0xa
    8020157a:	0017e793          	ori	a5,a5,1
    8020157e:	00f93023          	sd	a5,0(s2)
	for (int level = 2; level > 0; level--) {
    80201582:	3a5d                	addiw	s4,s4,-9
    80201584:	036a0063          	beq	s4,s6,802015a4 <walk+0xae>
		pte_t *pte = &pagetable[PX(level, va)];
    80201588:	0149d933          	srl	s2,s3,s4
    8020158c:	1ff97913          	andi	s2,s2,511
    80201590:	090e                	slli	s2,s2,0x3
    80201592:	9926                	add	s2,s2,s1
		if (*pte & PTE_V) {
    80201594:	00093483          	ld	s1,0(s2)
    80201598:	0014f793          	andi	a5,s1,1
    8020159c:	dfd5                	beqz	a5,80201558 <walk+0x62>
			pagetable = (pagetable_t)PTE2PA(*pte);
    8020159e:	80a9                	srli	s1,s1,0xa
    802015a0:	04b2                	slli	s1,s1,0xc
    802015a2:	b7c5                	j	80201582 <walk+0x8c>
		}
	}
	return &pagetable[PX(0, va)];
    802015a4:	00c9d513          	srli	a0,s3,0xc
    802015a8:	1ff57513          	andi	a0,a0,511
    802015ac:	050e                	slli	a0,a0,0x3
    802015ae:	9526                	add	a0,a0,s1
}
    802015b0:	70e2                	ld	ra,56(sp)
    802015b2:	7442                	ld	s0,48(sp)
    802015b4:	74a2                	ld	s1,40(sp)
    802015b6:	7902                	ld	s2,32(sp)
    802015b8:	69e2                	ld	s3,24(sp)
    802015ba:	6a42                	ld	s4,16(sp)
    802015bc:	6aa2                	ld	s5,8(sp)
    802015be:	6b02                	ld	s6,0(sp)
    802015c0:	6121                	addi	sp,sp,64
    802015c2:	8082                	ret
				return 0;
    802015c4:	4501                	li	a0,0
    802015c6:	b7ed                	j	802015b0 <walk+0xba>

00000000802015c8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
	pte_t *pte;
	uint64 pa;

	if (va >= MAXVA)
    802015c8:	57fd                	li	a5,-1
    802015ca:	83e9                	srli	a5,a5,0x1a
    802015cc:	00b7f463          	bgeu	a5,a1,802015d4 <walkaddr+0xc>
		return 0;
    802015d0:	4501                	li	a0,0
		return 0;
	pa = PTE2PA(*pte);
	if (pa == 0)
		return 1;
	return pa;
}
    802015d2:	8082                	ret
{
    802015d4:	1141                	addi	sp,sp,-16
    802015d6:	e406                	sd	ra,8(sp)
    802015d8:	e022                	sd	s0,0(sp)
    802015da:	0800                	addi	s0,sp,16
	pte = walk(pagetable, va, 0);
    802015dc:	4601                	li	a2,0
    802015de:	00000097          	auipc	ra,0x0
    802015e2:	f18080e7          	jalr	-232(ra) # 802014f6 <walk>
	if (pte == 0)
    802015e6:	c115                	beqz	a0,8020160a <walkaddr+0x42>
	if ((*pte & PTE_V) == 0)
    802015e8:	611c                	ld	a5,0(a0)
	if ((*pte & PTE_U) == 0)
    802015ea:	0117f693          	andi	a3,a5,17
    802015ee:	4745                	li	a4,17
		return 0;
    802015f0:	4501                	li	a0,0
	if ((*pte & PTE_U) == 0)
    802015f2:	00e68663          	beq	a3,a4,802015fe <walkaddr+0x36>
}
    802015f6:	60a2                	ld	ra,8(sp)
    802015f8:	6402                	ld	s0,0(sp)
    802015fa:	0141                	addi	sp,sp,16
    802015fc:	8082                	ret
	pa = PTE2PA(*pte);
    802015fe:	00a7d513          	srli	a0,a5,0xa
    80201602:	0532                	slli	a0,a0,0xc
    80201604:	f96d                	bnez	a0,802015f6 <walkaddr+0x2e>
    80201606:	4505                	li	a0,1
    80201608:	b7fd                	j	802015f6 <walkaddr+0x2e>
		return 0;
    8020160a:	4501                	li	a0,0
    8020160c:	b7ed                	j	802015f6 <walkaddr+0x2e>

000000008020160e <useraddr>:

// Look up a virtual address, return the physical address,
uint64
useraddr(pagetable_t pagetable, uint64 va)
{
    8020160e:	1101                	addi	sp,sp,-32
    80201610:	ec06                	sd	ra,24(sp)
    80201612:	e822                	sd	s0,16(sp)
    80201614:	e426                	sd	s1,8(sp)
    80201616:	1000                	addi	s0,sp,32
    80201618:	84ae                	mv	s1,a1
	uint64 page = walkaddr(pagetable, va);
    8020161a:	00000097          	auipc	ra,0x0
    8020161e:	fae080e7          	jalr	-82(ra) # 802015c8 <walkaddr>
	if (page == 0)
    80201622:	c509                	beqz	a0,8020162c <useraddr+0x1e>
		return 0;
	return page | (va & 0xFFFULL);
    80201624:	03449593          	slli	a1,s1,0x34
    80201628:	91d1                	srli	a1,a1,0x34
    8020162a:	8d4d                	or	a0,a0,a1
}
    8020162c:	60e2                	ld	ra,24(sp)
    8020162e:	6442                	ld	s0,16(sp)
    80201630:	64a2                	ld	s1,8(sp)
    80201632:	6105                	addi	sp,sp,32
    80201634:	8082                	ret

0000000080201636 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80201636:	715d                	addi	sp,sp,-80
    80201638:	e486                	sd	ra,72(sp)
    8020163a:	e0a2                	sd	s0,64(sp)
    8020163c:	fc26                	sd	s1,56(sp)
    8020163e:	f84a                	sd	s2,48(sp)
    80201640:	f44e                	sd	s3,40(sp)
    80201642:	f052                	sd	s4,32(sp)
    80201644:	ec56                	sd	s5,24(sp)
    80201646:	e85a                	sd	s6,16(sp)
    80201648:	e45e                	sd	s7,8(sp)
    8020164a:	0880                	addi	s0,sp,80
    8020164c:	8aaa                	mv	s5,a0
    8020164e:	8b3a                	mv	s6,a4
	uint64 a, last;
	pte_t *pte;

	a = PGROUNDDOWN(va);
    80201650:	777d                	lui	a4,0xfffff
    80201652:	00e5f7b3          	and	a5,a1,a4
	last = PGROUNDDOWN(va + size - 1);
    80201656:	167d                	addi	a2,a2,-1
    80201658:	00b609b3          	add	s3,a2,a1
    8020165c:	00e9f9b3          	and	s3,s3,a4
	a = PGROUNDDOWN(va);
    80201660:	893e                	mv	s2,a5
    80201662:	40f68a33          	sub	s4,a3,a5
			return -1;
		}
		*pte = PA2PTE(pa) | perm | PTE_V;
		if (a == last)
			break;
		a += PGSIZE;
    80201666:	6b85                	lui	s7,0x1
    80201668:	a0ad                	j	802016d2 <mappages+0x9c>
			errorf("pte invalid, va = %p", a);
    8020166a:	00001097          	auipc	ra,0x1
    8020166e:	b7c080e7          	jalr	-1156(ra) # 802021e6 <threadid>
    80201672:	86aa                	mv	a3,a0
    80201674:	874a                	mv	a4,s2
    80201676:	00003617          	auipc	a2,0x3
    8020167a:	b0260613          	addi	a2,a2,-1278 # 80204178 <e_text+0x178>
    8020167e:	45fd                	li	a1,31
    80201680:	00003517          	auipc	a0,0x3
    80201684:	e0050513          	addi	a0,a0,-512 # 80204480 <e_text+0x480>
    80201688:	00001097          	auipc	ra,0x1
    8020168c:	2e2080e7          	jalr	738(ra) # 8020296a <printf>
			return -1;
    80201690:	557d                	li	a0,-1
		pa += PGSIZE;
	}
	return 0;
}
    80201692:	60a6                	ld	ra,72(sp)
    80201694:	6406                	ld	s0,64(sp)
    80201696:	74e2                	ld	s1,56(sp)
    80201698:	7942                	ld	s2,48(sp)
    8020169a:	79a2                	ld	s3,40(sp)
    8020169c:	7a02                	ld	s4,32(sp)
    8020169e:	6ae2                	ld	s5,24(sp)
    802016a0:	6b42                	ld	s6,16(sp)
    802016a2:	6ba2                	ld	s7,8(sp)
    802016a4:	6161                	addi	sp,sp,80
    802016a6:	8082                	ret
			errorf("remap");
    802016a8:	00001097          	auipc	ra,0x1
    802016ac:	b3e080e7          	jalr	-1218(ra) # 802021e6 <threadid>
    802016b0:	86aa                	mv	a3,a0
    802016b2:	00003617          	auipc	a2,0x3
    802016b6:	ac660613          	addi	a2,a2,-1338 # 80204178 <e_text+0x178>
    802016ba:	45fd                	li	a1,31
    802016bc:	00003517          	auipc	a0,0x3
    802016c0:	dec50513          	addi	a0,a0,-532 # 802044a8 <e_text+0x4a8>
    802016c4:	00001097          	auipc	ra,0x1
    802016c8:	2a6080e7          	jalr	678(ra) # 8020296a <printf>
			return -1;
    802016cc:	557d                	li	a0,-1
    802016ce:	b7d1                	j	80201692 <mappages+0x5c>
		a += PGSIZE;
    802016d0:	995e                	add	s2,s2,s7
	for (;;) {
    802016d2:	012a04b3          	add	s1,s4,s2
		if ((pte = walk(pagetable, a, 1)) == 0) {
    802016d6:	4605                	li	a2,1
    802016d8:	85ca                	mv	a1,s2
    802016da:	8556                	mv	a0,s5
    802016dc:	00000097          	auipc	ra,0x0
    802016e0:	e1a080e7          	jalr	-486(ra) # 802014f6 <walk>
    802016e4:	d159                	beqz	a0,8020166a <mappages+0x34>
		if (*pte & PTE_V) {
    802016e6:	611c                	ld	a5,0(a0)
    802016e8:	8b85                	andi	a5,a5,1
    802016ea:	ffdd                	bnez	a5,802016a8 <mappages+0x72>
		*pte = PA2PTE(pa) | perm | PTE_V;
    802016ec:	80b1                	srli	s1,s1,0xc
    802016ee:	04aa                	slli	s1,s1,0xa
    802016f0:	0164e4b3          	or	s1,s1,s6
    802016f4:	0014e493          	ori	s1,s1,1
    802016f8:	e104                	sd	s1,0(a0)
		if (a == last)
    802016fa:	fd391be3          	bne	s2,s3,802016d0 <mappages+0x9a>
	return 0;
    802016fe:	4501                	li	a0,0
    80201700:	bf49                	j	80201692 <mappages+0x5c>

0000000080201702 <kvmmap>:
{
    80201702:	1141                	addi	sp,sp,-16
    80201704:	e406                	sd	ra,8(sp)
    80201706:	e022                	sd	s0,0(sp)
    80201708:	0800                	addi	s0,sp,16
    8020170a:	87b6                	mv	a5,a3
	if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8020170c:	86b2                	mv	a3,a2
    8020170e:	863e                	mv	a2,a5
    80201710:	00000097          	auipc	ra,0x0
    80201714:	f26080e7          	jalr	-218(ra) # 80201636 <mappages>
    80201718:	e509                	bnez	a0,80201722 <kvmmap+0x20>
}
    8020171a:	60a2                	ld	ra,8(sp)
    8020171c:	6402                	ld	s0,0(sp)
    8020171e:	0141                	addi	sp,sp,16
    80201720:	8082                	ret
		panic("kvmmap");
    80201722:	00001097          	auipc	ra,0x1
    80201726:	ac4080e7          	jalr	-1340(ra) # 802021e6 <threadid>
    8020172a:	86aa                	mv	a3,a0
    8020172c:	07100793          	li	a5,113
    80201730:	00003717          	auipc	a4,0x3
    80201734:	d2870713          	addi	a4,a4,-728 # 80204458 <e_text+0x458>
    80201738:	00003617          	auipc	a2,0x3
    8020173c:	8d860613          	addi	a2,a2,-1832 # 80204010 <e_text+0x10>
    80201740:	45fd                	li	a1,31
    80201742:	00003517          	auipc	a0,0x3
    80201746:	d7e50513          	addi	a0,a0,-642 # 802044c0 <e_text+0x4c0>
    8020174a:	00001097          	auipc	ra,0x1
    8020174e:	220080e7          	jalr	544(ra) # 8020296a <printf>
    80201752:	00001097          	auipc	ra,0x1
    80201756:	a66080e7          	jalr	-1434(ra) # 802021b8 <shutdown>
}
    8020175a:	b7c1                	j	8020171a <kvmmap+0x18>

000000008020175c <kvmmake>:
{
    8020175c:	1101                	addi	sp,sp,-32
    8020175e:	ec06                	sd	ra,24(sp)
    80201760:	e822                	sd	s0,16(sp)
    80201762:	e426                	sd	s1,8(sp)
    80201764:	e04a                	sd	s2,0(sp)
    80201766:	1000                	addi	s0,sp,32
	kpgtbl = (pagetable_t)kalloc();
    80201768:	00001097          	auipc	ra,0x1
    8020176c:	9e8080e7          	jalr	-1560(ra) # 80202150 <kalloc>
    80201770:	84aa                	mv	s1,a0
	memset(kpgtbl, 0, PGSIZE);
    80201772:	6605                	lui	a2,0x1
    80201774:	4581                	li	a1,0
    80201776:	fffff097          	auipc	ra,0xfffff
    8020177a:	f6e080e7          	jalr	-146(ra) # 802006e4 <memset>
	kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)e_text - KERNBASE,
    8020177e:	00003917          	auipc	s2,0x3
    80201782:	88290913          	addi	s2,s2,-1918 # 80204000 <e_text>
    80201786:	4729                	li	a4,10
    80201788:	bff00693          	li	a3,-1025
    8020178c:	06d6                	slli	a3,a3,0x15
    8020178e:	96ca                	add	a3,a3,s2
    80201790:	40100613          	li	a2,1025
    80201794:	0656                	slli	a2,a2,0x15
    80201796:	85b2                	mv	a1,a2
    80201798:	8526                	mv	a0,s1
    8020179a:	00000097          	auipc	ra,0x0
    8020179e:	f68080e7          	jalr	-152(ra) # 80201702 <kvmmap>
	kvmmap(kpgtbl, (uint64)e_text, (uint64)e_text, PHYSTOP - (uint64)e_text,
    802017a2:	4719                	li	a4,6
    802017a4:	46c5                	li	a3,17
    802017a6:	06ee                	slli	a3,a3,0x1b
    802017a8:	412686b3          	sub	a3,a3,s2
    802017ac:	864a                	mv	a2,s2
    802017ae:	85ca                	mv	a1,s2
    802017b0:	8526                	mv	a0,s1
    802017b2:	00000097          	auipc	ra,0x0
    802017b6:	f50080e7          	jalr	-176(ra) # 80201702 <kvmmap>
	kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    802017ba:	4729                	li	a4,10
    802017bc:	6685                	lui	a3,0x1
    802017be:	00002617          	auipc	a2,0x2
    802017c2:	84260613          	addi	a2,a2,-1982 # 80203000 <trampoline>
    802017c6:	040005b7          	lui	a1,0x4000
    802017ca:	15fd                	addi	a1,a1,-1
    802017cc:	05b2                	slli	a1,a1,0xc
    802017ce:	8526                	mv	a0,s1
    802017d0:	00000097          	auipc	ra,0x0
    802017d4:	f32080e7          	jalr	-206(ra) # 80201702 <kvmmap>
}
    802017d8:	8526                	mv	a0,s1
    802017da:	60e2                	ld	ra,24(sp)
    802017dc:	6442                	ld	s0,16(sp)
    802017de:	64a2                	ld	s1,8(sp)
    802017e0:	6902                	ld	s2,0(sp)
    802017e2:	6105                	addi	sp,sp,32
    802017e4:	8082                	ret

00000000802017e6 <kvm_init>:
{
    802017e6:	1141                	addi	sp,sp,-16
    802017e8:	e406                	sd	ra,8(sp)
    802017ea:	e022                	sd	s0,0(sp)
    802017ec:	0800                	addi	s0,sp,16
	kernel_pagetable = kvmmake();
    802017ee:	00000097          	auipc	ra,0x0
    802017f2:	f6e080e7          	jalr	-146(ra) # 8020175c <kvmmake>
    802017f6:	00496797          	auipc	a5,0x496
    802017fa:	80a7bd23          	sd	a0,-2022(a5) # 80697010 <kernel_pagetable>
	w_satp(MAKE_SATP(kernel_pagetable));
    802017fe:	8131                	srli	a0,a0,0xc
    80201800:	57fd                	li	a5,-1
    80201802:	17fe                	slli	a5,a5,0x3f
    80201804:	8d5d                	or	a0,a0,a5
	asm volatile("csrw satp, %0" : : "r"(x));
    80201806:	18051073          	csrw	satp,a0

// flush the TLB.
static inline void sfence_vma()
{
	// the zero, zero means flush all TLB entries.
	asm volatile("sfence.vma zero, zero");
    8020180a:	12000073          	sfence.vma
	asm volatile("csrr %0, satp" : "=r"(x));
    8020180e:	180025f3          	csrr	a1,satp
	infof("enable pageing at %p", r_satp());
    80201812:	4501                	li	a0,0
    80201814:	fffff097          	auipc	ra,0xfffff
    80201818:	07e080e7          	jalr	126(ra) # 80200892 <dummy>
}
    8020181c:	60a2                	ld	ra,8(sp)
    8020181e:	6402                	ld	s0,0(sp)
    80201820:	0141                	addi	sp,sp,16
    80201822:	8082                	ret

0000000080201824 <lazy_mappages>:

// Alloc pages in a lazy way
int
lazy_mappages(pagetable_t pagetable, uint64 va, uint64 size, int perm)
{
    80201824:	7139                	addi	sp,sp,-64
    80201826:	fc06                	sd	ra,56(sp)
    80201828:	f822                	sd	s0,48(sp)
    8020182a:	f426                	sd	s1,40(sp)
    8020182c:	f04a                	sd	s2,32(sp)
    8020182e:	ec4e                	sd	s3,24(sp)
    80201830:	e852                	sd	s4,16(sp)
    80201832:	e456                	sd	s5,8(sp)
    80201834:	0080                	addi	s0,sp,64
    80201836:	89aa                	mv	s3,a0
	uint64 a, last;
	pte_t *pte;

	a = PGROUNDDOWN(va);
    80201838:	77fd                	lui	a5,0xfffff
    8020183a:	00f5f4b3          	and	s1,a1,a5
	last = PGROUNDDOWN(va + size - 1);
    8020183e:	167d                	addi	a2,a2,-1
    80201840:	00b60933          	add	s2,a2,a1
    80201844:	00f97933          	and	s2,s2,a5
			return -1;
		if (*pte & PTE_V) {
			errorf("same address remap");
			return -1;
		}
		*pte = perm | PTE_V;
    80201848:	0016ea13          	ori	s4,a3,1
		if (a == last)
			break;
		a += PGSIZE;
    8020184c:	6a85                	lui	s5,0x1
    8020184e:	a035                	j	8020187a <lazy_mappages+0x56>
			errorf("same address remap");
    80201850:	00001097          	auipc	ra,0x1
    80201854:	996080e7          	jalr	-1642(ra) # 802021e6 <threadid>
    80201858:	86aa                	mv	a3,a0
    8020185a:	00003617          	auipc	a2,0x3
    8020185e:	91e60613          	addi	a2,a2,-1762 # 80204178 <e_text+0x178>
    80201862:	45fd                	li	a1,31
    80201864:	00003517          	auipc	a0,0x3
    80201868:	c7c50513          	addi	a0,a0,-900 # 802044e0 <e_text+0x4e0>
    8020186c:	00001097          	auipc	ra,0x1
    80201870:	0fe080e7          	jalr	254(ra) # 8020296a <printf>
			return -1;
    80201874:	557d                	li	a0,-1
    80201876:	a025                	j	8020189e <lazy_mappages+0x7a>
		a += PGSIZE;
    80201878:	94d6                	add	s1,s1,s5
		if ((pte = walk(pagetable, a, 1)) == 0)
    8020187a:	4605                	li	a2,1
    8020187c:	85a6                	mv	a1,s1
    8020187e:	854e                	mv	a0,s3
    80201880:	00000097          	auipc	ra,0x0
    80201884:	c76080e7          	jalr	-906(ra) # 802014f6 <walk>
    80201888:	c911                	beqz	a0,8020189c <lazy_mappages+0x78>
		if (*pte & PTE_V) {
    8020188a:	611c                	ld	a5,0(a0)
    8020188c:	8b85                	andi	a5,a5,1
    8020188e:	f3e9                	bnez	a5,80201850 <lazy_mappages+0x2c>
		*pte = perm | PTE_V;
    80201890:	01453023          	sd	s4,0(a0)
		if (a == last)
    80201894:	ff2492e3          	bne	s1,s2,80201878 <lazy_mappages+0x54>
	}
	return 0;
    80201898:	4501                	li	a0,0
    8020189a:	a011                	j	8020189e <lazy_mappages+0x7a>
			return -1;
    8020189c:	557d                	li	a0,-1
}
    8020189e:	70e2                	ld	ra,56(sp)
    802018a0:	7442                	ld	s0,48(sp)
    802018a2:	74a2                	ld	s1,40(sp)
    802018a4:	7902                	ld	s2,32(sp)
    802018a6:	69e2                	ld	s3,24(sp)
    802018a8:	6a42                	ld	s4,16(sp)
    802018aa:	6aa2                	ld	s5,8(sp)
    802018ac:	6121                	addi	sp,sp,64
    802018ae:	8082                	ret

00000000802018b0 <user_pagefault>:

// Handle user pagefault
int
user_pagefault(pagetable_t pagetable, uint64 va, uint64 pa)
{
    802018b0:	1101                	addi	sp,sp,-32
    802018b2:	ec06                	sd	ra,24(sp)
    802018b4:	e822                	sd	s0,16(sp)
    802018b6:	e426                	sd	s1,8(sp)
    802018b8:	1000                	addi	s0,sp,32
    802018ba:	84b2                	mv	s1,a2
	uint64 a = PGROUNDDOWN(va);
	pte_t *pte;

	if ((pte = walk(pagetable, a, 0)) == 0) {
    802018bc:	4601                	li	a2,0
    802018be:	77fd                	lui	a5,0xfffff
    802018c0:	8dfd                	and	a1,a1,a5
    802018c2:	00000097          	auipc	ra,0x0
    802018c6:	c34080e7          	jalr	-972(ra) # 802014f6 <walk>
    802018ca:	c105                	beqz	a0,802018ea <user_pagefault+0x3a>
		return -1;
	}

	if (*pte & PTE_V) {
    802018cc:	611c                	ld	a5,0(a0)
    802018ce:	0017f713          	andi	a4,a5,1
    802018d2:	cf11                	beqz	a4,802018ee <user_pagefault+0x3e>
		*pte |= PA2PTE(pa);
    802018d4:	00c4d613          	srli	a2,s1,0xc
    802018d8:	062a                	slli	a2,a2,0xa
    802018da:	8e5d                	or	a2,a2,a5
    802018dc:	e110                	sd	a2,0(a0)
		return 0;
    802018de:	4501                	li	a0,0
	}

	return -1;
}
    802018e0:	60e2                	ld	ra,24(sp)
    802018e2:	6442                	ld	s0,16(sp)
    802018e4:	64a2                	ld	s1,8(sp)
    802018e6:	6105                	addi	sp,sp,32
    802018e8:	8082                	ret
		return -1;
    802018ea:	557d                	li	a0,-1
    802018ec:	bfd5                	j	802018e0 <user_pagefault+0x30>
	return -1;
    802018ee:	557d                	li	a0,-1
    802018f0:	bfc5                	j	802018e0 <user_pagefault+0x30>

00000000802018f2 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    802018f2:	711d                	addi	sp,sp,-96
    802018f4:	ec86                	sd	ra,88(sp)
    802018f6:	e8a2                	sd	s0,80(sp)
    802018f8:	e4a6                	sd	s1,72(sp)
    802018fa:	e0ca                	sd	s2,64(sp)
    802018fc:	fc4e                	sd	s3,56(sp)
    802018fe:	f852                	sd	s4,48(sp)
    80201900:	f456                	sd	s5,40(sp)
    80201902:	f05a                	sd	s6,32(sp)
    80201904:	ec5e                	sd	s7,24(sp)
    80201906:	e862                	sd	s8,16(sp)
    80201908:	e466                	sd	s9,8(sp)
    8020190a:	e06a                	sd	s10,0(sp)
    8020190c:	1080                	addi	s0,sp,96
    8020190e:	8a2a                	mv	s4,a0
    80201910:	892e                	mv	s2,a1
    80201912:	89b2                	mv	s3,a2
    80201914:	8b36                	mv	s6,a3
	uint64 a;
	pte_t *pte;

	if ((va % PGSIZE) != 0)
    80201916:	03459793          	slli	a5,a1,0x34
    8020191a:	e785                	bnez	a5,80201942 <uvmunmap+0x50>
		panic("uvmunmap: not aligned");

	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8020191c:	09b2                	slli	s3,s3,0xc
    8020191e:	99ca                	add	s3,s3,s2
    80201920:	0d397363          	bgeu	s2,s3,802019e6 <uvmunmap+0xf4>
		if ((pte = walk(pagetable, a, 0)) == 0)
			continue;
		if ((*pte & PTE_V) != 0) {
			if (PTE_FLAGS(*pte) == PTE_V)
    80201924:	4b85                	li	s7,1
				panic("uvmunmap: not a leaf");
    80201926:	00003d17          	auipc	s10,0x3
    8020192a:	b32d0d13          	addi	s10,s10,-1230 # 80204458 <e_text+0x458>
    8020192e:	00002c97          	auipc	s9,0x2
    80201932:	6e2c8c93          	addi	s9,s9,1762 # 80204010 <e_text+0x10>
    80201936:	00003c17          	auipc	s8,0x3
    8020193a:	c02c0c13          	addi	s8,s8,-1022 # 80204538 <e_text+0x538>
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8020193e:	6a85                	lui	s5,0x1
    80201940:	a0bd                	j	802019ae <uvmunmap+0xbc>
		panic("uvmunmap: not aligned");
    80201942:	00001097          	auipc	ra,0x1
    80201946:	8a4080e7          	jalr	-1884(ra) # 802021e6 <threadid>
    8020194a:	86aa                	mv	a3,a0
    8020194c:	0c700793          	li	a5,199
    80201950:	00003717          	auipc	a4,0x3
    80201954:	b0870713          	addi	a4,a4,-1272 # 80204458 <e_text+0x458>
    80201958:	00002617          	auipc	a2,0x2
    8020195c:	6b860613          	addi	a2,a2,1720 # 80204010 <e_text+0x10>
    80201960:	45fd                	li	a1,31
    80201962:	00003517          	auipc	a0,0x3
    80201966:	ba650513          	addi	a0,a0,-1114 # 80204508 <e_text+0x508>
    8020196a:	00001097          	auipc	ra,0x1
    8020196e:	000080e7          	jalr	ra # 8020296a <printf>
    80201972:	00001097          	auipc	ra,0x1
    80201976:	846080e7          	jalr	-1978(ra) # 802021b8 <shutdown>
    8020197a:	b74d                	j	8020191c <uvmunmap+0x2a>
				panic("uvmunmap: not a leaf");
    8020197c:	00001097          	auipc	ra,0x1
    80201980:	86a080e7          	jalr	-1942(ra) # 802021e6 <threadid>
    80201984:	86aa                	mv	a3,a0
    80201986:	0ce00793          	li	a5,206
    8020198a:	876a                	mv	a4,s10
    8020198c:	8666                	mv	a2,s9
    8020198e:	45fd                	li	a1,31
    80201990:	8562                	mv	a0,s8
    80201992:	00001097          	auipc	ra,0x1
    80201996:	fd8080e7          	jalr	-40(ra) # 8020296a <printf>
    8020199a:	00001097          	auipc	ra,0x1
    8020199e:	81e080e7          	jalr	-2018(ra) # 802021b8 <shutdown>
    802019a2:	a03d                	j	802019d0 <uvmunmap+0xde>
				if (pa != 0) {
					kfree((void *)pa);
				}
			}
		}
		*pte = 0;
    802019a4:	0004b023          	sd	zero,0(s1)
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    802019a8:	9956                	add	s2,s2,s5
    802019aa:	03397e63          	bgeu	s2,s3,802019e6 <uvmunmap+0xf4>
		if ((pte = walk(pagetable, a, 0)) == 0)
    802019ae:	4601                	li	a2,0
    802019b0:	85ca                	mv	a1,s2
    802019b2:	8552                	mv	a0,s4
    802019b4:	00000097          	auipc	ra,0x0
    802019b8:	b42080e7          	jalr	-1214(ra) # 802014f6 <walk>
    802019bc:	84aa                	mv	s1,a0
    802019be:	d56d                	beqz	a0,802019a8 <uvmunmap+0xb6>
		if ((*pte & PTE_V) != 0) {
    802019c0:	611c                	ld	a5,0(a0)
    802019c2:	0017f713          	andi	a4,a5,1
    802019c6:	df79                	beqz	a4,802019a4 <uvmunmap+0xb2>
			if (PTE_FLAGS(*pte) == PTE_V)
    802019c8:	3ff7f793          	andi	a5,a5,1023
    802019cc:	fb7788e3          	beq	a5,s7,8020197c <uvmunmap+0x8a>
			if (do_free) {
    802019d0:	fc0b0ae3          	beqz	s6,802019a4 <uvmunmap+0xb2>
				uint64 pa = PTE2PA(*pte);
    802019d4:	6088                	ld	a0,0(s1)
    802019d6:	8129                	srli	a0,a0,0xa
    802019d8:	0532                	slli	a0,a0,0xc
				if (pa != 0) {
    802019da:	d569                	beqz	a0,802019a4 <uvmunmap+0xb2>
					kfree((void *)pa);
    802019dc:	00000097          	auipc	ra,0x0
    802019e0:	682080e7          	jalr	1666(ra) # 8020205e <kfree>
    802019e4:	b7c1                	j	802019a4 <uvmunmap+0xb2>
	}
}
    802019e6:	60e6                	ld	ra,88(sp)
    802019e8:	6446                	ld	s0,80(sp)
    802019ea:	64a6                	ld	s1,72(sp)
    802019ec:	6906                	ld	s2,64(sp)
    802019ee:	79e2                	ld	s3,56(sp)
    802019f0:	7a42                	ld	s4,48(sp)
    802019f2:	7aa2                	ld	s5,40(sp)
    802019f4:	7b02                	ld	s6,32(sp)
    802019f6:	6be2                	ld	s7,24(sp)
    802019f8:	6c42                	ld	s8,16(sp)
    802019fa:	6ca2                	ld	s9,8(sp)
    802019fc:	6d02                	ld	s10,0(sp)
    802019fe:	6125                	addi	sp,sp,96
    80201a00:	8082                	ret

0000000080201a02 <lazy_uvmunmap>:

void
lazy_uvmunmap(pagetable_t pagetable, uint64 va)
{
    80201a02:	1101                	addi	sp,sp,-32
    80201a04:	ec06                	sd	ra,24(sp)
    80201a06:	e822                	sd	s0,16(sp)
    80201a08:	e426                	sd	s1,8(sp)
    80201a0a:	e04a                	sd	s2,0(sp)
    80201a0c:	1000                	addi	s0,sp,32
    80201a0e:	892a                	mv	s2,a0
    80201a10:	84ae                	mv	s1,a1
	pte_t *pte;

	if ((va % PGSIZE) != 0)
    80201a12:	03459793          	slli	a5,a1,0x34
    80201a16:	ef9d                	bnez	a5,80201a54 <lazy_uvmunmap+0x52>
		panic("lazy_uvmunmap: not aligned");

	if ((pte = walk(pagetable, va, 0)) == 0) {
    80201a18:	4601                	li	a2,0
    80201a1a:	85a6                	mv	a1,s1
    80201a1c:	854a                	mv	a0,s2
    80201a1e:	00000097          	auipc	ra,0x0
    80201a22:	ad8080e7          	jalr	-1320(ra) # 802014f6 <walk>
    80201a26:	84aa                	mv	s1,a0
    80201a28:	c105                	beqz	a0,80201a48 <lazy_uvmunmap+0x46>
		return;
	}

	if ((*pte & PTE_V) != 0) {
    80201a2a:	611c                	ld	a5,0(a0)
    80201a2c:	0017f713          	andi	a4,a5,1
    80201a30:	c711                	beqz	a4,80201a3c <lazy_uvmunmap+0x3a>
		if (PTE_FLAGS(*pte) == PTE_V)
    80201a32:	3ff7f793          	andi	a5,a5,1023
    80201a36:	4705                	li	a4,1
    80201a38:	04e78b63          	beq	a5,a4,80201a8e <lazy_uvmunmap+0x8c>
			panic("lazy_uvmunmap: not a leaf");
	}
	if (PTE2PA(*pte) != 0)
    80201a3c:	609c                	ld	a5,0(s1)
    80201a3e:	83a9                	srli	a5,a5,0xa
    80201a40:	07b2                	slli	a5,a5,0xc
    80201a42:	e3d9                	bnez	a5,80201ac8 <lazy_uvmunmap+0xc6>
		panic("lazy_uvmunmap: not a lazy mapped address");
	*pte = 0;
    80201a44:	0004b023          	sd	zero,0(s1)
}
    80201a48:	60e2                	ld	ra,24(sp)
    80201a4a:	6442                	ld	s0,16(sp)
    80201a4c:	64a2                	ld	s1,8(sp)
    80201a4e:	6902                	ld	s2,0(sp)
    80201a50:	6105                	addi	sp,sp,32
    80201a52:	8082                	ret
		panic("lazy_uvmunmap: not aligned");
    80201a54:	00000097          	auipc	ra,0x0
    80201a58:	792080e7          	jalr	1938(ra) # 802021e6 <threadid>
    80201a5c:	86aa                	mv	a3,a0
    80201a5e:	0e000793          	li	a5,224
    80201a62:	00003717          	auipc	a4,0x3
    80201a66:	9f670713          	addi	a4,a4,-1546 # 80204458 <e_text+0x458>
    80201a6a:	00002617          	auipc	a2,0x2
    80201a6e:	5a660613          	addi	a2,a2,1446 # 80204010 <e_text+0x10>
    80201a72:	45fd                	li	a1,31
    80201a74:	00003517          	auipc	a0,0x3
    80201a78:	af450513          	addi	a0,a0,-1292 # 80204568 <e_text+0x568>
    80201a7c:	00001097          	auipc	ra,0x1
    80201a80:	eee080e7          	jalr	-274(ra) # 8020296a <printf>
    80201a84:	00000097          	auipc	ra,0x0
    80201a88:	734080e7          	jalr	1844(ra) # 802021b8 <shutdown>
    80201a8c:	b771                	j	80201a18 <lazy_uvmunmap+0x16>
			panic("lazy_uvmunmap: not a leaf");
    80201a8e:	00000097          	auipc	ra,0x0
    80201a92:	758080e7          	jalr	1880(ra) # 802021e6 <threadid>
    80201a96:	86aa                	mv	a3,a0
    80201a98:	0e800793          	li	a5,232
    80201a9c:	00003717          	auipc	a4,0x3
    80201aa0:	9bc70713          	addi	a4,a4,-1604 # 80204458 <e_text+0x458>
    80201aa4:	00002617          	auipc	a2,0x2
    80201aa8:	56c60613          	addi	a2,a2,1388 # 80204010 <e_text+0x10>
    80201aac:	45fd                	li	a1,31
    80201aae:	00003517          	auipc	a0,0x3
    80201ab2:	af250513          	addi	a0,a0,-1294 # 802045a0 <e_text+0x5a0>
    80201ab6:	00001097          	auipc	ra,0x1
    80201aba:	eb4080e7          	jalr	-332(ra) # 8020296a <printf>
    80201abe:	00000097          	auipc	ra,0x0
    80201ac2:	6fa080e7          	jalr	1786(ra) # 802021b8 <shutdown>
    80201ac6:	bf9d                	j	80201a3c <lazy_uvmunmap+0x3a>
		panic("lazy_uvmunmap: not a lazy mapped address");
    80201ac8:	00000097          	auipc	ra,0x0
    80201acc:	71e080e7          	jalr	1822(ra) # 802021e6 <threadid>
    80201ad0:	86aa                	mv	a3,a0
    80201ad2:	0eb00793          	li	a5,235
    80201ad6:	00003717          	auipc	a4,0x3
    80201ada:	98270713          	addi	a4,a4,-1662 # 80204458 <e_text+0x458>
    80201ade:	00002617          	auipc	a2,0x2
    80201ae2:	53260613          	addi	a2,a2,1330 # 80204010 <e_text+0x10>
    80201ae6:	45fd                	li	a1,31
    80201ae8:	00003517          	auipc	a0,0x3
    80201aec:	af050513          	addi	a0,a0,-1296 # 802045d8 <e_text+0x5d8>
    80201af0:	00001097          	auipc	ra,0x1
    80201af4:	e7a080e7          	jalr	-390(ra) # 8020296a <printf>
    80201af8:	00000097          	auipc	ra,0x0
    80201afc:	6c0080e7          	jalr	1728(ra) # 802021b8 <shutdown>
    80201b00:	b791                	j	80201a44 <lazy_uvmunmap+0x42>

0000000080201b02 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate(uint64 trapframe)
{
    80201b02:	1101                	addi	sp,sp,-32
    80201b04:	ec06                	sd	ra,24(sp)
    80201b06:	e822                	sd	s0,16(sp)
    80201b08:	e426                	sd	s1,8(sp)
    80201b0a:	e04a                	sd	s2,0(sp)
    80201b0c:	1000                	addi	s0,sp,32
    80201b0e:	892a                	mv	s2,a0
	pagetable_t pagetable;
	pagetable = (pagetable_t)kalloc();
    80201b10:	00000097          	auipc	ra,0x0
    80201b14:	640080e7          	jalr	1600(ra) # 80202150 <kalloc>
    80201b18:	84aa                	mv	s1,a0
	if (pagetable == 0) {
    80201b1a:	cd29                	beqz	a0,80201b74 <uvmcreate+0x72>
		errorf("uvmcreate: kalloc error");
		return 0;
	}
	memset(pagetable, 0, PGSIZE);
    80201b1c:	6605                	lui	a2,0x1
    80201b1e:	4581                	li	a1,0
    80201b20:	fffff097          	auipc	ra,0xfffff
    80201b24:	bc4080e7          	jalr	-1084(ra) # 802006e4 <memset>
	if (mappages(pagetable, TRAMPOLINE, PAGE_SIZE, (uint64)trampoline,
    80201b28:	4729                	li	a4,10
    80201b2a:	00001697          	auipc	a3,0x1
    80201b2e:	4d668693          	addi	a3,a3,1238 # 80203000 <trampoline>
    80201b32:	6605                	lui	a2,0x1
    80201b34:	040005b7          	lui	a1,0x4000
    80201b38:	15fd                	addi	a1,a1,-1
    80201b3a:	05b2                	slli	a1,a1,0xc
    80201b3c:	8526                	mv	a0,s1
    80201b3e:	00000097          	auipc	ra,0x0
    80201b42:	af8080e7          	jalr	-1288(ra) # 80201636 <mappages>
    80201b46:	04054a63          	bltz	a0,80201b9a <uvmcreate+0x98>
		     PTE_R | PTE_X) < 0) {
		panic("mappages fail");
	}
	if (mappages(pagetable, TRAPFRAME, PGSIZE, trapframe, PTE_R | PTE_W) <
    80201b4a:	4719                	li	a4,6
    80201b4c:	86ca                	mv	a3,s2
    80201b4e:	6605                	lui	a2,0x1
    80201b50:	020005b7          	lui	a1,0x2000
    80201b54:	15fd                	addi	a1,a1,-1
    80201b56:	05b6                	slli	a1,a1,0xd
    80201b58:	8526                	mv	a0,s1
    80201b5a:	00000097          	auipc	ra,0x0
    80201b5e:	adc080e7          	jalr	-1316(ra) # 80201636 <mappages>
    80201b62:	06054963          	bltz	a0,80201bd4 <uvmcreate+0xd2>
	    0) {
		panic("mappages fail");
	}
	return pagetable;
}
    80201b66:	8526                	mv	a0,s1
    80201b68:	60e2                	ld	ra,24(sp)
    80201b6a:	6442                	ld	s0,16(sp)
    80201b6c:	64a2                	ld	s1,8(sp)
    80201b6e:	6902                	ld	s2,0(sp)
    80201b70:	6105                	addi	sp,sp,32
    80201b72:	8082                	ret
		errorf("uvmcreate: kalloc error");
    80201b74:	00000097          	auipc	ra,0x0
    80201b78:	672080e7          	jalr	1650(ra) # 802021e6 <threadid>
    80201b7c:	86aa                	mv	a3,a0
    80201b7e:	00002617          	auipc	a2,0x2
    80201b82:	5fa60613          	addi	a2,a2,1530 # 80204178 <e_text+0x178>
    80201b86:	45fd                	li	a1,31
    80201b88:	00003517          	auipc	a0,0x3
    80201b8c:	a9850513          	addi	a0,a0,-1384 # 80204620 <e_text+0x620>
    80201b90:	00001097          	auipc	ra,0x1
    80201b94:	dda080e7          	jalr	-550(ra) # 8020296a <printf>
		return 0;
    80201b98:	b7f9                	j	80201b66 <uvmcreate+0x64>
		panic("mappages fail");
    80201b9a:	00000097          	auipc	ra,0x0
    80201b9e:	64c080e7          	jalr	1612(ra) # 802021e6 <threadid>
    80201ba2:	86aa                	mv	a3,a0
    80201ba4:	0fd00793          	li	a5,253
    80201ba8:	00003717          	auipc	a4,0x3
    80201bac:	8b070713          	addi	a4,a4,-1872 # 80204458 <e_text+0x458>
    80201bb0:	00002617          	auipc	a2,0x2
    80201bb4:	46060613          	addi	a2,a2,1120 # 80204010 <e_text+0x10>
    80201bb8:	45fd                	li	a1,31
    80201bba:	00003517          	auipc	a0,0x3
    80201bbe:	a9650513          	addi	a0,a0,-1386 # 80204650 <e_text+0x650>
    80201bc2:	00001097          	auipc	ra,0x1
    80201bc6:	da8080e7          	jalr	-600(ra) # 8020296a <printf>
    80201bca:	00000097          	auipc	ra,0x0
    80201bce:	5ee080e7          	jalr	1518(ra) # 802021b8 <shutdown>
    80201bd2:	bfa5                	j	80201b4a <uvmcreate+0x48>
		panic("mappages fail");
    80201bd4:	00000097          	auipc	ra,0x0
    80201bd8:	612080e7          	jalr	1554(ra) # 802021e6 <threadid>
    80201bdc:	86aa                	mv	a3,a0
    80201bde:	10100793          	li	a5,257
    80201be2:	00003717          	auipc	a4,0x3
    80201be6:	87670713          	addi	a4,a4,-1930 # 80204458 <e_text+0x458>
    80201bea:	00002617          	auipc	a2,0x2
    80201bee:	42660613          	addi	a2,a2,1062 # 80204010 <e_text+0x10>
    80201bf2:	45fd                	li	a1,31
    80201bf4:	00003517          	auipc	a0,0x3
    80201bf8:	a5c50513          	addi	a0,a0,-1444 # 80204650 <e_text+0x650>
    80201bfc:	00001097          	auipc	ra,0x1
    80201c00:	d6e080e7          	jalr	-658(ra) # 8020296a <printf>
    80201c04:	00000097          	auipc	ra,0x0
    80201c08:	5b4080e7          	jalr	1460(ra) # 802021b8 <shutdown>
    80201c0c:	bfa9                	j	80201b66 <uvmcreate+0x64>

0000000080201c0e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80201c0e:	715d                	addi	sp,sp,-80
    80201c10:	e486                	sd	ra,72(sp)
    80201c12:	e0a2                	sd	s0,64(sp)
    80201c14:	fc26                	sd	s1,56(sp)
    80201c16:	f84a                	sd	s2,48(sp)
    80201c18:	f44e                	sd	s3,40(sp)
    80201c1a:	f052                	sd	s4,32(sp)
    80201c1c:	ec56                	sd	s5,24(sp)
    80201c1e:	e85a                	sd	s6,16(sp)
    80201c20:	e45e                	sd	s7,8(sp)
    80201c22:	0880                	addi	s0,sp,80
    80201c24:	8baa                	mv	s7,a0
	// there are 2^9 = 512 PTEs in a page table.
	for (int i = 0; i < 512; i++) {
    80201c26:	84aa                	mv	s1,a0
    80201c28:	6905                	lui	s2,0x1
    80201c2a:	992a                	add	s2,s2,a0
		pte_t pte = pagetable[i];
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80201c2c:	4985                	li	s3,1
			// this PTE points to a lower-level page table.
			uint64 child = PTE2PA(pte);
			freewalk((pagetable_t)child);
			pagetable[i] = 0;
		} else if (pte & PTE_V) {
			panic("freewalk: leaf");
    80201c2e:	00003b17          	auipc	s6,0x3
    80201c32:	82ab0b13          	addi	s6,s6,-2006 # 80204458 <e_text+0x458>
    80201c36:	00002a97          	auipc	s5,0x2
    80201c3a:	3daa8a93          	addi	s5,s5,986 # 80204010 <e_text+0x10>
    80201c3e:	00003a17          	auipc	s4,0x3
    80201c42:	a3aa0a13          	addi	s4,s4,-1478 # 80204678 <e_text+0x678>
    80201c46:	a821                	j	80201c5e <freewalk+0x50>
			uint64 child = PTE2PA(pte);
    80201c48:	8129                	srli	a0,a0,0xa
			freewalk((pagetable_t)child);
    80201c4a:	0532                	slli	a0,a0,0xc
    80201c4c:	00000097          	auipc	ra,0x0
    80201c50:	fc2080e7          	jalr	-62(ra) # 80201c0e <freewalk>
			pagetable[i] = 0;
    80201c54:	0004b023          	sd	zero,0(s1)
	for (int i = 0; i < 512; i++) {
    80201c58:	04a1                	addi	s1,s1,8
    80201c5a:	03248d63          	beq	s1,s2,80201c94 <freewalk+0x86>
		pte_t pte = pagetable[i];
    80201c5e:	6088                	ld	a0,0(s1)
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80201c60:	00f57793          	andi	a5,a0,15
    80201c64:	ff3782e3          	beq	a5,s3,80201c48 <freewalk+0x3a>
		} else if (pte & PTE_V) {
    80201c68:	8905                	andi	a0,a0,1
    80201c6a:	d57d                	beqz	a0,80201c58 <freewalk+0x4a>
			panic("freewalk: leaf");
    80201c6c:	00000097          	auipc	ra,0x0
    80201c70:	57a080e7          	jalr	1402(ra) # 802021e6 <threadid>
    80201c74:	86aa                	mv	a3,a0
    80201c76:	11400793          	li	a5,276
    80201c7a:	875a                	mv	a4,s6
    80201c7c:	8656                	mv	a2,s5
    80201c7e:	45fd                	li	a1,31
    80201c80:	8552                	mv	a0,s4
    80201c82:	00001097          	auipc	ra,0x1
    80201c86:	ce8080e7          	jalr	-792(ra) # 8020296a <printf>
    80201c8a:	00000097          	auipc	ra,0x0
    80201c8e:	52e080e7          	jalr	1326(ra) # 802021b8 <shutdown>
    80201c92:	b7d9                	j	80201c58 <freewalk+0x4a>
		}
	}
	kfree((void *)pagetable);
    80201c94:	855e                	mv	a0,s7
    80201c96:	00000097          	auipc	ra,0x0
    80201c9a:	3c8080e7          	jalr	968(ra) # 8020205e <kfree>
}
    80201c9e:	60a6                	ld	ra,72(sp)
    80201ca0:	6406                	ld	s0,64(sp)
    80201ca2:	74e2                	ld	s1,56(sp)
    80201ca4:	7942                	ld	s2,48(sp)
    80201ca6:	79a2                	ld	s3,40(sp)
    80201ca8:	7a02                	ld	s4,32(sp)
    80201caa:	6ae2                	ld	s5,24(sp)
    80201cac:	6b42                	ld	s6,16(sp)
    80201cae:	6ba2                	ld	s7,8(sp)
    80201cb0:	6161                	addi	sp,sp,80
    80201cb2:	8082                	ret

0000000080201cb4 <uvmfree>:
 *
 * @param max_page The max vaddr of user-space.
 */
void
uvmfree(pagetable_t pagetable, uint64 max_page)
{
    80201cb4:	1101                	addi	sp,sp,-32
    80201cb6:	ec06                	sd	ra,24(sp)
    80201cb8:	e822                	sd	s0,16(sp)
    80201cba:	e426                	sd	s1,8(sp)
    80201cbc:	1000                	addi	s0,sp,32
    80201cbe:	84aa                	mv	s1,a0
	if (max_page > 0)
    80201cc0:	e999                	bnez	a1,80201cd6 <uvmfree+0x22>
		uvmunmap(pagetable, 0, max_page, 1);
	freewalk(pagetable);
    80201cc2:	8526                	mv	a0,s1
    80201cc4:	00000097          	auipc	ra,0x0
    80201cc8:	f4a080e7          	jalr	-182(ra) # 80201c0e <freewalk>
}
    80201ccc:	60e2                	ld	ra,24(sp)
    80201cce:	6442                	ld	s0,16(sp)
    80201cd0:	64a2                	ld	s1,8(sp)
    80201cd2:	6105                	addi	sp,sp,32
    80201cd4:	8082                	ret
		uvmunmap(pagetable, 0, max_page, 1);
    80201cd6:	4685                	li	a3,1
    80201cd8:	862e                	mv	a2,a1
    80201cda:	4581                	li	a1,0
    80201cdc:	00000097          	auipc	ra,0x0
    80201ce0:	c16080e7          	jalr	-1002(ra) # 802018f2 <uvmunmap>
    80201ce4:	bff9                	j	80201cc2 <uvmfree+0xe>

0000000080201ce6 <uvmcopy>:
// Used in fork.
// Copy the pagetable page and all the user pages.
// Return 0 on success, -1 on error.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 max_page)
{
    80201ce6:	715d                	addi	sp,sp,-80
    80201ce8:	e486                	sd	ra,72(sp)
    80201cea:	e0a2                	sd	s0,64(sp)
    80201cec:	fc26                	sd	s1,56(sp)
    80201cee:	f84a                	sd	s2,48(sp)
    80201cf0:	f44e                	sd	s3,40(sp)
    80201cf2:	f052                	sd	s4,32(sp)
    80201cf4:	ec56                	sd	s5,24(sp)
    80201cf6:	e85a                	sd	s6,16(sp)
    80201cf8:	e45e                	sd	s7,8(sp)
    80201cfa:	0880                	addi	s0,sp,80
	pte_t *pte;
	uint64 pa, i;
	uint flags;
	char *mem;

	for (i = 0; i < max_page * PAGE_SIZE; i += PGSIZE) {
    80201cfc:	00c61a13          	slli	s4,a2,0xc
    80201d00:	080a0e63          	beqz	s4,80201d9c <uvmcopy+0xb6>
    80201d04:	8aaa                	mv	s5,a0
    80201d06:	8b2e                	mv	s6,a1
    80201d08:	4481                	li	s1,0
    80201d0a:	a029                	j	80201d14 <uvmcopy+0x2e>
    80201d0c:	6785                	lui	a5,0x1
    80201d0e:	94be                	add	s1,s1,a5
    80201d10:	0744fa63          	bgeu	s1,s4,80201d84 <uvmcopy+0x9e>
		if ((pte = walk(old, i, 0)) == 0)
    80201d14:	4601                	li	a2,0
    80201d16:	85a6                	mv	a1,s1
    80201d18:	8556                	mv	a0,s5
    80201d1a:	fffff097          	auipc	ra,0xfffff
    80201d1e:	7dc080e7          	jalr	2012(ra) # 802014f6 <walk>
    80201d22:	d56d                	beqz	a0,80201d0c <uvmcopy+0x26>
			continue;
		if ((*pte & PTE_V) == 0)
    80201d24:	6118                	ld	a4,0(a0)
    80201d26:	00177793          	andi	a5,a4,1
    80201d2a:	d3ed                	beqz	a5,80201d0c <uvmcopy+0x26>
			continue;
		pa = PTE2PA(*pte);
    80201d2c:	00a75593          	srli	a1,a4,0xa
    80201d30:	00c59b93          	slli	s7,a1,0xc
		flags = PTE_FLAGS(*pte);
    80201d34:	3ff77913          	andi	s2,a4,1023
		if ((mem = kalloc()) == 0)
    80201d38:	00000097          	auipc	ra,0x0
    80201d3c:	418080e7          	jalr	1048(ra) # 80202150 <kalloc>
    80201d40:	89aa                	mv	s3,a0
    80201d42:	c515                	beqz	a0,80201d6e <uvmcopy+0x88>
			goto err;
		memmove(mem, (char *)pa, PGSIZE);
    80201d44:	6605                	lui	a2,0x1
    80201d46:	85de                	mv	a1,s7
    80201d48:	fffff097          	auipc	ra,0xfffff
    80201d4c:	9f8080e7          	jalr	-1544(ra) # 80200740 <memmove>
		if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80201d50:	874a                	mv	a4,s2
    80201d52:	86ce                	mv	a3,s3
    80201d54:	6605                	lui	a2,0x1
    80201d56:	85a6                	mv	a1,s1
    80201d58:	855a                	mv	a0,s6
    80201d5a:	00000097          	auipc	ra,0x0
    80201d5e:	8dc080e7          	jalr	-1828(ra) # 80201636 <mappages>
    80201d62:	d54d                	beqz	a0,80201d0c <uvmcopy+0x26>
			kfree(mem);
    80201d64:	854e                	mv	a0,s3
    80201d66:	00000097          	auipc	ra,0x0
    80201d6a:	2f8080e7          	jalr	760(ra) # 8020205e <kfree>
		}
	}
	return 0;

err:
	uvmunmap(new, 0, i / PGSIZE, 1);
    80201d6e:	4685                	li	a3,1
    80201d70:	00c4d613          	srli	a2,s1,0xc
    80201d74:	4581                	li	a1,0
    80201d76:	855a                	mv	a0,s6
    80201d78:	00000097          	auipc	ra,0x0
    80201d7c:	b7a080e7          	jalr	-1158(ra) # 802018f2 <uvmunmap>
	return -1;
    80201d80:	557d                	li	a0,-1
    80201d82:	a011                	j	80201d86 <uvmcopy+0xa0>
	return 0;
    80201d84:	4501                	li	a0,0
}
    80201d86:	60a6                	ld	ra,72(sp)
    80201d88:	6406                	ld	s0,64(sp)
    80201d8a:	74e2                	ld	s1,56(sp)
    80201d8c:	7942                	ld	s2,48(sp)
    80201d8e:	79a2                	ld	s3,40(sp)
    80201d90:	7a02                	ld	s4,32(sp)
    80201d92:	6ae2                	ld	s5,24(sp)
    80201d94:	6b42                	ld	s6,16(sp)
    80201d96:	6ba2                	ld	s7,8(sp)
    80201d98:	6161                	addi	sp,sp,80
    80201d9a:	8082                	ret
	return 0;
    80201d9c:	4501                	li	a0,0
    80201d9e:	b7e5                	j	80201d86 <uvmcopy+0xa0>

0000000080201da0 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    80201da0:	c6bd                	beqz	a3,80201e0e <copyout+0x6e>
{
    80201da2:	715d                	addi	sp,sp,-80
    80201da4:	e486                	sd	ra,72(sp)
    80201da6:	e0a2                	sd	s0,64(sp)
    80201da8:	fc26                	sd	s1,56(sp)
    80201daa:	f84a                	sd	s2,48(sp)
    80201dac:	f44e                	sd	s3,40(sp)
    80201dae:	f052                	sd	s4,32(sp)
    80201db0:	ec56                	sd	s5,24(sp)
    80201db2:	e85a                	sd	s6,16(sp)
    80201db4:	e45e                	sd	s7,8(sp)
    80201db6:	e062                	sd	s8,0(sp)
    80201db8:	0880                	addi	s0,sp,80
    80201dba:	8b2a                	mv	s6,a0
    80201dbc:	8c2e                	mv	s8,a1
    80201dbe:	8a32                	mv	s4,a2
    80201dc0:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(dstva);
    80201dc2:	7bfd                	lui	s7,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (dstva - va0);
    80201dc4:	6a85                	lui	s5,0x1
    80201dc6:	a015                	j	80201dea <copyout+0x4a>
		if (n > len)
			n = len;
		memmove((void *)(pa0 + (dstva - va0)), src, n);
    80201dc8:	9562                	add	a0,a0,s8
    80201dca:	0004861b          	sext.w	a2,s1
    80201dce:	85d2                	mv	a1,s4
    80201dd0:	41250533          	sub	a0,a0,s2
    80201dd4:	fffff097          	auipc	ra,0xfffff
    80201dd8:	96c080e7          	jalr	-1684(ra) # 80200740 <memmove>

		len -= n;
    80201ddc:	409989b3          	sub	s3,s3,s1
		src += n;
    80201de0:	9a26                	add	s4,s4,s1
		dstva = va0 + PGSIZE;
    80201de2:	01590c33          	add	s8,s2,s5
	while (len > 0) {
    80201de6:	02098263          	beqz	s3,80201e0a <copyout+0x6a>
		va0 = PGROUNDDOWN(dstva);
    80201dea:	017c7933          	and	s2,s8,s7
		pa0 = walkaddr(pagetable, va0);
    80201dee:	85ca                	mv	a1,s2
    80201df0:	855a                	mv	a0,s6
    80201df2:	fffff097          	auipc	ra,0xfffff
    80201df6:	7d6080e7          	jalr	2006(ra) # 802015c8 <walkaddr>
		if (pa0 == 0)
    80201dfa:	cd01                	beqz	a0,80201e12 <copyout+0x72>
		n = PGSIZE - (dstva - va0);
    80201dfc:	418904b3          	sub	s1,s2,s8
    80201e00:	94d6                	add	s1,s1,s5
		if (n > len)
    80201e02:	fc99f3e3          	bgeu	s3,s1,80201dc8 <copyout+0x28>
    80201e06:	84ce                	mv	s1,s3
    80201e08:	b7c1                	j	80201dc8 <copyout+0x28>
	}
	return 0;
    80201e0a:	4501                	li	a0,0
    80201e0c:	a021                	j	80201e14 <copyout+0x74>
    80201e0e:	4501                	li	a0,0
}
    80201e10:	8082                	ret
			return -1;
    80201e12:	557d                	li	a0,-1
}
    80201e14:	60a6                	ld	ra,72(sp)
    80201e16:	6406                	ld	s0,64(sp)
    80201e18:	74e2                	ld	s1,56(sp)
    80201e1a:	7942                	ld	s2,48(sp)
    80201e1c:	79a2                	ld	s3,40(sp)
    80201e1e:	7a02                	ld	s4,32(sp)
    80201e20:	6ae2                	ld	s5,24(sp)
    80201e22:	6b42                	ld	s6,16(sp)
    80201e24:	6ba2                	ld	s7,8(sp)
    80201e26:	6c02                	ld	s8,0(sp)
    80201e28:	6161                	addi	sp,sp,80
    80201e2a:	8082                	ret

0000000080201e2c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    80201e2c:	caa5                	beqz	a3,80201e9c <copyin+0x70>
{
    80201e2e:	715d                	addi	sp,sp,-80
    80201e30:	e486                	sd	ra,72(sp)
    80201e32:	e0a2                	sd	s0,64(sp)
    80201e34:	fc26                	sd	s1,56(sp)
    80201e36:	f84a                	sd	s2,48(sp)
    80201e38:	f44e                	sd	s3,40(sp)
    80201e3a:	f052                	sd	s4,32(sp)
    80201e3c:	ec56                	sd	s5,24(sp)
    80201e3e:	e85a                	sd	s6,16(sp)
    80201e40:	e45e                	sd	s7,8(sp)
    80201e42:	e062                	sd	s8,0(sp)
    80201e44:	0880                	addi	s0,sp,80
    80201e46:	8b2a                	mv	s6,a0
    80201e48:	8a2e                	mv	s4,a1
    80201e4a:	8c32                	mv	s8,a2
    80201e4c:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(srcva);
    80201e4e:	7bfd                	lui	s7,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    80201e50:	6a85                	lui	s5,0x1
    80201e52:	a01d                	j	80201e78 <copyin+0x4c>
		if (n > len)
			n = len;
		memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80201e54:	018505b3          	add	a1,a0,s8
    80201e58:	0004861b          	sext.w	a2,s1
    80201e5c:	412585b3          	sub	a1,a1,s2
    80201e60:	8552                	mv	a0,s4
    80201e62:	fffff097          	auipc	ra,0xfffff
    80201e66:	8de080e7          	jalr	-1826(ra) # 80200740 <memmove>

		len -= n;
    80201e6a:	409989b3          	sub	s3,s3,s1
		dst += n;
    80201e6e:	9a26                	add	s4,s4,s1
		srcva = va0 + PGSIZE;
    80201e70:	01590c33          	add	s8,s2,s5
	while (len > 0) {
    80201e74:	02098263          	beqz	s3,80201e98 <copyin+0x6c>
		va0 = PGROUNDDOWN(srcva);
    80201e78:	017c7933          	and	s2,s8,s7
		pa0 = walkaddr(pagetable, va0);
    80201e7c:	85ca                	mv	a1,s2
    80201e7e:	855a                	mv	a0,s6
    80201e80:	fffff097          	auipc	ra,0xfffff
    80201e84:	748080e7          	jalr	1864(ra) # 802015c8 <walkaddr>
		if (pa0 == 0)
    80201e88:	cd01                	beqz	a0,80201ea0 <copyin+0x74>
		n = PGSIZE - (srcva - va0);
    80201e8a:	418904b3          	sub	s1,s2,s8
    80201e8e:	94d6                	add	s1,s1,s5
		if (n > len)
    80201e90:	fc99f2e3          	bgeu	s3,s1,80201e54 <copyin+0x28>
    80201e94:	84ce                	mv	s1,s3
    80201e96:	bf7d                	j	80201e54 <copyin+0x28>
	}
	return 0;
    80201e98:	4501                	li	a0,0
    80201e9a:	a021                	j	80201ea2 <copyin+0x76>
    80201e9c:	4501                	li	a0,0
}
    80201e9e:	8082                	ret
			return -1;
    80201ea0:	557d                	li	a0,-1
}
    80201ea2:	60a6                	ld	ra,72(sp)
    80201ea4:	6406                	ld	s0,64(sp)
    80201ea6:	74e2                	ld	s1,56(sp)
    80201ea8:	7942                	ld	s2,48(sp)
    80201eaa:	79a2                	ld	s3,40(sp)
    80201eac:	7a02                	ld	s4,32(sp)
    80201eae:	6ae2                	ld	s5,24(sp)
    80201eb0:	6b42                	ld	s6,16(sp)
    80201eb2:	6ba2                	ld	s7,8(sp)
    80201eb4:	6c02                	ld	s8,0(sp)
    80201eb6:	6161                	addi	sp,sp,80
    80201eb8:	8082                	ret

0000000080201eba <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80201eba:	715d                	addi	sp,sp,-80
    80201ebc:	e486                	sd	ra,72(sp)
    80201ebe:	e0a2                	sd	s0,64(sp)
    80201ec0:	fc26                	sd	s1,56(sp)
    80201ec2:	f84a                	sd	s2,48(sp)
    80201ec4:	f44e                	sd	s3,40(sp)
    80201ec6:	f052                	sd	s4,32(sp)
    80201ec8:	ec56                	sd	s5,24(sp)
    80201eca:	e85a                	sd	s6,16(sp)
    80201ecc:	e45e                	sd	s7,8(sp)
    80201ece:	e062                	sd	s8,0(sp)
    80201ed0:	0880                	addi	s0,sp,80
	uint64 n, va0, pa0;
	int got_null = 0, len = 0;

	while (got_null == 0 && max > 0) {
    80201ed2:	c6c9                	beqz	a3,80201f5c <copyinstr+0xa2>
    80201ed4:	8aaa                	mv	s5,a0
    80201ed6:	8bae                	mv	s7,a1
    80201ed8:	8c32                	mv	s8,a2
    80201eda:	8936                	mv	s2,a3
	int got_null = 0, len = 0;
    80201edc:	4481                	li	s1,0
		va0 = PGROUNDDOWN(srcva);
    80201ede:	7b7d                	lui	s6,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    80201ee0:	6a05                	lui	s4,0x1
    80201ee2:	a025                	j	80201f0a <copyinstr+0x50>
			n = max;

		char *p = (char *)(pa0 + (srcva - va0));
		while (n > 0) {
			if (*p == '\0') {
				*dst = '\0';
    80201ee4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x801ff000>
		}

		srcva = va0 + PGSIZE;
	}
	return len;
}
    80201ee8:	8526                	mv	a0,s1
    80201eea:	60a6                	ld	ra,72(sp)
    80201eec:	6406                	ld	s0,64(sp)
    80201eee:	74e2                	ld	s1,56(sp)
    80201ef0:	7942                	ld	s2,48(sp)
    80201ef2:	79a2                	ld	s3,40(sp)
    80201ef4:	7a02                	ld	s4,32(sp)
    80201ef6:	6ae2                	ld	s5,24(sp)
    80201ef8:	6b42                	ld	s6,16(sp)
    80201efa:	6ba2                	ld	s7,8(sp)
    80201efc:	6c02                	ld	s8,0(sp)
    80201efe:	6161                	addi	sp,sp,80
    80201f00:	8082                	ret
		srcva = va0 + PGSIZE;
    80201f02:	01498c33          	add	s8,s3,s4
	while (got_null == 0 && max > 0) {
    80201f06:	fe0901e3          	beqz	s2,80201ee8 <copyinstr+0x2e>
		va0 = PGROUNDDOWN(srcva);
    80201f0a:	016c79b3          	and	s3,s8,s6
		pa0 = walkaddr(pagetable, va0);
    80201f0e:	85ce                	mv	a1,s3
    80201f10:	8556                	mv	a0,s5
    80201f12:	fffff097          	auipc	ra,0xfffff
    80201f16:	6b6080e7          	jalr	1718(ra) # 802015c8 <walkaddr>
		if (pa0 == 0)
    80201f1a:	c139                	beqz	a0,80201f60 <copyinstr+0xa6>
		n = PGSIZE - (srcva - va0);
    80201f1c:	41898833          	sub	a6,s3,s8
    80201f20:	9852                	add	a6,a6,s4
		if (n > max)
    80201f22:	01097363          	bgeu	s2,a6,80201f28 <copyinstr+0x6e>
    80201f26:	884a                	mv	a6,s2
		char *p = (char *)(pa0 + (srcva - va0));
    80201f28:	9562                	add	a0,a0,s8
    80201f2a:	41350533          	sub	a0,a0,s3
		while (n > 0) {
    80201f2e:	fc080ae3          	beqz	a6,80201f02 <copyinstr+0x48>
    80201f32:	985e                	add	a6,a6,s7
    80201f34:	87de                	mv	a5,s7
			if (*p == '\0') {
    80201f36:	41750633          	sub	a2,a0,s7
    80201f3a:	197d                	addi	s2,s2,-1
    80201f3c:	9bca                	add	s7,s7,s2
    80201f3e:	00f60733          	add	a4,a2,a5
    80201f42:	00074703          	lbu	a4,0(a4)
    80201f46:	df59                	beqz	a4,80201ee4 <copyinstr+0x2a>
				*dst = *p;
    80201f48:	00e78023          	sb	a4,0(a5)
			--max;
    80201f4c:	40fb8933          	sub	s2,s7,a5
			dst++;
    80201f50:	0785                	addi	a5,a5,1
			len++;
    80201f52:	2485                	addiw	s1,s1,1
		while (n > 0) {
    80201f54:	ff0795e3          	bne	a5,a6,80201f3e <copyinstr+0x84>
			dst++;
    80201f58:	8bc2                	mv	s7,a6
    80201f5a:	b765                	j	80201f02 <copyinstr+0x48>
	int got_null = 0, len = 0;
    80201f5c:	4481                	li	s1,0
    80201f5e:	b769                	j	80201ee8 <copyinstr+0x2e>
			return -1;
    80201f60:	54fd                	li	s1,-1
    80201f62:	b759                	j	80201ee8 <copyinstr+0x2e>

0000000080201f64 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80201f64:	1101                	addi	sp,sp,-32
    80201f66:	ec06                	sd	ra,24(sp)
    80201f68:	e822                	sd	s0,16(sp)
    80201f6a:	e426                	sd	s1,8(sp)
    80201f6c:	1000                	addi	s0,sp,32
	if (newsz >= oldsz)
		return oldsz;
    80201f6e:	84ae                	mv	s1,a1
	if (newsz >= oldsz)
    80201f70:	00b67d63          	bgeu	a2,a1,80201f8a <uvmdealloc+0x26>
    80201f74:	84b2                	mv	s1,a2

	if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80201f76:	6785                	lui	a5,0x1
    80201f78:	17fd                	addi	a5,a5,-1
    80201f7a:	00f60733          	add	a4,a2,a5
    80201f7e:	767d                	lui	a2,0xfffff
    80201f80:	8f71                	and	a4,a4,a2
    80201f82:	97ae                	add	a5,a5,a1
    80201f84:	8ff1                	and	a5,a5,a2
    80201f86:	00f76863          	bltu	a4,a5,80201f96 <uvmdealloc+0x32>
		int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
		uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
	}

	return newsz;
}
    80201f8a:	8526                	mv	a0,s1
    80201f8c:	60e2                	ld	ra,24(sp)
    80201f8e:	6442                	ld	s0,16(sp)
    80201f90:	64a2                	ld	s1,8(sp)
    80201f92:	6105                	addi	sp,sp,32
    80201f94:	8082                	ret
		int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80201f96:	8f99                	sub	a5,a5,a4
    80201f98:	83b1                	srli	a5,a5,0xc
		uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80201f9a:	4685                	li	a3,1
    80201f9c:	0007861b          	sext.w	a2,a5
    80201fa0:	85ba                	mv	a1,a4
    80201fa2:	00000097          	auipc	ra,0x0
    80201fa6:	950080e7          	jalr	-1712(ra) # 802018f2 <uvmunmap>
    80201faa:	b7c5                	j	80201f8a <uvmdealloc+0x26>

0000000080201fac <uvmalloc>:
	if (newsz < oldsz)
    80201fac:	0ab66563          	bltu	a2,a1,80202056 <uvmalloc+0xaa>
{
    80201fb0:	7139                	addi	sp,sp,-64
    80201fb2:	fc06                	sd	ra,56(sp)
    80201fb4:	f822                	sd	s0,48(sp)
    80201fb6:	f426                	sd	s1,40(sp)
    80201fb8:	f04a                	sd	s2,32(sp)
    80201fba:	ec4e                	sd	s3,24(sp)
    80201fbc:	e852                	sd	s4,16(sp)
    80201fbe:	e456                	sd	s5,8(sp)
    80201fc0:	e05a                	sd	s6,0(sp)
    80201fc2:	0080                	addi	s0,sp,64
    80201fc4:	8aaa                	mv	s5,a0
    80201fc6:	8a32                	mv	s4,a2
	oldsz = PGROUNDUP(oldsz);
    80201fc8:	6985                	lui	s3,0x1
    80201fca:	19fd                	addi	s3,s3,-1
    80201fcc:	95ce                	add	a1,a1,s3
    80201fce:	79fd                	lui	s3,0xfffff
    80201fd0:	0135f9b3          	and	s3,a1,s3
	for (a = oldsz; a < newsz; a += PGSIZE) {
    80201fd4:	08c9f363          	bgeu	s3,a2,8020205a <uvmalloc+0xae>
    80201fd8:	894e                	mv	s2,s3
		if (mappages(pagetable, a, PGSIZE, (uint64)mem,
    80201fda:	0126eb13          	ori	s6,a3,18
		mem = kalloc();
    80201fde:	00000097          	auipc	ra,0x0
    80201fe2:	172080e7          	jalr	370(ra) # 80202150 <kalloc>
    80201fe6:	84aa                	mv	s1,a0
		if (mem == 0) {
    80201fe8:	c51d                	beqz	a0,80202016 <uvmalloc+0x6a>
		memset(mem, 0, PGSIZE);
    80201fea:	6605                	lui	a2,0x1
    80201fec:	4581                	li	a1,0
    80201fee:	ffffe097          	auipc	ra,0xffffe
    80201ff2:	6f6080e7          	jalr	1782(ra) # 802006e4 <memset>
		if (mappages(pagetable, a, PGSIZE, (uint64)mem,
    80201ff6:	875a                	mv	a4,s6
    80201ff8:	86a6                	mv	a3,s1
    80201ffa:	6605                	lui	a2,0x1
    80201ffc:	85ca                	mv	a1,s2
    80201ffe:	8556                	mv	a0,s5
    80202000:	fffff097          	auipc	ra,0xfffff
    80202004:	636080e7          	jalr	1590(ra) # 80201636 <mappages>
    80202008:	e90d                	bnez	a0,8020203a <uvmalloc+0x8e>
	for (a = oldsz; a < newsz; a += PGSIZE) {
    8020200a:	6785                	lui	a5,0x1
    8020200c:	993e                	add	s2,s2,a5
    8020200e:	fd4968e3          	bltu	s2,s4,80201fde <uvmalloc+0x32>
	return newsz;
    80202012:	8552                	mv	a0,s4
    80202014:	a809                	j	80202026 <uvmalloc+0x7a>
			uvmdealloc(pagetable, a, oldsz);
    80202016:	864e                	mv	a2,s3
    80202018:	85ca                	mv	a1,s2
    8020201a:	8556                	mv	a0,s5
    8020201c:	00000097          	auipc	ra,0x0
    80202020:	f48080e7          	jalr	-184(ra) # 80201f64 <uvmdealloc>
			return 0;
    80202024:	4501                	li	a0,0
}
    80202026:	70e2                	ld	ra,56(sp)
    80202028:	7442                	ld	s0,48(sp)
    8020202a:	74a2                	ld	s1,40(sp)
    8020202c:	7902                	ld	s2,32(sp)
    8020202e:	69e2                	ld	s3,24(sp)
    80202030:	6a42                	ld	s4,16(sp)
    80202032:	6aa2                	ld	s5,8(sp)
    80202034:	6b02                	ld	s6,0(sp)
    80202036:	6121                	addi	sp,sp,64
    80202038:	8082                	ret
			kfree(mem);
    8020203a:	8526                	mv	a0,s1
    8020203c:	00000097          	auipc	ra,0x0
    80202040:	022080e7          	jalr	34(ra) # 8020205e <kfree>
			uvmdealloc(pagetable, a, oldsz);
    80202044:	864e                	mv	a2,s3
    80202046:	85ca                	mv	a1,s2
    80202048:	8556                	mv	a0,s5
    8020204a:	00000097          	auipc	ra,0x0
    8020204e:	f1a080e7          	jalr	-230(ra) # 80201f64 <uvmdealloc>
			return 0;
    80202052:	4501                	li	a0,0
    80202054:	bfc9                	j	80202026 <uvmalloc+0x7a>
		return oldsz;
    80202056:	852e                	mv	a0,a1
}
    80202058:	8082                	ret
	return newsz;
    8020205a:	8532                	mv	a0,a2
    8020205c:	b7e9                	j	80202026 <uvmalloc+0x7a>

000000008020205e <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    8020205e:	1101                	addi	sp,sp,-32
    80202060:	ec06                	sd	ra,24(sp)
    80202062:	e822                	sd	s0,16(sp)
    80202064:	e426                	sd	s1,8(sp)
    80202066:	1000                	addi	s0,sp,32
    80202068:	84aa                	mv	s1,a0
	struct linklist *l;
	if (((uint64)pa % PGSIZE) != 0 || (char *)pa < ekernel ||
    8020206a:	03451793          	slli	a5,a0,0x34
    8020206e:	eb99                	bnez	a5,80202084 <kfree+0x26>
    80202070:	00496797          	auipc	a5,0x496
    80202074:	f9078793          	addi	a5,a5,-112 # 80698000 <e_bss>
    80202078:	00f56663          	bltu	a0,a5,80202084 <kfree+0x26>
    8020207c:	47c5                	li	a5,17
    8020207e:	07ee                	slli	a5,a5,0x1b
    80202080:	02f56e63          	bltu	a0,a5,802020bc <kfree+0x5e>
	    (uint64)pa >= PHYSTOP)
		panic("kfree");
    80202084:	00000097          	auipc	ra,0x0
    80202088:	162080e7          	jalr	354(ra) # 802021e6 <threadid>
    8020208c:	86aa                	mv	a3,a0
    8020208e:	02500793          	li	a5,37
    80202092:	00002717          	auipc	a4,0x2
    80202096:	60e70713          	addi	a4,a4,1550 # 802046a0 <e_text+0x6a0>
    8020209a:	00002617          	auipc	a2,0x2
    8020209e:	f7660613          	addi	a2,a2,-138 # 80204010 <e_text+0x10>
    802020a2:	45fd                	li	a1,31
    802020a4:	00002517          	auipc	a0,0x2
    802020a8:	60c50513          	addi	a0,a0,1548 # 802046b0 <e_text+0x6b0>
    802020ac:	00001097          	auipc	ra,0x1
    802020b0:	8be080e7          	jalr	-1858(ra) # 8020296a <printf>
    802020b4:	00000097          	auipc	ra,0x0
    802020b8:	104080e7          	jalr	260(ra) # 802021b8 <shutdown>
	// Fill with junk to catch dangling refs.
	memset(pa, 1, PGSIZE);
    802020bc:	6605                	lui	a2,0x1
    802020be:	4585                	li	a1,1
    802020c0:	8526                	mv	a0,s1
    802020c2:	ffffe097          	auipc	ra,0xffffe
    802020c6:	622080e7          	jalr	1570(ra) # 802006e4 <memset>
	l = (struct linklist *)pa;
	l->next = kmem.freelist;
    802020ca:	00495797          	auipc	a5,0x495
    802020ce:	f4e78793          	addi	a5,a5,-178 # 80697018 <kmem>
    802020d2:	6398                	ld	a4,0(a5)
    802020d4:	e098                	sd	a4,0(s1)
	kmem.freelist = l;
    802020d6:	e384                	sd	s1,0(a5)
}
    802020d8:	60e2                	ld	ra,24(sp)
    802020da:	6442                	ld	s0,16(sp)
    802020dc:	64a2                	ld	s1,8(sp)
    802020de:	6105                	addi	sp,sp,32
    802020e0:	8082                	ret

00000000802020e2 <freerange>:
{
    802020e2:	7179                	addi	sp,sp,-48
    802020e4:	f406                	sd	ra,40(sp)
    802020e6:	f022                	sd	s0,32(sp)
    802020e8:	ec26                	sd	s1,24(sp)
    802020ea:	e84a                	sd	s2,16(sp)
    802020ec:	e44e                	sd	s3,8(sp)
    802020ee:	e052                	sd	s4,0(sp)
    802020f0:	1800                	addi	s0,sp,48
	p = (char *)PGROUNDUP((uint64)pa_start);
    802020f2:	6785                	lui	a5,0x1
    802020f4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x801ff001>
    802020f8:	94aa                	add	s1,s1,a0
    802020fa:	757d                	lui	a0,0xfffff
    802020fc:	8ce9                	and	s1,s1,a0
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    802020fe:	94be                	add	s1,s1,a5
    80202100:	0095ee63          	bltu	a1,s1,8020211c <freerange+0x3a>
    80202104:	892e                	mv	s2,a1
		kfree(p);
    80202106:	7a7d                	lui	s4,0xfffff
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80202108:	6985                	lui	s3,0x1
		kfree(p);
    8020210a:	01448533          	add	a0,s1,s4
    8020210e:	00000097          	auipc	ra,0x0
    80202112:	f50080e7          	jalr	-176(ra) # 8020205e <kfree>
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80202116:	94ce                	add	s1,s1,s3
    80202118:	fe9979e3          	bgeu	s2,s1,8020210a <freerange+0x28>
}
    8020211c:	70a2                	ld	ra,40(sp)
    8020211e:	7402                	ld	s0,32(sp)
    80202120:	64e2                	ld	s1,24(sp)
    80202122:	6942                	ld	s2,16(sp)
    80202124:	69a2                	ld	s3,8(sp)
    80202126:	6a02                	ld	s4,0(sp)
    80202128:	6145                	addi	sp,sp,48
    8020212a:	8082                	ret

000000008020212c <kinit>:
{
    8020212c:	1141                	addi	sp,sp,-16
    8020212e:	e406                	sd	ra,8(sp)
    80202130:	e022                	sd	s0,0(sp)
    80202132:	0800                	addi	s0,sp,16
	freerange(ekernel, (void *)PHYSTOP);
    80202134:	45c5                	li	a1,17
    80202136:	05ee                	slli	a1,a1,0x1b
    80202138:	00496517          	auipc	a0,0x496
    8020213c:	ec850513          	addi	a0,a0,-312 # 80698000 <e_bss>
    80202140:	00000097          	auipc	ra,0x0
    80202144:	fa2080e7          	jalr	-94(ra) # 802020e2 <freerange>
}
    80202148:	60a2                	ld	ra,8(sp)
    8020214a:	6402                	ld	s0,0(sp)
    8020214c:	0141                	addi	sp,sp,16
    8020214e:	8082                	ret

0000000080202150 <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc()
{
    80202150:	1101                	addi	sp,sp,-32
    80202152:	ec06                	sd	ra,24(sp)
    80202154:	e822                	sd	s0,16(sp)
    80202156:	e426                	sd	s1,8(sp)
    80202158:	1000                	addi	s0,sp,32
	struct linklist *l;
	l = kmem.freelist;
    8020215a:	00495497          	auipc	s1,0x495
    8020215e:	ebe4b483          	ld	s1,-322(s1) # 80697018 <kmem>
	if (l) {
    80202162:	cc89                	beqz	s1,8020217c <kalloc+0x2c>
		kmem.freelist = l->next;
    80202164:	609c                	ld	a5,0(s1)
    80202166:	00495717          	auipc	a4,0x495
    8020216a:	eaf73923          	sd	a5,-334(a4) # 80697018 <kmem>
		memset((char *)l, 5, PGSIZE); // fill with junk
    8020216e:	6605                	lui	a2,0x1
    80202170:	4595                	li	a1,5
    80202172:	8526                	mv	a0,s1
    80202174:	ffffe097          	auipc	ra,0xffffe
    80202178:	570080e7          	jalr	1392(ra) # 802006e4 <memset>
	}
	return (void *)l;
    8020217c:	8526                	mv	a0,s1
    8020217e:	60e2                	ld	ra,24(sp)
    80202180:	6442                	ld	s0,16(sp)
    80202182:	64a2                	ld	s1,8(sp)
    80202184:	6105                	addi	sp,sp,32
    80202186:	8082                	ret

0000000080202188 <console_putchar>:
		     : "memory");
	return a0;
}

void console_putchar(int c)
{
    80202188:	1141                	addi	sp,sp,-16
    8020218a:	e422                	sd	s0,8(sp)
    8020218c:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    8020218e:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    80202190:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    80202192:	4885                	li	a7,1
	asm volatile("ecall"
    80202194:	00000073          	ecall
	sbi_call(SBI_CONSOLE_PUTCHAR, c, 0, 0);
}
    80202198:	6422                	ld	s0,8(sp)
    8020219a:	0141                	addi	sp,sp,16
    8020219c:	8082                	ret

000000008020219e <console_getchar>:

int console_getchar()
{
    8020219e:	1141                	addi	sp,sp,-16
    802021a0:	e422                	sd	s0,8(sp)
    802021a2:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    802021a4:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    802021a6:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802021a8:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802021aa:	4889                	li	a7,2
	asm volatile("ecall"
    802021ac:	00000073          	ecall
	return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
    802021b0:	2501                	sext.w	a0,a0
    802021b2:	6422                	ld	s0,8(sp)
    802021b4:	0141                	addi	sp,sp,16
    802021b6:	8082                	ret

00000000802021b8 <shutdown>:

void shutdown()
{
    802021b8:	1141                	addi	sp,sp,-16
    802021ba:	e422                	sd	s0,8(sp)
    802021bc:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    802021be:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    802021c0:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802021c2:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802021c4:	48a1                	li	a7,8
	asm volatile("ecall"
    802021c6:	00000073          	ecall
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
}
    802021ca:	6422                	ld	s0,8(sp)
    802021cc:	0141                	addi	sp,sp,16
    802021ce:	8082                	ret

00000000802021d0 <set_timer>:

void set_timer(uint64 stime)
{
    802021d0:	1141                	addi	sp,sp,-16
    802021d2:	e422                	sd	s0,8(sp)
    802021d4:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    802021d6:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802021d8:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802021da:	4881                	li	a7,0
	asm volatile("ecall"
    802021dc:	00000073          	ecall
	sbi_call(SBI_SET_TIMER, stime, 0, 0);
    802021e0:	6422                	ld	s0,8(sp)
    802021e2:	0141                	addi	sp,sp,16
    802021e4:	8082                	ret

00000000802021e6 <threadid>:
struct proc idle;
struct queue task_queue;

int
threadid()
{
    802021e6:	1141                	addi	sp,sp,-16
    802021e8:	e422                	sd	s0,8(sp)
    802021ea:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
}
    802021ec:	00495797          	auipc	a5,0x495
    802021f0:	e347b783          	ld	a5,-460(a5) # 80697020 <current_proc>
    802021f4:	43c8                	lw	a0,4(a5)
    802021f6:	6422                	ld	s0,8(sp)
    802021f8:	0141                	addi	sp,sp,16
    802021fa:	8082                	ret

00000000802021fc <curr_proc>:

struct proc *
curr_proc()
{
    802021fc:	1141                	addi	sp,sp,-16
    802021fe:	e422                	sd	s0,8(sp)
    80202200:	0800                	addi	s0,sp,16
	return current_proc;
}
    80202202:	00495517          	auipc	a0,0x495
    80202206:	e1e53503          	ld	a0,-482(a0) # 80697020 <current_proc>
    8020220a:	6422                	ld	s0,8(sp)
    8020220c:	0141                	addi	sp,sp,16
    8020220e:	8082                	ret

0000000080202210 <proc_init>:

// initialize the proc table at boot time.
void
proc_init()
{
    80202210:	1141                	addi	sp,sp,-16
    80202212:	e406                	sd	ra,8(sp)
    80202214:	e022                	sd	s0,0(sp)
    80202216:	0800                	addi	s0,sp,16
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    80202218:	0046a717          	auipc	a4,0x46a
    8020221c:	de870713          	addi	a4,a4,-536 # 8066c000 <pool>
		p->state = UNUSED;
		p->kstack = (uint64)kstack[p - pool];
    80202220:	88ba                	mv	a7,a4
    80202222:	00002817          	auipc	a6,0x2
    80202226:	5de83803          	ld	a6,1502(a6) # 80204800 <SBI_SET_TIMER+0x8>
    8020222a:	0026a517          	auipc	a0,0x26a
    8020222e:	dd650513          	addi	a0,a0,-554 # 8046c000 <kstack>
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    80202232:	0006a597          	auipc	a1,0x6a
    80202236:	dce58593          	addi	a1,a1,-562 # 8026c000 <trapframe>
	for (p = pool; p < &pool[NPROC]; p++) {
    8020223a:	00495617          	auipc	a2,0x495
    8020223e:	dc660613          	addi	a2,a2,-570 # 80697000 <app_info_ptr>
		p->state = UNUSED;
    80202242:	00072023          	sw	zero,0(a4)
		p->kstack = (uint64)kstack[p - pool];
    80202246:	411707b3          	sub	a5,a4,a7
    8020224a:	878d                	srai	a5,a5,0x3
    8020224c:	030787b3          	mul	a5,a5,a6
    80202250:	07b2                	slli	a5,a5,0xc
    80202252:	00a786b3          	add	a3,a5,a0
    80202256:	ef14                	sd	a3,24(a4)
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    80202258:	97ae                	add	a5,a5,a1
    8020225a:	f31c                	sd	a5,32(a4)
	for (p = pool; p < &pool[NPROC]; p++) {
    8020225c:	15870713          	addi	a4,a4,344
    80202260:	fec711e3          	bne	a4,a2,80202242 <proc_init+0x32>
	}
	idle.kstack = (uint64)boot_stack_top;
    80202264:	00066797          	auipc	a5,0x66
    80202268:	d9c78793          	addi	a5,a5,-612 # 80268000 <idle>
    8020226c:	00064717          	auipc	a4,0x64
    80202270:	d9470713          	addi	a4,a4,-620 # 80266000 <names>
    80202274:	ef98                	sd	a4,24(a5)
	idle.pid = IDLE_PID;
    80202276:	0007a223          	sw	zero,4(a5)
	current_proc = &idle;
    8020227a:	00495717          	auipc	a4,0x495
    8020227e:	daf73323          	sd	a5,-602(a4) # 80697020 <current_proc>
	init_queue(&task_queue);
    80202282:	00066517          	auipc	a0,0x66
    80202286:	ed650513          	addi	a0,a0,-298 # 80268158 <task_queue>
    8020228a:	ffffe097          	auipc	ra,0xffffe
    8020228e:	d82080e7          	jalr	-638(ra) # 8020000c <init_queue>
}
    80202292:	60a2                	ld	ra,8(sp)
    80202294:	6402                	ld	s0,0(sp)
    80202296:	0141                	addi	sp,sp,16
    80202298:	8082                	ret

000000008020229a <allocpid>:

int
allocpid()
{
    8020229a:	1141                	addi	sp,sp,-16
    8020229c:	e422                	sd	s0,8(sp)
    8020229e:	0800                	addi	s0,sp,16
	static int PID = 1;
	return PID++;
    802022a0:	00053797          	auipc	a5,0x53
    802022a4:	d6078793          	addi	a5,a5,-672 # 80255000 <PID.0>
    802022a8:	4388                	lw	a0,0(a5)
    802022aa:	0015071b          	addiw	a4,a0,1
    802022ae:	c398                	sw	a4,0(a5)
}
    802022b0:	6422                	ld	s0,8(sp)
    802022b2:	0141                	addi	sp,sp,16
    802022b4:	8082                	ret

00000000802022b6 <fetch_task>:

struct proc *
fetch_task()
{
    802022b6:	1101                	addi	sp,sp,-32
    802022b8:	ec06                	sd	ra,24(sp)
    802022ba:	e822                	sd	s0,16(sp)
    802022bc:	e426                	sd	s1,8(sp)
    802022be:	1000                	addi	s0,sp,32
	int index = pop_queue(&task_queue);
    802022c0:	00066517          	auipc	a0,0x66
    802022c4:	e9850513          	addi	a0,a0,-360 # 80268158 <task_queue>
    802022c8:	ffffe097          	auipc	ra,0xffffe
    802022cc:	ee6080e7          	jalr	-282(ra) # 802001ae <pop_queue>
	if (index < 0) {
    802022d0:	02054863          	bltz	a0,80202300 <fetch_task+0x4a>
    802022d4:	85aa                	mv	a1,a0
		debugf("No task to fetch\n");
		return NULL;
	}
	debugf("fetch task %d(pid=%d) to task queue\n", index, pool[index].pid);
    802022d6:	15800493          	li	s1,344
    802022da:	02950533          	mul	a0,a0,s1
    802022de:	0046a497          	auipc	s1,0x46a
    802022e2:	d2248493          	addi	s1,s1,-734 # 8066c000 <pool>
    802022e6:	94aa                	add	s1,s1,a0
    802022e8:	40d0                	lw	a2,4(s1)
    802022ea:	4501                	li	a0,0
    802022ec:	ffffe097          	auipc	ra,0xffffe
    802022f0:	5a6080e7          	jalr	1446(ra) # 80200892 <dummy>
	return pool + index;
    802022f4:	8526                	mv	a0,s1
}
    802022f6:	60e2                	ld	ra,24(sp)
    802022f8:	6442                	ld	s0,16(sp)
    802022fa:	64a2                	ld	s1,8(sp)
    802022fc:	6105                	addi	sp,sp,32
    802022fe:	8082                	ret
		debugf("No task to fetch\n");
    80202300:	4501                	li	a0,0
    80202302:	ffffe097          	auipc	ra,0xffffe
    80202306:	590080e7          	jalr	1424(ra) # 80200892 <dummy>
		return NULL;
    8020230a:	4501                	li	a0,0
    8020230c:	b7ed                	j	802022f6 <fetch_task+0x40>

000000008020230e <add_task>:

void
add_task(struct proc *p)
{
    8020230e:	1101                	addi	sp,sp,-32
    80202310:	ec06                	sd	ra,24(sp)
    80202312:	e822                	sd	s0,16(sp)
    80202314:	e426                	sd	s1,8(sp)
    80202316:	e04a                	sd	s2,0(sp)
    80202318:	1000                	addi	s0,sp,32
    8020231a:	892a                	mv	s2,a0
	push_queue(&task_queue, p - pool, p->stride);
    8020231c:	0046a497          	auipc	s1,0x46a
    80202320:	ce448493          	addi	s1,s1,-796 # 8066c000 <pool>
    80202324:	409504b3          	sub	s1,a0,s1
    80202328:	848d                	srai	s1,s1,0x3
    8020232a:	00002797          	auipc	a5,0x2
    8020232e:	4d67b783          	ld	a5,1238(a5) # 80204800 <SBI_SET_TIMER+0x8>
    80202332:	02f484b3          	mul	s1,s1,a5
    80202336:	7550                	ld	a2,168(a0)
    80202338:	0004859b          	sext.w	a1,s1
    8020233c:	00066517          	auipc	a0,0x66
    80202340:	e1c50513          	addi	a0,a0,-484 # 80268158 <task_queue>
    80202344:	ffffe097          	auipc	ra,0xffffe
    80202348:	ce4080e7          	jalr	-796(ra) # 80200028 <push_queue>
	debugf("add task %d(pid=%d) to task queue\n", p - pool, p->pid);
    8020234c:	00492603          	lw	a2,4(s2) # 1004 <_entry-0x801feffc>
    80202350:	85a6                	mv	a1,s1
    80202352:	4501                	li	a0,0
    80202354:	ffffe097          	auipc	ra,0xffffe
    80202358:	53e080e7          	jalr	1342(ra) # 80200892 <dummy>
}
    8020235c:	60e2                	ld	ra,24(sp)
    8020235e:	6442                	ld	s0,16(sp)
    80202360:	64a2                	ld	s1,8(sp)
    80202362:	6902                	ld	s2,0(sp)
    80202364:	6105                	addi	sp,sp,32
    80202366:	8082                	ret

0000000080202368 <allocproc>:
// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel.
// If there are no free procs, or a memory allocation fails, return 0.
struct proc *
allocproc()
{
    80202368:	1101                	addi	sp,sp,-32
    8020236a:	ec06                	sd	ra,24(sp)
    8020236c:	e822                	sd	s0,16(sp)
    8020236e:	e426                	sd	s1,8(sp)
    80202370:	1000                	addi	s0,sp,32
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    80202372:	0046a497          	auipc	s1,0x46a
    80202376:	c8e48493          	addi	s1,s1,-882 # 8066c000 <pool>
    8020237a:	00495717          	auipc	a4,0x495
    8020237e:	c8670713          	addi	a4,a4,-890 # 80697000 <app_info_ptr>
		if (p->state == UNUSED) {
    80202382:	409c                	lw	a5,0(s1)
    80202384:	c799                	beqz	a5,80202392 <allocproc+0x2a>
	for (p = pool; p < &pool[NPROC]; p++) {
    80202386:	15848493          	addi	s1,s1,344
    8020238a:	fee49ce3          	bne	s1,a4,80202382 <allocproc+0x1a>
			goto found;
		}
	}
	return 0;
    8020238e:	4481                	li	s1,0
    80202390:	a895                	j	80202404 <allocproc+0x9c>

found:
	// init proc
	p->pid = allocpid();
    80202392:	00000097          	auipc	ra,0x0
    80202396:	f08080e7          	jalr	-248(ra) # 8020229a <allocpid>
    8020239a:	c0c8                	sw	a0,4(s1)
	p->state = USED;
    8020239c:	4785                	li	a5,1
    8020239e:	c09c                	sw	a5,0(s1)
	p->ustack = 0;
    802023a0:	0004b823          	sd	zero,16(s1)
	p->max_page = 0;
    802023a4:	0804bc23          	sd	zero,152(s1)
	p->parent = NULL;
    802023a8:	0a04bc23          	sd	zero,184(s1)
	p->exit_code = 0;
    802023ac:	0c04b023          	sd	zero,192(s1)
	p->pagetable = uvmcreate((uint64)p->trapframe);
    802023b0:	7088                	ld	a0,32(s1)
    802023b2:	fffff097          	auipc	ra,0xfffff
    802023b6:	750080e7          	jalr	1872(ra) # 80201b02 <uvmcreate>
    802023ba:	e488                	sd	a0,8(s1)
	p->program_brk = 0;
    802023bc:	1404b423          	sd	zero,328(s1)
	p->heap_bottom = 0;
    802023c0:	1404b823          	sd	zero,336(s1)
	memset(&p->context, 0, sizeof(p->context));
    802023c4:	07000613          	li	a2,112
    802023c8:	4581                	li	a1,0
    802023ca:	02848513          	addi	a0,s1,40
    802023ce:	ffffe097          	auipc	ra,0xffffe
    802023d2:	316080e7          	jalr	790(ra) # 802006e4 <memset>
	memset((void *)p->kstack, 0, KSTACK_SIZE);
    802023d6:	6605                	lui	a2,0x1
    802023d8:	4581                	li	a1,0
    802023da:	6c88                	ld	a0,24(s1)
    802023dc:	ffffe097          	auipc	ra,0xffffe
    802023e0:	308080e7          	jalr	776(ra) # 802006e4 <memset>
	memset((void *)p->trapframe, 0, TRAP_PAGE_SIZE);
    802023e4:	6605                	lui	a2,0x1
    802023e6:	4581                	li	a1,0
    802023e8:	7088                	ld	a0,32(s1)
    802023ea:	ffffe097          	auipc	ra,0xffffe
    802023ee:	2fa080e7          	jalr	762(ra) # 802006e4 <memset>
	p->context.ra = (uint64)usertrapret;
    802023f2:	ffffe797          	auipc	a5,0xffffe
    802023f6:	5ee78793          	addi	a5,a5,1518 # 802009e0 <usertrapret>
    802023fa:	f49c                	sd	a5,40(s1)
	p->context.sp = p->kstack + KSTACK_SIZE;
    802023fc:	6c9c                	ld	a5,24(s1)
    802023fe:	6705                	lui	a4,0x1
    80202400:	97ba                	add	a5,a5,a4
    80202402:	f89c                	sd	a5,48(s1)
	return p;
}
    80202404:	8526                	mv	a0,s1
    80202406:	60e2                	ld	ra,24(sp)
    80202408:	6442                	ld	s0,16(sp)
    8020240a:	64a2                	ld	s1,8(sp)
    8020240c:	6105                	addi	sp,sp,32
    8020240e:	8082                	ret

0000000080202410 <scheduler>:
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler()
{
    80202410:	711d                	addi	sp,sp,-96
    80202412:	ec86                	sd	ra,88(sp)
    80202414:	e8a2                	sd	s0,80(sp)
    80202416:	e4a6                	sd	s1,72(sp)
    80202418:	e0ca                	sd	s2,64(sp)
    8020241a:	fc4e                	sd	s3,56(sp)
    8020241c:	f852                	sd	s4,48(sp)
    8020241e:	f456                	sd	s5,40(sp)
    80202420:	f05a                	sd	s6,32(sp)
    80202422:	ec5e                	sd	s7,24(sp)
    80202424:	e862                	sd	s8,16(sp)
    80202426:	e466                	sd	s9,8(sp)
    80202428:	1080                	addi	s0,sp,96
	return curr_proc()->pid;
    8020242a:	00495917          	auipc	s2,0x495
    8020242e:	bf690913          	addi	s2,s2,-1034 # 80697020 <current_proc>
		if(has_proc == 0) {
			panic("all app are over!\n");
		}*/
		p = fetch_task();
		if (p == NULL) {
			panic("all app are over!\n");
    80202432:	00002c97          	auipc	s9,0x2
    80202436:	29ec8c93          	addi	s9,s9,670 # 802046d0 <e_text+0x6d0>
    8020243a:	00002c17          	auipc	s8,0x2
    8020243e:	bd6c0c13          	addi	s8,s8,-1066 # 80204010 <e_text+0x10>
    80202442:	00002b97          	auipc	s7,0x2
    80202446:	29eb8b93          	addi	s7,s7,670 # 802046e0 <e_text+0x6e0>
		}
		tracef("swtich to proc %d", p - pool);
    8020244a:	0046ab17          	auipc	s6,0x46a
    8020244e:	bb6b0b13          	addi	s6,s6,-1098 # 8066c000 <pool>
    80202452:	00002a97          	auipc	s5,0x2
    80202456:	3aea8a93          	addi	s5,s5,942 # 80204800 <SBI_SET_TIMER+0x8>
		p->state = RUNNING;
    8020245a:	4a11                	li	s4,4
		p->stride += p->pass;
		current_proc = p;
		swtch(&idle.context, &p->context);
    8020245c:	00066997          	auipc	s3,0x66
    80202460:	bcc98993          	addi	s3,s3,-1076 # 80268028 <idle+0x28>
    80202464:	a8a9                	j	802024be <scheduler+0xae>
	return curr_proc()->pid;
    80202466:	00093683          	ld	a3,0(s2)
			panic("all app are over!\n");
    8020246a:	08200793          	li	a5,130
    8020246e:	8766                	mv	a4,s9
    80202470:	42d4                	lw	a3,4(a3)
    80202472:	8662                	mv	a2,s8
    80202474:	45fd                	li	a1,31
    80202476:	855e                	mv	a0,s7
    80202478:	00000097          	auipc	ra,0x0
    8020247c:	4f2080e7          	jalr	1266(ra) # 8020296a <printf>
    80202480:	00000097          	auipc	ra,0x0
    80202484:	d38080e7          	jalr	-712(ra) # 802021b8 <shutdown>
		tracef("swtich to proc %d", p - pool);
    80202488:	416487b3          	sub	a5,s1,s6
    8020248c:	878d                	srai	a5,a5,0x3
    8020248e:	000ab583          	ld	a1,0(s5)
    80202492:	02b785b3          	mul	a1,a5,a1
    80202496:	4501                	li	a0,0
    80202498:	ffffe097          	auipc	ra,0xffffe
    8020249c:	3fa080e7          	jalr	1018(ra) # 80200892 <dummy>
		p->state = RUNNING;
    802024a0:	0144a023          	sw	s4,0(s1)
		p->stride += p->pass;
    802024a4:	74dc                	ld	a5,168(s1)
    802024a6:	78d8                	ld	a4,176(s1)
    802024a8:	97ba                	add	a5,a5,a4
    802024aa:	f4dc                	sd	a5,168(s1)
		current_proc = p;
    802024ac:	00993023          	sd	s1,0(s2)
		swtch(&idle.context, &p->context);
    802024b0:	02848593          	addi	a1,s1,40
    802024b4:	854e                	mv	a0,s3
    802024b6:	00000097          	auipc	ra,0x0
    802024ba:	6e2080e7          	jalr	1762(ra) # 80202b98 <swtch>
		p = fetch_task();
    802024be:	00000097          	auipc	ra,0x0
    802024c2:	df8080e7          	jalr	-520(ra) # 802022b6 <fetch_task>
    802024c6:	84aa                	mv	s1,a0
		if (p == NULL) {
    802024c8:	f161                	bnez	a0,80202488 <scheduler+0x78>
    802024ca:	bf71                	j	80202466 <scheduler+0x56>

00000000802024cc <sched>:
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched()
{
    802024cc:	1101                	addi	sp,sp,-32
    802024ce:	ec06                	sd	ra,24(sp)
    802024d0:	e822                	sd	s0,16(sp)
    802024d2:	e426                	sd	s1,8(sp)
    802024d4:	1000                	addi	s0,sp,32
	return current_proc;
    802024d6:	00495497          	auipc	s1,0x495
    802024da:	b4a4b483          	ld	s1,-1206(s1) # 80697020 <current_proc>
	struct proc *p = curr_proc();
	if (p->state == RUNNING)
    802024de:	4098                	lw	a4,0(s1)
    802024e0:	4791                	li	a5,4
    802024e2:	02f70163          	beq	a4,a5,80202504 <sched+0x38>
		panic("sched running");
	swtch(&p->context, &idle.context);
    802024e6:	00066597          	auipc	a1,0x66
    802024ea:	b4258593          	addi	a1,a1,-1214 # 80268028 <idle+0x28>
    802024ee:	02848513          	addi	a0,s1,40
    802024f2:	00000097          	auipc	ra,0x0
    802024f6:	6a6080e7          	jalr	1702(ra) # 80202b98 <swtch>
}
    802024fa:	60e2                	ld	ra,24(sp)
    802024fc:	6442                	ld	s0,16(sp)
    802024fe:	64a2                	ld	s1,8(sp)
    80202500:	6105                	addi	sp,sp,32
    80202502:	8082                	ret
		panic("sched running");
    80202504:	09800793          	li	a5,152
    80202508:	00002717          	auipc	a4,0x2
    8020250c:	1c870713          	addi	a4,a4,456 # 802046d0 <e_text+0x6d0>
    80202510:	40d4                	lw	a3,4(s1)
    80202512:	00002617          	auipc	a2,0x2
    80202516:	afe60613          	addi	a2,a2,-1282 # 80204010 <e_text+0x10>
    8020251a:	45fd                	li	a1,31
    8020251c:	00002517          	auipc	a0,0x2
    80202520:	1f450513          	addi	a0,a0,500 # 80204710 <e_text+0x710>
    80202524:	00000097          	auipc	ra,0x0
    80202528:	446080e7          	jalr	1094(ra) # 8020296a <printf>
    8020252c:	00000097          	auipc	ra,0x0
    80202530:	c8c080e7          	jalr	-884(ra) # 802021b8 <shutdown>
    80202534:	bf4d                	j	802024e6 <sched+0x1a>

0000000080202536 <yield>:

// Give up the CPU for one scheduling round.
void
yield()
{
    80202536:	1141                	addi	sp,sp,-16
    80202538:	e406                	sd	ra,8(sp)
    8020253a:	e022                	sd	s0,0(sp)
    8020253c:	0800                	addi	s0,sp,16
	current_proc->state = RUNNABLE;
    8020253e:	00495797          	auipc	a5,0x495
    80202542:	ae278793          	addi	a5,a5,-1310 # 80697020 <current_proc>
    80202546:	6398                	ld	a4,0(a5)
    80202548:	468d                	li	a3,3
    8020254a:	c314                	sw	a3,0(a4)
	add_task(current_proc);
    8020254c:	6388                	ld	a0,0(a5)
    8020254e:	00000097          	auipc	ra,0x0
    80202552:	dc0080e7          	jalr	-576(ra) # 8020230e <add_task>
	sched();
    80202556:	00000097          	auipc	ra,0x0
    8020255a:	f76080e7          	jalr	-138(ra) # 802024cc <sched>
}
    8020255e:	60a2                	ld	ra,8(sp)
    80202560:	6402                	ld	s0,0(sp)
    80202562:	0141                	addi	sp,sp,16
    80202564:	8082                	ret

0000000080202566 <freepagetable>:

// Free a process's page table, and free the
// physical memory it refers to.
void
freepagetable(pagetable_t pagetable, uint64 max_page)
{
    80202566:	1101                	addi	sp,sp,-32
    80202568:	ec06                	sd	ra,24(sp)
    8020256a:	e822                	sd	s0,16(sp)
    8020256c:	e426                	sd	s1,8(sp)
    8020256e:	e04a                	sd	s2,0(sp)
    80202570:	1000                	addi	s0,sp,32
    80202572:	84aa                	mv	s1,a0
    80202574:	892e                	mv	s2,a1
	uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80202576:	4681                	li	a3,0
    80202578:	4605                	li	a2,1
    8020257a:	040005b7          	lui	a1,0x4000
    8020257e:	15fd                	addi	a1,a1,-1
    80202580:	05b2                	slli	a1,a1,0xc
    80202582:	fffff097          	auipc	ra,0xfffff
    80202586:	370080e7          	jalr	880(ra) # 802018f2 <uvmunmap>
	uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8020258a:	4681                	li	a3,0
    8020258c:	4605                	li	a2,1
    8020258e:	020005b7          	lui	a1,0x2000
    80202592:	15fd                	addi	a1,a1,-1
    80202594:	05b6                	slli	a1,a1,0xd
    80202596:	8526                	mv	a0,s1
    80202598:	fffff097          	auipc	ra,0xfffff
    8020259c:	35a080e7          	jalr	858(ra) # 802018f2 <uvmunmap>
	uvmfree(pagetable, max_page);
    802025a0:	85ca                	mv	a1,s2
    802025a2:	8526                	mv	a0,s1
    802025a4:	fffff097          	auipc	ra,0xfffff
    802025a8:	710080e7          	jalr	1808(ra) # 80201cb4 <uvmfree>
}
    802025ac:	60e2                	ld	ra,24(sp)
    802025ae:	6442                	ld	s0,16(sp)
    802025b0:	64a2                	ld	s1,8(sp)
    802025b2:	6902                	ld	s2,0(sp)
    802025b4:	6105                	addi	sp,sp,32
    802025b6:	8082                	ret

00000000802025b8 <freeproc>:

void
freeproc(struct proc *p)
{
    802025b8:	1101                	addi	sp,sp,-32
    802025ba:	ec06                	sd	ra,24(sp)
    802025bc:	e822                	sd	s0,16(sp)
    802025be:	e426                	sd	s1,8(sp)
    802025c0:	1000                	addi	s0,sp,32
    802025c2:	84aa                	mv	s1,a0
	debugf("free pagetable %p, max page: %d", p->pagetable, p->max_page);
    802025c4:	6d50                	ld	a2,152(a0)
    802025c6:	650c                	ld	a1,8(a0)
    802025c8:	4501                	li	a0,0
    802025ca:	ffffe097          	auipc	ra,0xffffe
    802025ce:	2c8080e7          	jalr	712(ra) # 80200892 <dummy>
	if (p->pagetable)
    802025d2:	6488                	ld	a0,8(s1)
    802025d4:	c511                	beqz	a0,802025e0 <freeproc+0x28>
		freepagetable(p->pagetable, p->max_page);
    802025d6:	6ccc                	ld	a1,152(s1)
    802025d8:	00000097          	auipc	ra,0x0
    802025dc:	f8e080e7          	jalr	-114(ra) # 80202566 <freepagetable>
	p->pagetable = 0;
    802025e0:	0004b423          	sd	zero,8(s1)
	p->state = UNUSED;
    802025e4:	0004a023          	sw	zero,0(s1)
}
    802025e8:	60e2                	ld	ra,24(sp)
    802025ea:	6442                	ld	s0,16(sp)
    802025ec:	64a2                	ld	s1,8(sp)
    802025ee:	6105                	addi	sp,sp,32
    802025f0:	8082                	ret

00000000802025f2 <fork>:

int
fork()
{
    802025f2:	1101                	addi	sp,sp,-32
    802025f4:	ec06                	sd	ra,24(sp)
    802025f6:	e822                	sd	s0,16(sp)
    802025f8:	e426                	sd	s1,8(sp)
    802025fa:	e04a                	sd	s2,0(sp)
    802025fc:	1000                	addi	s0,sp,32
	return current_proc;
    802025fe:	00495917          	auipc	s2,0x495
    80202602:	a2293903          	ld	s2,-1502(s2) # 80697020 <current_proc>
	struct proc *np;
	struct proc *p = curr_proc();
	// Allocate process.
	if ((np = allocproc()) == 0) {
    80202606:	00000097          	auipc	ra,0x0
    8020260a:	d62080e7          	jalr	-670(ra) # 80202368 <allocproc>
    8020260e:	84aa                	mv	s1,a0
    80202610:	c925                	beqz	a0,80202680 <fork+0x8e>
		panic("allocproc\n");
	}
	// Copy user memory from parent to child.
	if (uvmcopy(p->pagetable, np->pagetable, p->max_page) < 0) {
    80202612:	09893603          	ld	a2,152(s2)
    80202616:	648c                	ld	a1,8(s1)
    80202618:	00893503          	ld	a0,8(s2)
    8020261c:	fffff097          	auipc	ra,0xfffff
    80202620:	6ca080e7          	jalr	1738(ra) # 80201ce6 <uvmcopy>
    80202624:	08054b63          	bltz	a0,802026ba <fork+0xc8>
		panic("uvmcopy\n");
	}
	np->max_page = p->max_page;
    80202628:	09893783          	ld	a5,152(s2)
    8020262c:	ecdc                	sd	a5,152(s1)
	// copy saved user registers.
	*(np->trapframe) = *(p->trapframe);
    8020262e:	02093683          	ld	a3,32(s2)
    80202632:	87b6                	mv	a5,a3
    80202634:	7098                	ld	a4,32(s1)
    80202636:	12068693          	addi	a3,a3,288
    8020263a:	0007b803          	ld	a6,0(a5)
    8020263e:	6788                	ld	a0,8(a5)
    80202640:	6b8c                	ld	a1,16(a5)
    80202642:	6f90                	ld	a2,24(a5)
    80202644:	01073023          	sd	a6,0(a4)
    80202648:	e708                	sd	a0,8(a4)
    8020264a:	eb0c                	sd	a1,16(a4)
    8020264c:	ef10                	sd	a2,24(a4)
    8020264e:	02078793          	addi	a5,a5,32
    80202652:	02070713          	addi	a4,a4,32
    80202656:	fed792e3          	bne	a5,a3,8020263a <fork+0x48>
	// Cause fork to return 0 in the child.
	np->trapframe->a0 = 0;
    8020265a:	709c                	ld	a5,32(s1)
    8020265c:	0607b823          	sd	zero,112(a5)
	np->parent = p;
    80202660:	0b24bc23          	sd	s2,184(s1)
	np->state = RUNNABLE;
    80202664:	478d                	li	a5,3
    80202666:	c09c                	sw	a5,0(s1)
	add_task(np);
    80202668:	8526                	mv	a0,s1
    8020266a:	00000097          	auipc	ra,0x0
    8020266e:	ca4080e7          	jalr	-860(ra) # 8020230e <add_task>
	return np->pid;
}
    80202672:	40c8                	lw	a0,4(s1)
    80202674:	60e2                	ld	ra,24(sp)
    80202676:	6442                	ld	s0,16(sp)
    80202678:	64a2                	ld	s1,8(sp)
    8020267a:	6902                	ld	s2,0(sp)
    8020267c:	6105                	addi	sp,sp,32
    8020267e:	8082                	ret
		panic("allocproc\n");
    80202680:	0c000793          	li	a5,192
    80202684:	00002717          	auipc	a4,0x2
    80202688:	04c70713          	addi	a4,a4,76 # 802046d0 <e_text+0x6d0>
    8020268c:	00495697          	auipc	a3,0x495
    80202690:	9946b683          	ld	a3,-1644(a3) # 80697020 <current_proc>
    80202694:	42d4                	lw	a3,4(a3)
    80202696:	00002617          	auipc	a2,0x2
    8020269a:	97a60613          	addi	a2,a2,-1670 # 80204010 <e_text+0x10>
    8020269e:	45fd                	li	a1,31
    802026a0:	00002517          	auipc	a0,0x2
    802026a4:	a3050513          	addi	a0,a0,-1488 # 802040d0 <e_text+0xd0>
    802026a8:	00000097          	auipc	ra,0x0
    802026ac:	2c2080e7          	jalr	706(ra) # 8020296a <printf>
    802026b0:	00000097          	auipc	ra,0x0
    802026b4:	b08080e7          	jalr	-1272(ra) # 802021b8 <shutdown>
    802026b8:	bfa9                	j	80202612 <fork+0x20>
		panic("uvmcopy\n");
    802026ba:	0c400793          	li	a5,196
    802026be:	00002717          	auipc	a4,0x2
    802026c2:	01270713          	addi	a4,a4,18 # 802046d0 <e_text+0x6d0>
    802026c6:	00495697          	auipc	a3,0x495
    802026ca:	95a6b683          	ld	a3,-1702(a3) # 80697020 <current_proc>
    802026ce:	42d4                	lw	a3,4(a3)
    802026d0:	00002617          	auipc	a2,0x2
    802026d4:	94060613          	addi	a2,a2,-1728 # 80204010 <e_text+0x10>
    802026d8:	45fd                	li	a1,31
    802026da:	00002517          	auipc	a0,0x2
    802026de:	05e50513          	addi	a0,a0,94 # 80204738 <e_text+0x738>
    802026e2:	00000097          	auipc	ra,0x0
    802026e6:	288080e7          	jalr	648(ra) # 8020296a <printf>
    802026ea:	00000097          	auipc	ra,0x0
    802026ee:	ace080e7          	jalr	-1330(ra) # 802021b8 <shutdown>
    802026f2:	bf1d                	j	80202628 <fork+0x36>

00000000802026f4 <exec>:

int
exec(char *name)
{
    802026f4:	1101                	addi	sp,sp,-32
    802026f6:	ec06                	sd	ra,24(sp)
    802026f8:	e822                	sd	s0,16(sp)
    802026fa:	e426                	sd	s1,8(sp)
    802026fc:	e04a                	sd	s2,0(sp)
    802026fe:	1000                	addi	s0,sp,32
	int id = get_id_by_name(name);
    80202700:	ffffe097          	auipc	ra,0xffffe
    80202704:	bca080e7          	jalr	-1078(ra) # 802002ca <get_id_by_name>
	if (id < 0)
    80202708:	04054063          	bltz	a0,80202748 <exec+0x54>
    8020270c:	84aa                	mv	s1,a0
	return current_proc;
    8020270e:	00495917          	auipc	s2,0x495
    80202712:	91293903          	ld	s2,-1774(s2) # 80697020 <current_proc>
		return -1;
	struct proc *p = curr_proc();
	uvmunmap(p->pagetable, 0, p->max_page, 1);
    80202716:	4685                	li	a3,1
    80202718:	09893603          	ld	a2,152(s2)
    8020271c:	4581                	li	a1,0
    8020271e:	00893503          	ld	a0,8(s2)
    80202722:	fffff097          	auipc	ra,0xfffff
    80202726:	1d0080e7          	jalr	464(ra) # 802018f2 <uvmunmap>
	p->max_page = 0;
    8020272a:	08093c23          	sd	zero,152(s2)
	loader(id, p);
    8020272e:	85ca                	mv	a1,s2
    80202730:	8526                	mv	a0,s1
    80202732:	ffffe097          	auipc	ra,0xffffe
    80202736:	ea6080e7          	jalr	-346(ra) # 802005d8 <loader>
	return 0;
    8020273a:	4501                	li	a0,0
}
    8020273c:	60e2                	ld	ra,24(sp)
    8020273e:	6442                	ld	s0,16(sp)
    80202740:	64a2                	ld	s1,8(sp)
    80202742:	6902                	ld	s2,0(sp)
    80202744:	6105                	addi	sp,sp,32
    80202746:	8082                	ret
		return -1;
    80202748:	557d                	li	a0,-1
    8020274a:	bfcd                	j	8020273c <exec+0x48>

000000008020274c <wait>:

int
wait(int pid, int *code)
{
    8020274c:	715d                	addi	sp,sp,-80
    8020274e:	e486                	sd	ra,72(sp)
    80202750:	e0a2                	sd	s0,64(sp)
    80202752:	fc26                	sd	s1,56(sp)
    80202754:	f84a                	sd	s2,48(sp)
    80202756:	f44e                	sd	s3,40(sp)
    80202758:	f052                	sd	s4,32(sp)
    8020275a:	ec56                	sd	s5,24(sp)
    8020275c:	e85a                	sd	s6,16(sp)
    8020275e:	e45e                	sd	s7,8(sp)
    80202760:	e062                	sd	s8,0(sp)
    80202762:	0880                	addi	s0,sp,80
    80202764:	89aa                	mv	s3,a0
    80202766:	8b2e                	mv	s6,a1
	return current_proc;
    80202768:	00495917          	auipc	s2,0x495
    8020276c:	8b893903          	ld	s2,-1864(s2) # 80697020 <current_proc>
	int havekids;
	struct proc *p = curr_proc();

	for (;;) {
		// Scan through table looking for exited children.
		havekids = 0;
    80202770:	4b81                	li	s7,0
		for (np = pool; np < &pool[NPROC]; np++) {
			if (np->state != UNUSED && np->parent == p &&
			    (pid <= 0 || np->pid == pid)) {
				havekids = 1;
				if (np->state == ZOMBIE) {
    80202772:	4a15                	li	s4,5
				havekids = 1;
    80202774:	4a85                	li	s5,1
		for (np = pool; np < &pool[NPROC]; np++) {
    80202776:	00495497          	auipc	s1,0x495
    8020277a:	88a48493          	addi	s1,s1,-1910 # 80697000 <app_info_ptr>
			}
		}
		if (!havekids) {
			return -1;
		}
		p->state = RUNNABLE;
    8020277e:	4c0d                	li	s8,3
		havekids = 0;
    80202780:	865e                	mv	a2,s7
		for (np = pool; np < &pool[NPROC]; np++) {
    80202782:	0046a797          	auipc	a5,0x46a
    80202786:	87e78793          	addi	a5,a5,-1922 # 8066c000 <pool>
    8020278a:	a801                	j	8020279a <wait+0x4e>
				if (np->state == ZOMBIE) {
    8020278c:	03470263          	beq	a4,s4,802027b0 <wait+0x64>
				havekids = 1;
    80202790:	8656                	mv	a2,s5
		for (np = pool; np < &pool[NPROC]; np++) {
    80202792:	15878793          	addi	a5,a5,344
    80202796:	02978463          	beq	a5,s1,802027be <wait+0x72>
			if (np->state != UNUSED && np->parent == p &&
    8020279a:	4398                	lw	a4,0(a5)
    8020279c:	db7d                	beqz	a4,80202792 <wait+0x46>
    8020279e:	7fd4                	ld	a3,184(a5)
    802027a0:	ff2699e3          	bne	a3,s2,80202792 <wait+0x46>
    802027a4:	ff3054e3          	blez	s3,8020278c <wait+0x40>
			    (pid <= 0 || np->pid == pid)) {
    802027a8:	43d4                	lw	a3,4(a5)
    802027aa:	ff3694e3          	bne	a3,s3,80202792 <wait+0x46>
    802027ae:	bff9                	j	8020278c <wait+0x40>
					np->state = UNUSED;
    802027b0:	0007a023          	sw	zero,0(a5)
					pid = np->pid;
    802027b4:	43c8                	lw	a0,4(a5)
					*code = np->exit_code;
    802027b6:	63fc                	ld	a5,192(a5)
    802027b8:	00fb2023          	sw	a5,0(s6)
					return pid;
    802027bc:	a019                	j	802027c2 <wait+0x76>
		if (!havekids) {
    802027be:	ee11                	bnez	a2,802027da <wait+0x8e>
			return -1;
    802027c0:	557d                	li	a0,-1
		add_task(p);
		sched();
	}
}
    802027c2:	60a6                	ld	ra,72(sp)
    802027c4:	6406                	ld	s0,64(sp)
    802027c6:	74e2                	ld	s1,56(sp)
    802027c8:	7942                	ld	s2,48(sp)
    802027ca:	79a2                	ld	s3,40(sp)
    802027cc:	7a02                	ld	s4,32(sp)
    802027ce:	6ae2                	ld	s5,24(sp)
    802027d0:	6b42                	ld	s6,16(sp)
    802027d2:	6ba2                	ld	s7,8(sp)
    802027d4:	6c02                	ld	s8,0(sp)
    802027d6:	6161                	addi	sp,sp,80
    802027d8:	8082                	ret
		p->state = RUNNABLE;
    802027da:	01892023          	sw	s8,0(s2)
		add_task(p);
    802027de:	854a                	mv	a0,s2
    802027e0:	00000097          	auipc	ra,0x0
    802027e4:	b2e080e7          	jalr	-1234(ra) # 8020230e <add_task>
		sched();
    802027e8:	00000097          	auipc	ra,0x0
    802027ec:	ce4080e7          	jalr	-796(ra) # 802024cc <sched>
		havekids = 0;
    802027f0:	bf41                	j	80202780 <wait+0x34>

00000000802027f2 <exit>:

// Exit the current process.
void
exit(int code)
{
    802027f2:	1101                	addi	sp,sp,-32
    802027f4:	ec06                	sd	ra,24(sp)
    802027f6:	e822                	sd	s0,16(sp)
    802027f8:	e426                	sd	s1,8(sp)
    802027fa:	1000                	addi	s0,sp,32
    802027fc:	862a                	mv	a2,a0
	return current_proc;
    802027fe:	00495497          	auipc	s1,0x495
    80202802:	8224b483          	ld	s1,-2014(s1) # 80697020 <current_proc>
	struct proc *p = curr_proc();
	p->exit_code = code;
    80202806:	e0e8                	sd	a0,192(s1)
	debugf("proc %d exit with %d\n", p->pid, code);
    80202808:	40cc                	lw	a1,4(s1)
    8020280a:	4501                	li	a0,0
    8020280c:	ffffe097          	auipc	ra,0xffffe
    80202810:	086080e7          	jalr	134(ra) # 80200892 <dummy>
	freeproc(p);
    80202814:	8526                	mv	a0,s1
    80202816:	00000097          	auipc	ra,0x0
    8020281a:	da2080e7          	jalr	-606(ra) # 802025b8 <freeproc>
	if (p->parent != NULL) {
    8020281e:	7cdc                	ld	a5,184(s1)
    80202820:	c399                	beqz	a5,80202826 <exit+0x34>
		// Parent should `wait`
		p->state = ZOMBIE;
    80202822:	4795                	li	a5,5
    80202824:	c09c                	sw	a5,0(s1)
{
    80202826:	00469797          	auipc	a5,0x469
    8020282a:	7da78793          	addi	a5,a5,2010 # 8066c000 <pool>
	}
	// Set the `parent` of all children to NULL
	struct proc *np;
	for (np = pool; np < &pool[NPROC]; np++) {
    8020282e:	00494697          	auipc	a3,0x494
    80202832:	7d268693          	addi	a3,a3,2002 # 80697000 <app_info_ptr>
    80202836:	a029                	j	80202840 <exit+0x4e>
    80202838:	15878793          	addi	a5,a5,344
    8020283c:	00d78863          	beq	a5,a3,8020284c <exit+0x5a>
		if (np->parent == p) {
    80202840:	7fd8                	ld	a4,184(a5)
    80202842:	fe971be3          	bne	a4,s1,80202838 <exit+0x46>
			np->parent = NULL;
    80202846:	0a07bc23          	sd	zero,184(a5)
    8020284a:	b7fd                	j	80202838 <exit+0x46>
		}
	}
	sched();
    8020284c:	00000097          	auipc	ra,0x0
    80202850:	c80080e7          	jalr	-896(ra) # 802024cc <sched>
}
    80202854:	60e2                	ld	ra,24(sp)
    80202856:	6442                	ld	s0,16(sp)
    80202858:	64a2                	ld	s1,8(sp)
    8020285a:	6105                	addi	sp,sp,32
    8020285c:	8082                	ret

000000008020285e <growproc>:

// Grow or shrink user memory by n bytes.
// Return 0 on succness, -1 on failure.
int
growproc(int n)
{
    8020285e:	1101                	addi	sp,sp,-32
    80202860:	ec06                	sd	ra,24(sp)
    80202862:	e822                	sd	s0,16(sp)
    80202864:	e426                	sd	s1,8(sp)
    80202866:	1000                	addi	s0,sp,32
	return current_proc;
    80202868:	00494497          	auipc	s1,0x494
    8020286c:	7b84b483          	ld	s1,1976(s1) # 80697020 <current_proc>
	uint64 program_brk;
	struct proc *p = curr_proc();
	program_brk = p->program_brk;
    80202870:	1484b583          	ld	a1,328(s1)
	int new_brk = program_brk + n - p->heap_bottom;
    80202874:	1504b783          	ld	a5,336(s1)
    80202878:	40f507bb          	subw	a5,a0,a5
	if (new_brk < 0) {
    8020287c:	9fad                	addw	a5,a5,a1
    8020287e:	0407c363          	bltz	a5,802028c4 <growproc+0x66>
		return -1;
	}
	if (n > 0) {
    80202882:	00a04c63          	bgtz	a0,8020289a <growproc+0x3c>
		if ((program_brk = uvmalloc(p->pagetable, program_brk,
					    program_brk + n, PTE_W)) == 0) {
			return -1;
		}
	} else if (n < 0) {
    80202886:	02054663          	bltz	a0,802028b2 <growproc+0x54>
		program_brk =
			uvmdealloc(p->pagetable, program_brk, program_brk + n);
	}
	p->program_brk = program_brk;
    8020288a:	14b4b423          	sd	a1,328(s1)
	return 0;
    8020288e:	4501                	li	a0,0
}
    80202890:	60e2                	ld	ra,24(sp)
    80202892:	6442                	ld	s0,16(sp)
    80202894:	64a2                	ld	s1,8(sp)
    80202896:	6105                	addi	sp,sp,32
    80202898:	8082                	ret
		if ((program_brk = uvmalloc(p->pagetable, program_brk,
    8020289a:	4691                	li	a3,4
    8020289c:	00b50633          	add	a2,a0,a1
    802028a0:	6488                	ld	a0,8(s1)
    802028a2:	fffff097          	auipc	ra,0xfffff
    802028a6:	70a080e7          	jalr	1802(ra) # 80201fac <uvmalloc>
    802028aa:	85aa                	mv	a1,a0
    802028ac:	fd79                	bnez	a0,8020288a <growproc+0x2c>
			return -1;
    802028ae:	557d                	li	a0,-1
    802028b0:	b7c5                	j	80202890 <growproc+0x32>
			uvmdealloc(p->pagetable, program_brk, program_brk + n);
    802028b2:	00b50633          	add	a2,a0,a1
    802028b6:	6488                	ld	a0,8(s1)
    802028b8:	fffff097          	auipc	ra,0xfffff
    802028bc:	6ac080e7          	jalr	1708(ra) # 80201f64 <uvmdealloc>
    802028c0:	85aa                	mv	a1,a0
    802028c2:	b7e1                	j	8020288a <growproc+0x2c>
		return -1;
    802028c4:	557d                	li	a0,-1
    802028c6:	b7e9                	j	80202890 <growproc+0x32>

00000000802028c8 <printint>:
#include "console.h"
#include "defs.h"
static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    802028c8:	7179                	addi	sp,sp,-48
    802028ca:	f406                	sd	ra,40(sp)
    802028cc:	f022                	sd	s0,32(sp)
    802028ce:	ec26                	sd	s1,24(sp)
    802028d0:	e84a                	sd	s2,16(sp)
    802028d2:	1800                	addi	s0,sp,48
	char buf[16];
	int i;
	uint x;

	if (sign && (sign = xx < 0))
    802028d4:	c219                	beqz	a2,802028da <printint+0x12>
    802028d6:	08054663          	bltz	a0,80202962 <printint+0x9a>
		x = -xx;
	else
		x = xx;
    802028da:	2501                	sext.w	a0,a0
    802028dc:	4881                	li	a7,0
    802028de:	fd040693          	addi	a3,s0,-48

	i = 0;
    802028e2:	4701                	li	a4,0
	do {
		buf[i++] = digits[x % base];
    802028e4:	2581                	sext.w	a1,a1
    802028e6:	00002617          	auipc	a2,0x2
    802028ea:	eba60613          	addi	a2,a2,-326 # 802047a0 <digits>
    802028ee:	883a                	mv	a6,a4
    802028f0:	2705                	addiw	a4,a4,1
    802028f2:	02b577bb          	remuw	a5,a0,a1
    802028f6:	1782                	slli	a5,a5,0x20
    802028f8:	9381                	srli	a5,a5,0x20
    802028fa:	97b2                	add	a5,a5,a2
    802028fc:	0007c783          	lbu	a5,0(a5)
    80202900:	00f68023          	sb	a5,0(a3)
	} while ((x /= base) != 0);
    80202904:	0005079b          	sext.w	a5,a0
    80202908:	02b5553b          	divuw	a0,a0,a1
    8020290c:	0685                	addi	a3,a3,1
    8020290e:	feb7f0e3          	bgeu	a5,a1,802028ee <printint+0x26>

	if (sign)
    80202912:	00088b63          	beqz	a7,80202928 <printint+0x60>
		buf[i++] = '-';
    80202916:	fe040793          	addi	a5,s0,-32
    8020291a:	973e                	add	a4,a4,a5
    8020291c:	02d00793          	li	a5,45
    80202920:	fef70823          	sb	a5,-16(a4)
    80202924:	0028071b          	addiw	a4,a6,2

	while (--i >= 0)
    80202928:	02e05763          	blez	a4,80202956 <printint+0x8e>
    8020292c:	fd040793          	addi	a5,s0,-48
    80202930:	00e784b3          	add	s1,a5,a4
    80202934:	fff78913          	addi	s2,a5,-1
    80202938:	993a                	add	s2,s2,a4
    8020293a:	377d                	addiw	a4,a4,-1
    8020293c:	1702                	slli	a4,a4,0x20
    8020293e:	9301                	srli	a4,a4,0x20
    80202940:	40e90933          	sub	s2,s2,a4
		consputc(buf[i]);
    80202944:	fff4c503          	lbu	a0,-1(s1)
    80202948:	ffffe097          	auipc	ra,0xffffe
    8020294c:	380080e7          	jalr	896(ra) # 80200cc8 <consputc>
	while (--i >= 0)
    80202950:	14fd                	addi	s1,s1,-1
    80202952:	ff2499e3          	bne	s1,s2,80202944 <printint+0x7c>
}
    80202956:	70a2                	ld	ra,40(sp)
    80202958:	7402                	ld	s0,32(sp)
    8020295a:	64e2                	ld	s1,24(sp)
    8020295c:	6942                	ld	s2,16(sp)
    8020295e:	6145                	addi	sp,sp,48
    80202960:	8082                	ret
		x = -xx;
    80202962:	40a0053b          	negw	a0,a0
	if (sign && (sign = xx < 0))
    80202966:	4885                	li	a7,1
		x = -xx;
    80202968:	bf9d                	j	802028de <printint+0x16>

000000008020296a <printf>:
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(char *fmt, ...)
{
    8020296a:	7131                	addi	sp,sp,-192
    8020296c:	fc86                	sd	ra,120(sp)
    8020296e:	f8a2                	sd	s0,112(sp)
    80202970:	f4a6                	sd	s1,104(sp)
    80202972:	f0ca                	sd	s2,96(sp)
    80202974:	ecce                	sd	s3,88(sp)
    80202976:	e8d2                	sd	s4,80(sp)
    80202978:	e4d6                	sd	s5,72(sp)
    8020297a:	e0da                	sd	s6,64(sp)
    8020297c:	fc5e                	sd	s7,56(sp)
    8020297e:	f862                	sd	s8,48(sp)
    80202980:	f466                	sd	s9,40(sp)
    80202982:	f06a                	sd	s10,32(sp)
    80202984:	ec6e                	sd	s11,24(sp)
    80202986:	0100                	addi	s0,sp,128
    80202988:	8a2a                	mv	s4,a0
    8020298a:	e40c                	sd	a1,8(s0)
    8020298c:	e810                	sd	a2,16(s0)
    8020298e:	ec14                	sd	a3,24(s0)
    80202990:	f018                	sd	a4,32(s0)
    80202992:	f41c                	sd	a5,40(s0)
    80202994:	03043823          	sd	a6,48(s0)
    80202998:	03143c23          	sd	a7,56(s0)
	va_list ap;
	int i, c;
	char *s;

	if (fmt == 0)
    8020299c:	c915                	beqz	a0,802029d0 <printf+0x66>
		panic("null fmt");

	va_start(ap, fmt);
    8020299e:	00840793          	addi	a5,s0,8
    802029a2:	f8f43423          	sd	a5,-120(s0)
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    802029a6:	000a4503          	lbu	a0,0(s4) # fffffffffffff000 <e_bss+0xffffffff7f967000>
    802029aa:	16050c63          	beqz	a0,80202b22 <printf+0x1b8>
    802029ae:	4981                	li	s3,0
		if (c != '%') {
    802029b0:	02500a93          	li	s5,37
			continue;
		}
		c = fmt[++i] & 0xff;
		if (c == 0)
			break;
		switch (c) {
    802029b4:	07000b93          	li	s7,112
	consputc('x');
    802029b8:	4d41                	li	s10,16
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802029ba:	00002b17          	auipc	s6,0x2
    802029be:	de6b0b13          	addi	s6,s6,-538 # 802047a0 <digits>
		switch (c) {
    802029c2:	07300c93          	li	s9,115
			printptr(va_arg(ap, uint64));
			break;
		case 's':
			if ((s = va_arg(ap, char *)) == 0)
				s = "(null)";
			for (; *s; s++)
    802029c6:	02800d93          	li	s11,40
		switch (c) {
    802029ca:	06400c13          	li	s8,100
    802029ce:	a889                	j	80202a20 <printf+0xb6>
		panic("null fmt");
    802029d0:	00000097          	auipc	ra,0x0
    802029d4:	816080e7          	jalr	-2026(ra) # 802021e6 <threadid>
    802029d8:	86aa                	mv	a3,a0
    802029da:	02e00793          	li	a5,46
    802029de:	00002717          	auipc	a4,0x2
    802029e2:	d8a70713          	addi	a4,a4,-630 # 80204768 <e_text+0x768>
    802029e6:	00001617          	auipc	a2,0x1
    802029ea:	62a60613          	addi	a2,a2,1578 # 80204010 <e_text+0x10>
    802029ee:	45fd                	li	a1,31
    802029f0:	00002517          	auipc	a0,0x2
    802029f4:	d8850513          	addi	a0,a0,-632 # 80204778 <e_text+0x778>
    802029f8:	00000097          	auipc	ra,0x0
    802029fc:	f72080e7          	jalr	-142(ra) # 8020296a <printf>
    80202a00:	fffff097          	auipc	ra,0xfffff
    80202a04:	7b8080e7          	jalr	1976(ra) # 802021b8 <shutdown>
    80202a08:	bf59                	j	8020299e <printf+0x34>
			consputc(c);
    80202a0a:	ffffe097          	auipc	ra,0xffffe
    80202a0e:	2be080e7          	jalr	702(ra) # 80200cc8 <consputc>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80202a12:	2985                	addiw	s3,s3,1
    80202a14:	013a07b3          	add	a5,s4,s3
    80202a18:	0007c503          	lbu	a0,0(a5)
    80202a1c:	10050363          	beqz	a0,80202b22 <printf+0x1b8>
		if (c != '%') {
    80202a20:	ff5515e3          	bne	a0,s5,80202a0a <printf+0xa0>
		c = fmt[++i] & 0xff;
    80202a24:	2985                	addiw	s3,s3,1
    80202a26:	013a07b3          	add	a5,s4,s3
    80202a2a:	0007c783          	lbu	a5,0(a5)
    80202a2e:	0007849b          	sext.w	s1,a5
		if (c == 0)
    80202a32:	cbe5                	beqz	a5,80202b22 <printf+0x1b8>
		switch (c) {
    80202a34:	05778a63          	beq	a5,s7,80202a88 <printf+0x11e>
    80202a38:	02fbf663          	bgeu	s7,a5,80202a64 <printf+0xfa>
    80202a3c:	09978863          	beq	a5,s9,80202acc <printf+0x162>
    80202a40:	07800713          	li	a4,120
    80202a44:	0ce79463          	bne	a5,a4,80202b0c <printf+0x1a2>
			printint(va_arg(ap, int), 16, 1);
    80202a48:	f8843783          	ld	a5,-120(s0)
    80202a4c:	00878713          	addi	a4,a5,8
    80202a50:	f8e43423          	sd	a4,-120(s0)
    80202a54:	4605                	li	a2,1
    80202a56:	85ea                	mv	a1,s10
    80202a58:	4388                	lw	a0,0(a5)
    80202a5a:	00000097          	auipc	ra,0x0
    80202a5e:	e6e080e7          	jalr	-402(ra) # 802028c8 <printint>
			break;
    80202a62:	bf45                	j	80202a12 <printf+0xa8>
		switch (c) {
    80202a64:	09578e63          	beq	a5,s5,80202b00 <printf+0x196>
    80202a68:	0b879263          	bne	a5,s8,80202b0c <printf+0x1a2>
			printint(va_arg(ap, int), 10, 1);
    80202a6c:	f8843783          	ld	a5,-120(s0)
    80202a70:	00878713          	addi	a4,a5,8
    80202a74:	f8e43423          	sd	a4,-120(s0)
    80202a78:	4605                	li	a2,1
    80202a7a:	45a9                	li	a1,10
    80202a7c:	4388                	lw	a0,0(a5)
    80202a7e:	00000097          	auipc	ra,0x0
    80202a82:	e4a080e7          	jalr	-438(ra) # 802028c8 <printint>
			break;
    80202a86:	b771                	j	80202a12 <printf+0xa8>
			printptr(va_arg(ap, uint64));
    80202a88:	f8843783          	ld	a5,-120(s0)
    80202a8c:	00878713          	addi	a4,a5,8
    80202a90:	f8e43423          	sd	a4,-120(s0)
    80202a94:	0007b903          	ld	s2,0(a5)
	consputc('0');
    80202a98:	03000513          	li	a0,48
    80202a9c:	ffffe097          	auipc	ra,0xffffe
    80202aa0:	22c080e7          	jalr	556(ra) # 80200cc8 <consputc>
	consputc('x');
    80202aa4:	07800513          	li	a0,120
    80202aa8:	ffffe097          	auipc	ra,0xffffe
    80202aac:	220080e7          	jalr	544(ra) # 80200cc8 <consputc>
    80202ab0:	84ea                	mv	s1,s10
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80202ab2:	03c95793          	srli	a5,s2,0x3c
    80202ab6:	97da                	add	a5,a5,s6
    80202ab8:	0007c503          	lbu	a0,0(a5)
    80202abc:	ffffe097          	auipc	ra,0xffffe
    80202ac0:	20c080e7          	jalr	524(ra) # 80200cc8 <consputc>
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80202ac4:	0912                	slli	s2,s2,0x4
    80202ac6:	34fd                	addiw	s1,s1,-1
    80202ac8:	f4ed                	bnez	s1,80202ab2 <printf+0x148>
    80202aca:	b7a1                	j	80202a12 <printf+0xa8>
			if ((s = va_arg(ap, char *)) == 0)
    80202acc:	f8843783          	ld	a5,-120(s0)
    80202ad0:	00878713          	addi	a4,a5,8
    80202ad4:	f8e43423          	sd	a4,-120(s0)
    80202ad8:	6384                	ld	s1,0(a5)
    80202ada:	cc89                	beqz	s1,80202af4 <printf+0x18a>
			for (; *s; s++)
    80202adc:	0004c503          	lbu	a0,0(s1)
    80202ae0:	d90d                	beqz	a0,80202a12 <printf+0xa8>
				consputc(*s);
    80202ae2:	ffffe097          	auipc	ra,0xffffe
    80202ae6:	1e6080e7          	jalr	486(ra) # 80200cc8 <consputc>
			for (; *s; s++)
    80202aea:	0485                	addi	s1,s1,1
    80202aec:	0004c503          	lbu	a0,0(s1)
    80202af0:	f96d                	bnez	a0,80202ae2 <printf+0x178>
    80202af2:	b705                	j	80202a12 <printf+0xa8>
				s = "(null)";
    80202af4:	00002497          	auipc	s1,0x2
    80202af8:	c6c48493          	addi	s1,s1,-916 # 80204760 <e_text+0x760>
			for (; *s; s++)
    80202afc:	856e                	mv	a0,s11
    80202afe:	b7d5                	j	80202ae2 <printf+0x178>
			break;
		case '%':
			consputc('%');
    80202b00:	8556                	mv	a0,s5
    80202b02:	ffffe097          	auipc	ra,0xffffe
    80202b06:	1c6080e7          	jalr	454(ra) # 80200cc8 <consputc>
			break;
    80202b0a:	b721                	j	80202a12 <printf+0xa8>
		default:
			// Print unknown % sequence to draw attention.
			consputc('%');
    80202b0c:	8556                	mv	a0,s5
    80202b0e:	ffffe097          	auipc	ra,0xffffe
    80202b12:	1ba080e7          	jalr	442(ra) # 80200cc8 <consputc>
			consputc(c);
    80202b16:	8526                	mv	a0,s1
    80202b18:	ffffe097          	auipc	ra,0xffffe
    80202b1c:	1b0080e7          	jalr	432(ra) # 80200cc8 <consputc>
			break;
    80202b20:	bdcd                	j	80202a12 <printf+0xa8>
		}
	}
    80202b22:	70e6                	ld	ra,120(sp)
    80202b24:	7446                	ld	s0,112(sp)
    80202b26:	74a6                	ld	s1,104(sp)
    80202b28:	7906                	ld	s2,96(sp)
    80202b2a:	69e6                	ld	s3,88(sp)
    80202b2c:	6a46                	ld	s4,80(sp)
    80202b2e:	6aa6                	ld	s5,72(sp)
    80202b30:	6b06                	ld	s6,64(sp)
    80202b32:	7be2                	ld	s7,56(sp)
    80202b34:	7c42                	ld	s8,48(sp)
    80202b36:	7ca2                	ld	s9,40(sp)
    80202b38:	7d02                	ld	s10,32(sp)
    80202b3a:	6de2                	ld	s11,24(sp)
    80202b3c:	6129                	addi	sp,sp,192
    80202b3e:	8082                	ret

0000000080202b40 <get_cycle>:
#include "riscv.h"
#include "sbi.h"

/// read the `mtime` regiser
uint64 get_cycle()
{
    80202b40:	1141                	addi	sp,sp,-16
    80202b42:	e422                	sd	s0,8(sp)
    80202b44:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, time" : "=r"(x));
    80202b46:	c0102573          	rdtime	a0
	return r_time();
}
    80202b4a:	6422                	ld	s0,8(sp)
    80202b4c:	0141                	addi	sp,sp,16
    80202b4e:	8082                	ret

0000000080202b50 <set_next_timer>:
	set_next_timer();
}

/// Set the next timer interrupt
void set_next_timer()
{
    80202b50:	1141                	addi	sp,sp,-16
    80202b52:	e406                	sd	ra,8(sp)
    80202b54:	e022                	sd	s0,0(sp)
    80202b56:	0800                	addi	s0,sp,16
    80202b58:	c0102573          	rdtime	a0
	const uint64 timebase = CPU_FREQ / TICKS_PER_SEC;
	set_timer(get_cycle() + timebase);
    80202b5c:	67fd                	lui	a5,0x1f
    80202b5e:	84878793          	addi	a5,a5,-1976 # 1e848 <_entry-0x801e17b8>
    80202b62:	953e                	add	a0,a0,a5
    80202b64:	fffff097          	auipc	ra,0xfffff
    80202b68:	66c080e7          	jalr	1644(ra) # 802021d0 <set_timer>
    80202b6c:	60a2                	ld	ra,8(sp)
    80202b6e:	6402                	ld	s0,0(sp)
    80202b70:	0141                	addi	sp,sp,16
    80202b72:	8082                	ret

0000000080202b74 <timer_init>:
{
    80202b74:	1141                	addi	sp,sp,-16
    80202b76:	e406                	sd	ra,8(sp)
    80202b78:	e022                	sd	s0,0(sp)
    80202b7a:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sie" : "=r"(x));
    80202b7c:	104027f3          	csrr	a5,sie
	w_sie(r_sie() | SIE_STIE);
    80202b80:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sie, %0" : : "r"(x));
    80202b84:	10479073          	csrw	sie,a5
	set_next_timer();
    80202b88:	00000097          	auipc	ra,0x0
    80202b8c:	fc8080e7          	jalr	-56(ra) # 80202b50 <set_next_timer>
}
    80202b90:	60a2                	ld	ra,8(sp)
    80202b92:	6402                	ld	s0,0(sp)
    80202b94:	0141                	addi	sp,sp,16
    80202b96:	8082                	ret

0000000080202b98 <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    80202b98:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80202b9c:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80202ba0:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80202ba2:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80202ba4:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80202ba8:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80202bac:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80202bb0:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80202bb4:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80202bb8:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80202bbc:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80202bc0:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80202bc4:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80202bc8:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80202bcc:	0005b083          	ld	ra,0(a1) # 2000000 <_entry-0x7e200000>
        ld sp, 8(a1)
    80202bd0:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80202bd4:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80202bd6:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80202bd8:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80202bdc:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80202be0:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80202be4:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80202be8:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80202bec:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80202bf0:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80202bf4:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80202bf8:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80202bfc:	0685bd83          	ld	s11,104(a1)

    80202c00:	8082                	ret
	...

0000000080203000 <trampoline>:
        # mapped into user space, at TRAPFRAME.
        #

	# swap a0 and sscratch
        # so that a0 is TRAPFRAME
        csrrw a0, sscratch, a0
    80203000:	14051573          	csrrw	a0,sscratch,a0

        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
    80203004:	02153423          	sd	ra,40(a0)
        sd sp, 48(a0)
    80203008:	02253823          	sd	sp,48(a0)
        sd gp, 56(a0)
    8020300c:	02353c23          	sd	gp,56(a0)
        sd tp, 64(a0)
    80203010:	04453023          	sd	tp,64(a0)
        sd t0, 72(a0)
    80203014:	04553423          	sd	t0,72(a0)
        sd t1, 80(a0)
    80203018:	04653823          	sd	t1,80(a0)
        sd t2, 88(a0)
    8020301c:	04753c23          	sd	t2,88(a0)
        sd s0, 96(a0)
    80203020:	f120                	sd	s0,96(a0)
        sd s1, 104(a0)
    80203022:	f524                	sd	s1,104(a0)
        sd a1, 120(a0)
    80203024:	fd2c                	sd	a1,120(a0)
        sd a2, 128(a0)
    80203026:	e150                	sd	a2,128(a0)
        sd a3, 136(a0)
    80203028:	e554                	sd	a3,136(a0)
        sd a4, 144(a0)
    8020302a:	e958                	sd	a4,144(a0)
        sd a5, 152(a0)
    8020302c:	ed5c                	sd	a5,152(a0)
        sd a6, 160(a0)
    8020302e:	0b053023          	sd	a6,160(a0)
        sd a7, 168(a0)
    80203032:	0b153423          	sd	a7,168(a0)
        sd s2, 176(a0)
    80203036:	0b253823          	sd	s2,176(a0)
        sd s3, 184(a0)
    8020303a:	0b353c23          	sd	s3,184(a0)
        sd s4, 192(a0)
    8020303e:	0d453023          	sd	s4,192(a0)
        sd s5, 200(a0)
    80203042:	0d553423          	sd	s5,200(a0)
        sd s6, 208(a0)
    80203046:	0d653823          	sd	s6,208(a0)
        sd s7, 216(a0)
    8020304a:	0d753c23          	sd	s7,216(a0)
        sd s8, 224(a0)
    8020304e:	0f853023          	sd	s8,224(a0)
        sd s9, 232(a0)
    80203052:	0f953423          	sd	s9,232(a0)
        sd s10, 240(a0)
    80203056:	0fa53823          	sd	s10,240(a0)
        sd s11, 248(a0)
    8020305a:	0fb53c23          	sd	s11,248(a0)
        sd t3, 256(a0)
    8020305e:	11c53023          	sd	t3,256(a0)
        sd t4, 264(a0)
    80203062:	11d53423          	sd	t4,264(a0)
        sd t5, 272(a0)
    80203066:	11e53823          	sd	t5,272(a0)
        sd t6, 280(a0)
    8020306a:	11f53c23          	sd	t6,280(a0)

        csrr t0, sscratch
    8020306e:	140022f3          	csrr	t0,sscratch
        sd t0, 112(a0)
    80203072:	06553823          	sd	t0,112(a0)
        csrr t1, sepc
    80203076:	14102373          	csrr	t1,sepc
        sd t1, 24(a0)
    8020307a:	00653c23          	sd	t1,24(a0)
        ld sp, 8(a0)
    8020307e:	00853103          	ld	sp,8(a0)
        ld tp, 32(a0)
    80203082:	02053203          	ld	tp,32(a0)
        ld t0, 16(a0)
    80203086:	01053283          	ld	t0,16(a0)
        ld t1, 0(a0)
    8020308a:	00053303          	ld	t1,0(a0)
        csrw satp, t1
    8020308e:	18031073          	csrw	satp,t1
        sfence.vma zero, zero
    80203092:	12000073          	sfence.vma
        jr t0
    80203096:	8282                	jr	t0

0000000080203098 <userret>:
        # usertrapret() calls here.
        # a0: TRAPFRAME, in user page table.
        # a1: user page table, for satp.

        # switch to the user page table.
        csrw satp, a1
    80203098:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    8020309c:	12000073          	sfence.vma

        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld t0, 112(a0)
    802030a0:	07053283          	ld	t0,112(a0)
        csrw sscratch, t0
    802030a4:	14029073          	csrw	sscratch,t0

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    802030a8:	02853083          	ld	ra,40(a0)
        ld sp, 48(a0)
    802030ac:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    802030b0:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    802030b4:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    802030b8:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    802030bc:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    802030c0:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    802030c4:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    802030c6:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    802030c8:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    802030ca:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    802030cc:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    802030ce:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    802030d0:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    802030d2:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    802030d6:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    802030da:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    802030de:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    802030e2:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    802030e6:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    802030ea:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    802030ee:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    802030f2:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    802030f6:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    802030fa:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    802030fe:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    80203102:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    80203106:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    8020310a:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    8020310e:	11853f83          	ld	t6,280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0
    80203112:	14051573          	csrrw	a0,sscratch,a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
    80203116:	10200073          	sret
	...
