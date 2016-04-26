#!/bin/sh
MODEL=$(cat /proc/cpuinfo | grep ^Hardware | awk -F " " '{print $3}')
SYSFS_GPIO_DIR="/sys/class/gpio"

retval=""

gpio_export()
{
        [ -e "$SYSFS_GPIO_DIR/gpio$1" ] && return 0
        echo $1 > "$SYSFS_GPIO_DIR/export"
}

gpio_getvalue()
{
    echo in > "$SYSFS_GPIO_DIR/gpio$1/direction"
        val=`cat "$SYSFS_GPIO_DIR/gpio$1/value"`
        retval=$val
}

gpio_setvalue()
{
    echo out > "$SYSFS_GPIO_DIR/gpio$1/direction"
        echo $2 > "$SYSFS_GPIO_DIR/gpio$1/value"
}

if test $MODEL = "ODROIDC"
then
        AC_OK_GPIO=88
        BAT_OK_GPIO=116
	LATCH_GPIO=115
	gpio_export $LATCH_GPIO 
	gpio_setvalue $LATCH_GPIO 1
elif test $MODEL = "ODROID-C2"
then
        AC_OK_GPIO=247
        BAT_OK_GPIO=239
	LATCH_GPIO=225
	gpio_export $LATCH_GPIO 
	gpio_setvalue $LATCH_GPIO 1
else 
        AC_OK_GPIO=199
        BAT_OK_GPIO=200
fi

gpio_export $AC_OK_GPIO
gpio_export $BAT_OK_GPIO
gpio_getvalue $AC_OK_GPIO
