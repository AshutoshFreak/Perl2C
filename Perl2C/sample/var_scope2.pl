# Perl program to illustrate the  
# Scope of Global variables 
#   https://www.geeksforgeeks.org/perl-scope-of-variables/
# declaration of global variables 
$name = "GFG";  
$count = 1; 
  
# printing global variables 
print $count." ".$name."\n"; 
$count++; 
  
# Block starting 
{ 
      
    # global variable can be used inside 
    # a block, so below statement will  
    # print GFG and 1 
    print $count." ".$name."\n"; 
      
    # incrementing the value of  
    # count inside the block 
    $count++; 
} 
  
# taking a function 
sub func { 
      
    # Global variable, $count and $name, 
    # are accessible within function 
    print $count." ".$name."\n"; 
} 
  
# calling the function 
func(); 
