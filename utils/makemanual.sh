#!/bin/bash

# Copyright (C) 2009 Derrick Moser <derrick_moser@yahoo.com>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the licence, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  You may also obtain a copy of the GNU General Public License
# from the Free Software Foundation by visiting their web site
# (http://www.fsf.org/) or by writing to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

# This program translates Diffuse's DocBook help into a manual page using the
# book2manual.xsl template.

if [ "$1" == "" ]; then
    echo "Usage: $0 <path_to_docbook_xsl_home>"
    echo "  eg. $0 /usr/share/sgml/docbook/stylesheet/xsl/nwalsh"
    echo "  eg. $0 /usr/share/sgml/docbook/xsl-stylesheets--1.73.2"
    exit 1
fi

xsltproc --nonet book2manual.xsl ../src/usr/share/gnome/help/diffuse/C/diffuse.xml | xsltproc --nonet "$1/manpages/docbook.xsl" -
sed -i '/^\.\\"/d' diffuse.1
