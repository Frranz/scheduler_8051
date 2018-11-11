signal void txt (void) { 
int i; 
i=0; 
printf("OS 1 \n"); 
while (i<30) { 
  twatch(CLOCK); 
  if (Ri0==0) { 
    printf("%i \n",i); 
    if (i==0) s0in = 'x' ;
    if (i==1) s0in = 'a' ; 
    if (i==2) s0in = 'b' ;  
    if (i==3) s0in = 'x' ;  
    if (i==5) s0in = 'c' ;  
    if (i==6) s0in = 'a' ;  
    if (i==7) s0in = 'b' ;    
    if (i==9) s0in = 'a' ;  
    if (i==12) s0in = 'c' ;
    if (i==13) s0in = 'b' ;  
    if (i==14) s0in = 'b' ;  
    if (i==15) s0in = 'a' ; 
    if (i==17) s0in = 'c' ;
    if (i==18) s0in = 'c' ;  

    i++; 
    } 
  } 
  printf("fertig \n");
} 
 
SLOG > os1.dat
txt() 

