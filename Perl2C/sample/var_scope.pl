# Perl program to illustrate the  
# Scope of Global variables 
# https://www.geeksforgeeks.org/perl-scope-of-variables/
# declaration of global variable  
$name = "GFG"; 
  
# printing global variable  
print "$name\n";     
  
# global variable can be used  
# inside a block, hence the we  
# are taking a block in which 
# we will print the value of  
# $name i.e. global variable 
{ 
  
    # here GFG will print 
    print "$name\n";  
      
    # values in global variable can be 
    # changed even within a block,  
    # hence the value of $name is  
    # now changed to "GeeksforGeeks" 
    $name = "GeeksforGeeks";  
      
    # print function prints 
    # "GeeksforGeeks" 
    print "$name\n";  
} 
  
# changes made inside the above block' 
# are reflected in the whole program  
# so here GeeksforGeeks will print 
print "$name\n";  
