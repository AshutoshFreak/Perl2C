# Perl program to illustrate 
# nested while Loop 
  
$a = 5; 
$b = 0; 
  
# outer while loop 
while ($a < 7)  
{ 
   $b = 0; 
     
   # inner while loop 
   while ( $b <7 )  
   { 
      print("value of a = $a, b = $b\n"); 
      $b = $b + 1; 
   } 
     
   $a = $a + 1; 
   print("Value of a = $a\n\n"); 
} 
