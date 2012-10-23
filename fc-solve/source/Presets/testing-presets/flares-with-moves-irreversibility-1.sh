freecell-solver-range-parallel-solve 1 32000 1 \
--flare-name 1 --method soft-dfs -to 0123456789 -opt \
-nf --flare-name 2 --method soft-dfs -to 0123467 -opt \
-nf --flare-name 3 --method random-dfs -seed 2 -to 0[01][23456789] -opt \
-nf --flare-name 4 --method random-dfs -seed 1 -to 0[0123456789] -opt \
-nf --flare-name 5 --method random-dfs -seed 3 -to 0[01][23467] -opt \
-nf --flare-name 9 --method random-dfs -seed 4 -to 0[0123467] -opt \
-nf --flare-name 10 --method random-dfs -to [01][23456789] -seed 8 -opt \
-nf --flare-name 11 --method a-star -asw 0.2,0.8,0,0,0 -opt \
-nf --flare-name 12 --method random-dfs -to [01][23456789] -seed 268 -opt \
-nf --flare-name 15 --method random-dfs -to [0123456789] -seed 142 -opt \
-nf --flare-name 16 --method a-star -asw 0.2,0.3,0.5,0,0 -opt \
-nf --flare-name 17 --method random-dfs -to [01][23456789] -seed 5 -opt \
-nf --flare-name 18 --method a-star -to 0123467 -asw 0.5,0,0.3,0,0 -opt \
-nf --flare-name 19 --method soft-dfs -to 0126394875 -opt \
-nf --flare-name 20 --method random-dfs -seed 105 -opt \
-nf --flare-name 21 --method a-star -asw 0.5,0,0.5,0,0 -opt \
-nf --flare-name 22 --method soft-dfs -to 013[2456789] -opt \
-nf --flare-name 23 --method soft-dfs -to 0123456789 -dto 19,0126394875 -opt \
-nf --flare-name 24 --method random-dfs -to 0123467 -dto 16,0[123467] -opt \
-nf --flare-name 25 --method random-dfs -seed 500 -to 0123456789 -dto 36,[01][23456789] -opt \
-nf --flare-name 26 --method a-star -asw 5,4,0,0,0 -opt \
-nf --flare-name 27 --method random-dfs -seed 37 -to [0123]456789 -dto 30,[342]0156789 -opt \
-nf --flare-name 28 --method a-star -to 01234675 -asw 40,2,40,0,40 -opt \
-nf --flare-name 29 --method a-star -to 01234675 -asw 300,1500,0,2,50000 -opt \
-nf --flare-name 30 --method a-star -to 0123467589 -asw 300,1500,0,2,60000 -opt \
-nf --flare-name 31 --method a-star -to 0123467589 -asw 300,1500,99,2,65000 -opt \
-nf --flare-name 33 --method a-star -to 0123467589 -asw 0,0,0,0,0,100 -sp r:tf -opt \
-nf --flare-name foo --method a-star -to 0123467589 -asw 370,0,0,2,90000 -opt \
 --flares-plan "Run:6246@1,Run:2663@2,Run:6799@3,Run:7161@4,Run:3466@5,Run:3594@9,Run:6896@10,Run:7269@11,Run:7194@12,Run:6462@15,Run:7742@16,Run:7029@17,Run:3769@18,Run:5244@19,Run:7149@20,Run:8848@21,Run:6282@22,Run:5020@23,Run:2128@24,Run:6833@25,Run:7290@26,Run:6619@27,Run:3797@28,Run:10000@29,Run:10000@30,Run:3184@31,Run:3000@foo,Run:10000@33"
