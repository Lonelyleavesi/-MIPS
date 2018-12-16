.data  
		#s0 端口是系统的I/O地址的高20位		  
		#s1 左边的灯 在低16位
		#s2 中存灯变换的频率
		#s3 中存0x7fff  循环次数？

		#s5 右边的灯  高16位
		#s6 s1和s5合并总共的灯
.text
start:
		lui      	$t1,0xffff					         
		ori  		$s0,$t1,0xF000	 #$s0端口是系统的I/O地址的高20位       0xfffff000                               #$s0,端口地址前20位
		addi     	$s4,$0,16      	 #用来储存灯移动的次数
ledinit:                                 
		sw   		$0,0xC60($s0)      #灯初始化，全灭
		j 		middle_num_8
##################################################################################################################################
middle_num_8:  #默认左右灯的数量为8个
		lui      	$t1,0x0000
		ori     	$s1,$t1,0xff00
		lui      	$t1,0x00ff
		ori     	$s5,$t1,0x0000 
              
               
middle_speed_set:    #设置灯亮的速度
		addi     	$s2,$0,50
		addi     	$s3,$0,0x7fff
                
middle_light:
		beq    	$s4,$0,start     #判断是否完成一次大循环  
		j     	 	middle_loop      #亮
           
middle_loop:                          
		srl   		$t1,$s1,16      #s1与t1 参考左移，左移后 又右移16位
		or    		$s6,$s5,$t1     #s6为左边的灯和右边的灯合并                
		addi   	$s3,$s3,-1      #分频，当s3循环0x7fff次中 灯亮

		sw   		$s6,0xc60($s0)	#把S6的状态置入到led灯中 亮！
		bne    	$s3,$0,middle_loop 

		addi     	$s2,$s2,-1		#s2 又循环50次 
		addi     	$s3,$0,0x7fff
		bne      	$s2,$0,middle_loop 

		addi    	$t3,$0,1
		 slti 		$t2,$s4,9		
		beq 		$t2,$t3,reverse    #如果移动了8次即全部灯都亮了就往反向亮

		j       	middle_move_1 	#每循环50*7fff次就移动一下

middle_move_1:  #一次移动1格  灯从两边向中间

		addi		$s4,$s4,-1     #移动次数加1
		sll   		$s1,$s1,1
		srl   		$s5,$s5,1
		j   		middle_speed_set
reverse:    
		addi		$s4,$s4,-1     #移动次数加1
		sll   		$s5,$s5,1
		srl   		$s1,$s1,1
		j   		middle_speed_set
