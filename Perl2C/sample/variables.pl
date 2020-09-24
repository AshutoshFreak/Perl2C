#!/usr/bin/perl  
# use Data::Dumper; -> Doesn't recognize :: , might add later 
  

=Correct way to declare varialbes in perl
$my-name = "John"; # Invalid 
$my name = "John"; # Invalid
$my_name = "John"; # Valid
=cut


# Scalar Variable 
$name = "GeeksForGeeks"; 
  
# Array Variable 
@array = ("G", "E", "E", "K", "S"); 

# Hash Variable 
%Hash = ('Welcome', 10, 'to', 20, 'Geeks', 40); 
  
# Variable Modification 
@array[2] = "F"; 

print "Modified Array is @array\n"; 
  
# Interpolation of a Variable 
  
# Using Single Quote 
print 'Name is $name\n'; 
  
# Using Double Quotes 
print "\nName is $name"; 
  
# Printing hash contents 
# print Dumper(\%Hash); -> Doesn't recognize '\' , might add later
