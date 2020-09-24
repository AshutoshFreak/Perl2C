# Perl program to demonstrate 
# the m// and =~ operators 
# https://www.geeksforgeeks.org/perl-regular-expressions/
# Actual String 
$a = "GEEKSFORGEEKS"; 
  
# Prints match found if  
# its found in $a 
if ($a =~ m[GEEKS])  
{ 
    print "Match Found\n"; 
} 
  
# Prints match not found  
# if its not found in $a 
else 
{ 
    print "Match Not Found\n"; 
} 
