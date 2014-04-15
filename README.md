Stata package for running max, min, and range
=============================================

Installing
----------

You can clone the Git repo with

    git clone https://github.com/jrfiedler/egen_runmax

Or you can download a zip archive by clicking on the "Download ZIP" button on the right side of this page.

Syntax
------

**egen** [_type_] _newvar_ = **runmax**(_varname_) [_if_] [_in_] [, _options_]

_options:_

1. **by**(_varlist_)

  - group by specified variables when finding values; the values will  be calculated separately in each group implied by _varlist_
        
2. **sort**(_varlist_)

  - sort on specified variables before finding values; the original sort order will be restored afterwards



Example usage
-------------

    . clear
          
    . input  x  y
    .       -2  .
    .        .  .
    .        4  0
    .        0  1
    .       -1  0
    .       -4  1
    .        7  0
    .        .  1
    .       -5  0
    .        3  1
    . end
    
    . egen maxx = runmax(x)
    (2 missing values generated)
    
    . list
    
         +---------------+
         |  x   y   maxx |
         |---------------|
      1. | -2   .     -2 |
      2. |  .   .      . |
      3. |  4   0      4 |
      4. |  0   1      4 |
      5. | -1   0      4 |
         |---------------|
      6. | -4   1      4 |
      7. |  7   0      7 |
      8. |  .   1      . |
      9. | -5   0      7 |
     10. |  3   1      7 |
         +---------------+
    
    . egen maxx_y = runmax(x) , by(y)
    (3 missing values generated)
    
    . list
    
         +------------------------+
         |  x   y   maxx   maxx_y |
         |------------------------|
      1. | -2   .     -2        . |
      2. |  .   .      .        . |
      3. |  4   0      4        4 |
      4. |  0   1      4        0 |
      5. | -1   0      4        4 |
         |------------------------|
      6. | -4   1      4        0 |
      7. |  7   0      7        7 |
      8. |  .   1      .        . |
      9. | -5   0      7        7 |
     10. |  3   1      7        3 |
         +------------------------+
    
    . list x y maxx_y if y == 0
    
         +-----------------+
         |  x   y   maxx_y |
         |-----------------|
      3. |  4   0        4 |
      5. | -1   0        4 |
      7. |  7   0        7 |
      9. | -5   0        7 |
         +-----------------+
    
    . list x y maxx_y if y == 1
    
         +-----------------+
         |  x   y   maxx_y |
         |-----------------|
      4. |  0   1        0 |
      6. | -4   1        0 |
      8. |  .   1        . |
     10. |  3   1        3 |
         +-----------------+

Author
-----
James Fiedler (jrfiedler at gmail dot com)