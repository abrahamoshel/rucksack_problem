rucksack_problem
================

Finding Solutions for the Rucksack/Knapsack Problem

Program will find every combination of items that meet the exact total given

####Before you start:
```
$ git clone git://github.com/abrahamoshel/rucksack_problem.git
$ cd rucksack_problem
$ bundle install
```

###Usage:

Given a file `diner_men.txt` containing:

```
$15.10
mixed fruit,$2.15
french fries,$1.75
onion rings,$1.75
side salad,$3.35
hot wings,$3.55
mozzarella sticks,$4.20
sampler plate,$5.80
condiment,$0.10
```

This script will try to find **any and evey** combination of menu items that will result in exact change for the first line.

#### step 1:
```
$script/my_menu
```

#### step 2
after prompt

```
Welcome to My Menu!
Please Enter a File Location or URL:
```

enter url or path to file

```
http://website.com/menu.txt
```
or

```
/User/<username>/path/to/file.txt
```

#### Wait for result:
For the request amount of $15.10
```
french fries
you can also replace it with one of these items:
["onion rings"]

,
french fries
you can also replace it with one of these items:
["onion rings"]

,
french fries
you can also replace it with one of these items:
["onion rings"]

,
french fries
you can also replace it with one of these items:
["onion rings"]

,
french fries
you can also replace it with one of these items:
["onion rings"]

,
french fries
you can also replace it with one of these items:
["onion rings"]

, condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment

 -----------------NEW SUGGESTION-----------------------

condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment, condiment, condiment, condiment,
condiment, condiment, condiment, condiment

***
Thanks for dinning with us please come again
***
```
