signal void txt (void) { 
int i; 
i=0; 
printf("OS 3 \n"); 
while (i<55) { 
  twatch(CLOCK); 
  if (Ri0==0) { 
    printf("%i \n",i); 
    if (i==0 ) s0in = 'z' ;
    if (i==10) s0in = 'b' ; 
    if (i==31) s0in = 'a' ;  
    if (i==32) s0in = 'z' ;  
    if (i==34) s0in = 'z' ;  
    if (i==38) s0in = 'a' ;  
    if (i==42) s0in = 'c' ;    
    if (i==49) s0in = 'z' ;  
    if (i==53) s0in = 'a' ;  
     i++; 
    } 
  } 
  printf("fertig \n");
} 
 
SLOG > os3.dat
txt() 

