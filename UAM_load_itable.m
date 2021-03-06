% UAM_load_itable
% script to allow loading of pre-defined table

itable = [...
    1 1 1 1;...  % Case   1
    1 1 1 2;...  % Case   2
    1 1 1 3;...  % Case   3
    1 1 1 4;...  % Case   4
    1 1 1 5;...  % Case   5
    1 1 2 1;...  % Case   6
    1 1 2 2;...  % Case   7
    1 1 2 3;...  % Case   8
    1 1 2 4;...  % Case   9
    1 1 2 5;...  % Case  10
    1 1 3 1;...  % Case  11
    1 1 3 2;...  % Case  12
    1 1 3 3;...  % Case  13
    1 1 3 4;...  % Case  14
    1 1 3 5;...  % Case  15
    1 1 4 1;...  % Case  16
    1 1 4 2;...  % Case  17
    1 1 4 3;...  % Case  18
    1 1 4 4;...  % Case  19
    1 1 4 5;...  % Case  20
    1 1 5 1;...  % Case  21
    1 1 5 2;...  % Case  22
    1 1 5 3;...  % Case  23
    1 1 5 4;...  % Case  24
    1 1 5 5;...  % Case  25
    1 2 1 3;...  % Case  26
    1 2 1 4;...  % Case  27
    1 2 1 5;...  % Case  28
    1 2 2 3;...  % Case  29
    1 2 2 4;...  % Case  30
    1 2 2 5;...  % Case  31
    1 2 3 3;...  % Case  32
    1 2 3 4;...  % Case  33
    1 2 3 5;...  % Case  34
    1 2 4 5;...  % Case  35
    1 2 5 5;...  % Case  36
    1 3 1 3;...  % Case  37
    1 3 1 4;...  % Case  38
    1 3 1 5;...  % Case  39
    1 3 2 3;...  % Case  40
    1 3 2 4;...  % Case  41
    1 3 2 5;...  % Case  42
    1 3 3 3;...  % Case  43
    1 3 3 4;...  % Case  44
    1 3 3 5;...  % Case  45
    1 3 4 5;...  % Case  46
    1 3 5 5;...  % Case  47
    1 4 1 5;...  % Case  48
    1 4 2 5;...  % Case  49
    1 4 3 5;...  % Case  50
    1 4 4 5;...  % Case  51
    1 4 5 5;...  % Case  52
    1 5 1 5;...  % Case  53
    1 5 2 5;...  % Case  54
    1 5 3 5;...  % Case  55
    1 5 4 5;...  % Case  56
    1 5 5 5;...  % Case  57
    2 1 3 1;...  % Case  58
    2 1 3 2;...  % Case  59
    2 1 3 3;...  % Case  60
    2 1 4 1;...  % Case  61
    2 1 4 2;...  % Case  62
    2 1 4 3;...  % Case  63
    2 1 5 1;...  % Case  64
    2 1 5 2;...  % Case  65
    2 1 5 3;...  % Case  66
    2 1 5 4;...  % Case  67
    2 1 5 5;...  % Case  68
    2 2 3 3;...  % Case  69
    2 2 4 4;...  % Case  70
    2 2 5 5;...  % Case  71
    2 3 3 3;...  % Case  72
    2 3 3 4;...  % Case  73
    2 3 3 5;...  % Case  74
    2 3 4 5;...  % Case  75
    2 3 5 5;...  % Case  76
    2 4 3 5;...  % Case  77
    2 4 4 5;...  % Case  78
    2 4 5 5;...  % Case  79
    2 5 3 5;...  % Case  80
    2 5 4 5;...  % Case  81
    2 5 5 5;...  % Case  82
    3 1 3 1;...  % Case  83
    3 1 3 2;...  % Case  84
    3 1 3 3;...  % Case  85
    3 1 4 1;...  % Case  86
    3 1 4 2;...  % Case  87
    3 1 4 3;...  % Case  88
    3 1 5 1;...  % Case  89
    3 1 5 2;...  % Case  90
    3 1 5 3;...  % Case  91
    3 2 3 3;...  % Case  92
    3 2 4 3;...  % Case  93
    3 2 5 3;...  % Case  94
    3 2 5 4;...  % Case  95
    3 2 5 5;...  % Case  96
    3 3 3 3;...  % Case  97
    3 3 3 4;...  % Case  98
    3 3 3 5;...  % Case  99
    3 3 4 3;...  % Case 100
    3 3 4 4;...  % Case 101
    3 3 4 5;...  % Case 102
    3 3 5 3;...  % Case 103
    3 3 5 4;...  % Case 104
    3 3 5 5;...  % Case 105
    3 4 3 5;...  % Case 106
    3 4 4 5;...  % Case 107
    3 4 5 5;...  % Case 108
    3 5 3 5;...  % Case 109
    3 5 4 5;...  % Case 110
    3 5 5 5;...  % Case 111
    4 1 5 1;...  % Case 112
    4 1 5 2;...  % Case 113
    4 1 5 3;...  % Case 114
    4 1 5 4;...  % Case 115
    4 1 5 5;...  % Case 116
    4 2 5 3;...  % Case 117
    4 2 5 4;...  % Case 118
    4 2 5 5;...  % Case 119
    4 3 5 3;...  % Case 120
    4 3 5 4;...  % Case 121
    4 3 5 5;...  % Case 122
    4 4 5 5;...  % Case 123
    4 5 5 5;...  % Case 124
    5 1 5 1;...  % Case 125
    5 1 5 2;...  % Case 126
    5 1 5 3;...  % Case 127
    5 1 5 4;...  % Case 128
    5 1 5 5;...  % Case 129
    5 2 5 3;...  % Case 130
    5 2 5 4;...  % Case 131
    5 2 5 5;...  % Case 132
    5 3 5 3;...  % Case 133
    5 3 5 4;...  % Case 134
    5 3 5 5;...  % Case 135
    5 4 5 5;...  % Case 136
    5 5 5 5];  % Case 137
