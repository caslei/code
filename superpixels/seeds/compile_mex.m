mex -O -I/usr/include/opencv -lcxcore -lcv -lhighgui -c seeds2.cpp

mex -O mexSEEDS.cpp -I/usr/include/opencv -lcxcore -lcv -lhighgui seeds2.o
