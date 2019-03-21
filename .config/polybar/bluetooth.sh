#!/bin/sh

if [ "$(systemctl is-active bluetooth.service)" = "active" ]; then
	echo " on"
else
	echo " off"
fi

