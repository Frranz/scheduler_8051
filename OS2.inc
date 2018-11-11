signal void txt (void) { 
int i; 
i=0; 
printf("OS 2 \n"); 
while (i<70) { 
  twatch(CLOCK); 
  if (Ri0==0) { 
    printf("%i \n",i); 
    if (i== 0) s0in = 'a' ;
    if (i== 1) s0in = 'z' ; 
    if (i==60) s0in = 'z' ;  
    if (i==61) s0in = 'a' ;
    if (i==62) s0in = 'z' ; 
    if (i==67) s0in = 'z' ;  
    if (i==68) s0in = 'a' ;
     i++; 
    } 
  } 
  printf("fertig \n");
} 
 
SLOG > os2.dat
txt() 

