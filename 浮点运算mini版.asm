.data 
	op:		.word		0	#������
	#�������������� ��һ���ִ��������ֵڶ����ִ�С������
	num1:  	.word    	0     	#��һ�������� 0~31 ����Ǹ�������Ϊǰ��λΪ����������λΪС�����ַ�Χ�� 00.000~11.111(0~3.875)	���Ϊ�������͵�һ���ֽڴ�����+С�����ڶ����ֽڴ�С����������
	num2:	.word 	0	#�ڶ���������

	#result��ʱδʹ�� �������S1����
	result:	.word	0	#��� 0~961��31*31�����Ϊ��������Ϊ  0~(123.453125) led 10 ~ 0�������̶ֹ���ʾ4λ��С��������ʾ6λ 
	#���ս�����s1���������������s2��s3 ������Ĭ�ϴ��С
.text
start:
	lui     $t1,0xffff					         
	ori     $s0,$t1,0xF000	#$s0�˿���ϵͳ��I/O��ַ�ĸ�20λ       0xfffff000
	sw     	$0,0xC60($s0)       #��Led ����
	addi	$s1,$0,0
#���ض�ȡ������
swItOp:
    lw     	$t1,0xC70($s0)   	#��ȡ���뿪�ص���ֵ t1

	andi   	$t2,$t1,0xe000     	#��ò��뿪����ֵ�ģ�15~13�� ��ʾ������
	srl    	$t2,$t2,13  
    sw    	$t2,op($0)

	srl 	$t2,$t2,2       		#���ƶ���λ�õ�����ߵ�һλ  ��ʾ�Ƿ�Ϊ����������
	addi  	$t3,$0,1
	beq 	$t2,$t3,floatInput	#���t2 = 1 ������ߵĿ���Ϊ1����Ϊ������
#�����Ķ�������
intInput:
	lw     $t1,0xC70($s0)   	#��ȡ���뿪�ص���ֵ t1
	
	andi   $t2,$t1,0x001f     	#��ò��뿪����ֵ�ĵ�5λ��0~4�� ��ʾ��һ��������  5������   
    sw     $t2,num1($0) 


	andi   	$t2,$t1,0x07c0     	#��ò��뿪����ֵ�ģ�6~10�� ��ʾ�ڶ���������	5������
	srl    	$t2,$t2,6  
     sw     $t2,num2($0)
	j		choseOP			#��ת������ָ����
#�������Ķ�������
floatInput:				#����������������벻̫һ����������Ҫ�����������������ֺ�С�����ַֿ�
	lw     	$t1,0xC70($s0)   	#��ȡ���뿪�ص���ֵ t1
	andi 	$s7,$t1,0x8000		#�������ڴ浽led�����λ ��ʾ�Ǹ������㣡��
#-----------------------------------------------------------------------------------------------
	andi   	$t2,$t1,0x001f     	#��ò��뿪����ֵ�ĵ�5λ��4~0�� ��ʾ��һ�������� 
    sw     	$t2,num1($0)           	#num1 ��һ���ִ�����+С��

	andi   	$t2,$t1,0x0018    	#��ò��뿪����ֵ��2λ��4~3�� ��ʾ��һ��������������
	srl	 	$t2,$t2,3
	addi	$t3,$0,4
	sw     	$t2,num1($t3)        #�������ִ浽num1�еĵڶ�����

	andi   	$t2,$t1,0x0007     	#��ò��뿪����ֵ��3λ��2~0�� ��ʾ��һ����������С������
	addi	$t3,$0,8
	sw     	$t2,num1($t3)        #С�����ִ浽num1�еĵ������� 
	
#---------------------------------------------------------------------------------------------------
	andi   $t2,$t1,0x07c0     	#��ò��뿪����ֵ��(10~6) ��ʾ�ڶ���������	
	srl    $t2,$t2,6  
   	sw     $t2,num2($0)		#num2 ��һ���ִ�����+С��


	andi	$t2,$t1,0x0600     	#��ò��뿪����ֵ�ģ�10~9�� ��ʾ�ڶ�������������������
	srl 	$t2,$t2,9 
	addi	$t3,$0,4		#�������ִ浽num2�еĵڶ�����
    sw     	$t2,num2($t3)

	andi   	$t2,$t1,0x01c0     	#��ò��뿪����ֵ�ģ�8~6�� ��ʾ�ڶ�����������С������
	srl    	$t2,$t2,6
	addi	$t3,$0,8		#С�����ִ浽num2�еĵ�������
    sw 		$t2,num2($t3)
#----------------------------------------------------------------------------------------------------
	j	choseOP
choseOP:
	lw		$t1,op($0) 		#ȡ��������
	
	beq   	$t1,$0,intAdd 		#�����ӷ�

	addi	$t2,$0,1
	beq   	$t1,$t2,intSub		#��������
	
	addi	$t2,$0,2
	beq    	$t1,$t2,intMulInit	#�����˷�

	addi	$t2,$0,3
	beq    	$t1,$t2,intDivInit		#��������

	addi	$t2,$0,4
	beq    	$t1,$t2,floatAdd		#�������ӷ�

	addi	$t2,$0,5
	beq    	$t1,$t2,floatSub		#����������

	addi	$t2,$0,6
	beq    	$t1,$t2,floatMul		#�������˷�

	addi	$t2,$0,7
	beq  	$t1,$t2,floatDiv		#����������
##############################################################################################################################

intAdd:			#�����ӷ�
	lw		$t1, num1($0)
	lw		$t2, num2($0)
	add 	$s1, $t1, $t2
	j  		resultSave

intSub:			#��������
	lw		$t1, num1($0)
	lw		$t2, num2($0)
	slt		$t3, $t1, $t2   		#���num1 < num2��$t3��Ϊ1
	addi  	$t4, $0, 1				#$t4��Ϊ1����������ж�
	beq		$t4, $t3, intSub21		#���$t3 == 1������ת��in	tSub21
	sub  	$s1, $t1, $t2
	j 		resultSave

intSub21:		#�������ͼ������������
	lw		$t1, num1($0)
	lw		$t2, num2($0)
	sub  	$s1, $t2, $t1
	j 		resultSave

intMulInit:			#�����˷�

	lw		$t1, num2($0) 
	add 	$s2, $0, $t1       		#��num2��ֵ��ֵ��s2
	add 	$s1, $0, $0				#�������ʼ��Ϊ0

	beq 	$s2, $0, resultSave 	#�жϳ����Ƿ�Ϊ0��������ת��������0�������ִ�к���ĳ˷�����

intMult:
	lw		$t1, num1($0)			#ȡ����һ����
	lw		$t2, num2($0)			#ȡ���ڶ�����
	addi 	$t3, $0, 1				#��$t3��Ϊ1����������ж�
	add 	$s1, $s1, $t1     	 	#�����ۼӲ���
	sub 	$s2, $s2, $t3 			#��������һ
	bne		$0, $s2, intMult  		#�жϳ����Ƿ�0�������ٴ�ִ��intMult�������������
	j 		resultSave


intDivInit:			#��������
	add  	$s1, $0, $0				#��ʼ��$s1Ϊ0
	lw 		$t1, num1($0)			#ȡ����һ����
	lw		$t2, num2($0)			#ȡ���ڶ�����
	slt		$t3, $t1, $t2 			#�жϱ������Ƿ�С�ڳ�����������Ϊ1������Ϊ0
	addi	$t4, $0, 1				#��$t4��Ϊ1����������ж�
	beq		$t3, $t4, resultSave 	#���������С�ڳ�������ֱ��������
	beq 	$t2, $0, resultSave  	#�������Ϊ0����ֱ��������

intDiv:
	sub 	$t1, $t1, $t2 			#�����ۼ�����
	addi 	$s1, $s1, 1 			#ÿ��һ��������һ
	slt 	$t3, $t1, $t2  			#�жϱ������Ƿ�С�ڳ�����������Ϊ1������Ϊ0
	addi 	$t4, $0, 1
	beq		$t3, $t4, resultSave 	#���������С�ڳ�������ֱ��������
	j 		intDiv


##############################################################################################################################
floatAdd:			#�������ӷ�
	#led ��Ҫ�õ�10λ��4λ�������֣�6λС������
	#0x03c0Ϊ�������� �� 0x003fΪС������
	addi	$t1,$0,0	
	lw		$t2,num1($t1)	#t2��num1������+С������
	lw		$t3,num2($t1)	#t3��num2������С������
	add		$s2, $t2,$t3	# $s2 =$t2+ $t3  ���� 01010 + 00101 = 01111 ��ʾ 01.010 + 00.101 = 01.111


	sll		$s2,$s2,3	#������λ ��������С���ŵ���Ӧ��λ����  ����0000  С��000000

	add    $s1, $s2,$0		#s1���ڴ������Ĵ�0001 110000 ��ʾ1.11
	j		floatResultSave		# jump to floatResultSave
########################################################################################################################################
floatSub:			#����������
	lw	 	$t1, num1($0)		# ȡ����һ����
	lw	 	$t2, num2($0)		# ȡ���ڶ�����
	slt     $t3, $t1, $t2		# �����һ�����ȵڶ�����С
	addi 	$t4,$0,1	
	beq		$t3,$t4,sub2s1  	#�����һ�����ȵڶ�����С�ͽ���ڶ���������һ����
	j		sub1s2
sub1s2:
	lw		$t2,num1($0)	#t2��num1������+С������
	lw		$t3,num2($0)	#t3��num2������С������
	sub		$s1, $t2, $t3		#num1 - num2
	sll		$s1,$s1,3
	j		floatResultSave		# jump to floatResultSave
sub2s1:
	lw		$t2,num2($0)	#t2��num2������+С������
	lw		$t3,num1($0)	#t3��num1������С������
	sub		$s1, $t2, $t3		#num2 - num1
	sll		$s1,$s1,3
	j		floatResultSave		# jump to floatResultSave
#######################################################################################################################################
floatMul:			#�������˷� ͨ���ҳ���������С��λ����xλС����yλС�� ���ӦΪx+yλС����x+y < 6��Ȼ������6-(x+y)λ
	addi	$t1,$0,0
	
	lw	 	$s2, num1($t1)		# ȡ����һ����������
	lw	 	$s3, num2($t1)		# ȡ���ڶ�����������

	beq 	$s3,$0,num2is0		#�ڶ���������0������£����ֱ��Ϊ0�� ����˼·�� x��y xΪ�ڶ�����������ڶ�����Ϊ0�����߼����ȼ�1���ͱ�Ϊ-1�����

	addi	$t1,$0,8
	lw	 	$s4, num1($t1)		# ȡ����һ������С������ 
	lw	 	$s5, num2($t1)		# ȡ���ڶ�������С����


decimalNumber1:			#�ҳ�num1��С�����м�λ
	addi 	$t1,$0,0x1			#С��������λ
	and		$t4,$s4,$t1			#�ж�С�����ֵ���λ��û��1 ����оʹ���С����3λ
	addi	$t5,$0,1
	beq		$t5,$t4,num1have3	#���t4=1

	addi 	$t1,$0,0x2			#С�����ڶ�λ
	and		$t4,$s4,$t1			#�ж�С�����ֵڶ�λ��û��1 ����оʹ���С����2λ
	addi	$t5,$0,2
	beq		$t5,$t4,num1have2	#���t4=1

	addi 	$t1,$0,0x4			#С������һλ
	and		$t4,$s4,$t1			#�ж�С�����ֵ�һλ��û��1 ����оʹ���С����1λ
	addi	$t5,$0,4
	beq		$t5,$t4,num1have1	#���t4=1

num1have3:
	addi    $s4, $0,3
	j		decimalNumber2
num1have2:
	addi    $s4, $0,2
	j		decimalNumber2
num1have1:
	addi    $s4, $0,1
	j		decimalNumber2

decimalNumber2:			#�ҳ�num2��С�����м�λ
	addi 	$t1,$0,0x1			#С��������λ
	and		$t4,$s5,$t1			#�ж�С�����ֵ���λ��û��1 ����оʹ���С����3λ
	addi	$t5,$0,1
	beq		$t5,$t4,num2have3	#���t4=1

	addi 	$t1,$0,0x2			#С�����ڶ�λ
	and		$t4,$s5,$t1			#�ж�С�����ֵڶ�λ��û��1 ����оʹ���С����2λ
	addi	$t5,$0,1
	beq		$t5,$t4,num2have2	#���t4=1

	addi 	$t1,$0,0x4			#С������һλ
	and		$t4,$s5,$t1			#�ж�С�����ֵ�һλ��û��1 ����оʹ���С����1λ
	addi	$t5,$0,1
	beq		$t5,$t4,num2have1	#���t4=1

num2have3:
	addi    $s5, $0,3
	j		fMulfunction
num2have2:
	addi    $s5, $0,2
	j		fMulfunction
num2have1:
	addi    $s5, $0,1
	j		fMulfunction

fMulfunction:	#��������Ĵ���s4�д��num1��С�����λ�� s5�д��num2С�����λ�� ����С����λ����Ϊ�����ĺ�
#3*5 ���� 3+3+3+3+3
	add		$s1,$s1,$s2			#s1 = s1 + s2 s2Ϊ��һ����������
	addi	$s3,$s3,-1
	bne     $s3,$0,fMulfunction #s3��s2��� ֻ��s3 == 0���˳�ѭ��

	add		$t1,$s4,$s5		#t1 ����ĳ˷������С��������λ��
	addi	$t2,$0, 6		
	sub     $t1, $t2, $t1	#t1  =  6 - t1 �����Ƶ�λ��

	sllv    $s1, $s1, $t1	#s1 ����t1 λ
	j		floatResultSave	# jump to floatResultSave
	
num2is0:
	addi	$s1,$0,0		#���ֱ��Ϊ0
	j		floatResultSave	# jump to floatResultSave
###############################################################################################################################################
floatDiv:			#����������
	# ˼·Ϊ��
	# ������1��ȥ������2��ÿ��һ�̵��������ּ�һ��ֱ��num1��num2�󣬿�ʼ����num1������ʼ������ŵ��̵�С�����֣�
	# ��¼һ�������˼��Σ���ʾ��λС������С���ƶ�������6λ�󣬻���num1����0�ͽ�������������� 6 - s6λ
	# ��$s4��¼�� $s6��¼�ƶ��˼�λС��
	lw	 	$s2, num1($0)		# ȡ����һ����������   ȡ��������5λ��������
	lw	 	$s3, num2($0)		# ȡ���ڶ�����������
	beq		$s3,$0,num2is0		#!!!!����Ϊ0  ֱ���˳� ���Ϊ0
<<<<<<< HEAD:浮点运算minisys版.asm
	addi	$s4,$s0,0
	#addi	$s5,$s0,$0
	addi	$s6,$s0,0
=======
	addi	$s4,$0,0
	#addi	$s5,$s0,$0
	addi	$s6,$0,0
	j		divLoop
>>>>>>> yujie:浮点运算mini版.asm

divLoop:	#����ѭ��
	beq		$s2,$0,endDiv		#���s2 = 0 �����

	addi	$t2, $0, 1
	slt     $t1, $s2, $s3		#���s2 < s3 ��t1 = 1
	beq		$t1,$t2,sllS2	#���t1=1 s2<s3 ���������ֲ��ܼ� �Ϳ�ʼ���ƣ�����ʼ����С��
	#����� s2 - s3  �̵��������ּ�1
	sub		$s2,$s2,$s3
	addi	$s4,$s4,1
	
<<<<<<< HEAD:浮点运算minisys版.asm
	addi 	$t2,$0,6		#����Ѿ�����6λ ��ʾ�Ѿ���6λС�������������
	beq		$s6,$t2,endDiv
=======
	addi 	$t2,$0,5		#����Ѿ���������6λ����6��ͣ�� ��ʾ�Ѿ���6λС�������������
	addi	$t3,$0,1
	slt		$t1,$t2,$s6
	beq		$t1,$t3,endDiv
>>>>>>> yujie:浮点运算mini版.asm

	j		divLoop


sllS2:	#s2����һλ s6+1
	addi 	$t2,$0,6		#����Ѿ�����6λ ��ʾ�Ѿ���6λС�������������
	beq		$s6,$t2,endDiv

	sll 	$s2,$s2,1		
	sll		$s4,$s4,1		#��ҲҪ���� һλ
	addi	$s6,$s6,1		
	j		divLoop				# jump to divLoop2
	
	
endDiv:		#���ڴ����� ��s4 s5 �浽 s1
	addi	$t1,$0,6
	sub		$t2,$t1,$s6				#t2��ʾ���Ƶ�λ�� 6-x
<<<<<<< HEAD:浮点运算minisys版.asm
	sllv    $s1, $s4,$t2
=======
	sllv    $s4, $s4,$t2
	add		$s1,$0,$s4
>>>>>>> yujie:浮点运算mini版.asm
	j       floatResultSave
######################################################################################################################
resultSave:		#��������Led����
	sw		$s1,0xC60($s0)  
	j 		start			#����������¿�ʼ
floatResultSave:
	or		$t1,$s1,$s7 	#�ѽ���� ��ʾ���������flag �ŵ�һ�����ڴ������Ƿ�Ϊ��������
	sw		$t1,0xC60($s0)  
	j 		start			#����������¿�ʼ