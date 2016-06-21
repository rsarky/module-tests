#!/bin/bash

i2c_addr=0x48

dir=$(dirname $0)
. ${dir}/common.sh

load_i2c_stub ${i2c_addr}

regs=(1301 1301 1301 1301 1301 1301 1301 1301
	4101 6901 6a01 6901 6901 6901 6901 6901
	0200 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0100 0100
	0200 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0100 0100
	0200 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0100 0100
	0000 0000 0000 0000 0000 0000 0000 0000
	0000 0000 0000 0000 0000 0000 0000 0000
	0200 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0200 0100
	0100 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0100 0100
	0200 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0100 0100
	6501 2401 1701 1401 1301 1301 1301 1301
	4201 6901 6901 6901 6901 6901 6901 6901
	0200 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0100 0100
	6701 2501 1901 1601 1501 1501 1501 1501
	4401 6c01 6c01 6c01 6c01 6c01 6c01 6c01
	0200 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0100 0100
	0200 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0100 0100
	0200 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0100 0100
	6701 2801 1b01 1701 1601 1501 1501 1501
	4401 6c01 6c01 6c01 6c01 6c01 6c01 6c01
	0200 0100 0100 0100 0100 0100 0100 0100
	0100 0100 0100 0100 0100 0100 0100 0100
)

i=0
while [ $i -lt ${#regs[*]} ]
do
	i2cset -f -y ${i2c_adapter} ${i2c_addr} $i 0x${regs[$i]} w
	i=$(($i + 1))
done

do_instantiate ads7828 ${i2c_addr}

getbasedir ${i2c_addr}

cd ${basedir}

attrs=(in0_input in1_input in2_input in3_input
	in4_input in5_input in6_input in7_input)

vals=(220 1 1 1 222 222 1 1)

dotest attrs[@] vals[@]
rv=$?

do_remove ${i2c_addr}

i=0
while [ $i -lt 256 ]
do
	i2cset -f -y ${i2c_adapter} ${i2c_addr} $i $i b
	i=$(($i + 1))
done

do_instantiate ads7830 ${i2c_addr}

cd ${basedir}

attrs=(in0_input in1_input in2_input in3_input
	in4_input in5_input in6_input in7_input)

vals=(1367 1992 1523 2149 1680 2305 1836 2461)

dotest attrs[@] vals[@]
rv=$(($? + ${rv}))

do_remove ${i2c_addr}

exit ${rv}