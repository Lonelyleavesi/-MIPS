.data  
		#s0 �˿���ϵͳ��I/O��ַ�ĸ�20λ		  
		#s1 ��ߵĵ� �ڵ�16λ
		#s2 �д�Ʊ任��Ƶ��
		#s3 �д�0x7fff  ѭ��������

		#s5 �ұߵĵ�  ��16λ
		#s6 s1��s5�ϲ��ܹ��ĵ�
.text
start:
		lui      	$t1,0xffff					         
		ori  		$s0,$t1,0xF000	 #$s0�˿���ϵͳ��I/O��ַ�ĸ�20λ       0xfffff000                               #$s0,�˿ڵ�ַǰ20λ
		addi     	$s4,$0,16      	 #����������ƶ��Ĵ���
ledinit:                                 
		sw   		$0,0xC60($s0)      #�Ƴ�ʼ����ȫ��
		j 		middle_num_8
##################################################################################################################################
middle_num_8:  #Ĭ�����ҵƵ�����Ϊ8��
		lui      	$t1,0x0000
		ori     	$s1,$t1,0xff00
		lui      	$t1,0x00ff
		ori     	$s5,$t1,0x0000 
              
               
middle_speed_set:    #���õ������ٶ�
		addi     	$s2,$0,50
		addi     	$s3,$0,0x7fff
                
middle_light:
		beq    	$s4,$0,start     #�ж��Ƿ����һ�δ�ѭ��  
		j     	 	middle_loop      #��
           
middle_loop:                          
		srl   		$t1,$s1,16      #s1��t1 �ο����ƣ����ƺ� ������16λ
		or    		$s6,$s5,$t1     #s6Ϊ��ߵĵƺ��ұߵĵƺϲ�                
		addi   	$s3,$s3,-1      #��Ƶ����s3ѭ��0x7fff���� ����

		sw   		$s6,0xc60($s0)	#��S6��״̬���뵽led���� ����
		bne    	$s3,$0,middle_loop 

		addi     	$s2,$s2,-1		#s2 ��ѭ��50�� 
		addi     	$s3,$0,0x7fff
		bne      	$s2,$0,middle_loop 

		addi    	$t3,$0,1
		 slti 		$t2,$s4,9		
		beq 		$t2,$t3,reverse    #����ƶ���8�μ�ȫ���ƶ����˾���������

		j       	middle_move_1 	#ÿѭ��50*7fff�ξ��ƶ�һ��

middle_move_1:  #һ���ƶ�1��  �ƴ��������м�

		addi		$s4,$s4,-1     #�ƶ�������1
		sll   		$s1,$s1,1
		srl   		$s5,$s5,1
		j   		middle_speed_set
reverse:    
		addi		$s4,$s4,-1     #�ƶ�������1
		sll   		$s5,$s5,1
		srl   		$s1,$s1,1
		j   		middle_speed_set
