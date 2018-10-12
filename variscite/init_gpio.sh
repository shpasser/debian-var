#!/bin/sh

PS_CLR=141
FAN_FAULTL=144
FAN_FAULTR=143

CHMB_PRSNT0=43
CHMB_PRSNT1=4
CHMB_PRSNT2=2
CHMB_PRSNT3=140
CHMB_PRSNT4=7
CHMB_PRSNT5=8
CHMB_PRSNT6=106
CHMB_PRSNT7=105

BLEN=149
BUZZER=148

BR_Trig=164
BR_GOOD_Read=161

PS_OnOff=158
PS_FAN_GOOD=160
PS_AC_GOOD=162
PS_DC_GOOD=159
PS_EN=146

# export GPIO pins
echo $PS_CLR > "/sys/class/gpio/export"
echo $FAN_FAULTL > "/sys/class/gpio/export"
echo $FAN_FAULTR > "/sys/class/gpio/export"
echo $CHMB_PRSNT0 > "/sys/class/gpio/export"
echo $CHMB_PRSNT1 > "/sys/class/gpio/export"
echo $CHMB_PRSNT2 > "/sys/class/gpio/export"
echo $CHMB_PRSNT3 > "/sys/class/gpio/export"
echo $CHMB_PRSNT4 > "/sys/class/gpio/export"
echo $CHMB_PRSNT5 > "/sys/class/gpio/export"
echo $CHMB_PRSNT6 > "/sys/class/gpio/export"
echo $CHMB_PRSNT7 > "/sys/class/gpio/export"
echo $BLEN > "/sys/class/gpio/export"
echo $BUZZER > "/sys/class/gpio/export"
echo $BR_Trig > "/sys/class/gpio/export"
echo $BR_GOOD_Read > "/sys/class/gpio/export"
echo $PS_OnOff > "/sys/class/gpio/export"
echo $PS_FAN_GOOD > "/sys/class/gpio/export"
echo $PS_AC_GOOD > "/sys/class/gpio/export"
echo $PS_DC_GOOD > "/sys/class/gpio/export"
echo $PS_EN > "/sys/class/gpio/export"

# configure the desired GPIO pins as output
echo "out" > "/sys/class/gpio/gpio${BLEN}/direction"
echo "out" > "/sys/class/gpio/gpio${BUZZER}/direction"
echo "out" > "/sys/class/gpio/gpio${BR_Trig}/direction"
echo "out" > "/sys/class/gpio/gpio${PS_EN}/direction"
echo 1 > "/sys/class/gpio/gpio${PS_EN}"
echo "out" > "/sys/class/gpio/gpio${PS_CLR}/direction"
echo 0 > "/sys/class/gpio/gpio${PS_EN}"
