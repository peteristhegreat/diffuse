# Copyright (C) 2006-2009 Derrick Moser <derrick_moser@yahoo.com>
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

# This program builds a Windows installer for Diffuse.

import glob
import os
import platform
import subprocess
import sys

VERSION='0.3.2'
PACKAGE='1'
PLATFORM='win' + ''.join([ c for c in platform.architecture()[0] if c.isdigit() ])
INSTALLER='diffuse-%s-%s.%s' % (VERSION, PACKAGE, PLATFORM)

# makes a directory without complaining if it already exists
def mkdir(s):
    if not os.path.isdir(s):
        os.mkdir(s)

# copies a file to 'dest'
def copyFile(src, dest, use_text_mode=False):
    print 'copying "%s" to "%s"' % (src, dest)
    if use_text_mode:
        r = 'r'
        w = 'w'
    else:
        r = 'rb'
        w = 'wb'
    f = open(src, r)
    s = f.read()
    f.close()
    f = open(dest, w)
    f.write(s)
    f.close()

# recursively copies a directory to 'dest'
def copyDir(src, dest):
    print 'copying "%s" to "%s"' % (src, dest)
    mkdir(dest)
    for f in os.listdir(src):
        s = os.path.join(src, f)
        d = os.path.join(dest, f)
        if os.path.isfile(s):
            copyFile(s, d)
        elif os.path.isdir(s):
            copyDir(s, d)

#
# Make sure we are in the correct directory.
#

path = os.path.dirname(sys.argv[0])
if path != '':
    os.chdir(path)

#
# Build EXE versions of the Diffuse Python script.
#

# make a temp directory
mkdir('temp')
# copy script into temp directory under two names
for p in 'temp\\diffuse.py', 'temp\\diffusew.pyw':
    copyFile('..\\src\\usr\\bin\\diffuse', p, True)

# build executable in 'dist' from diffuse.py and diffusew.pyw
args = [ sys.executable, 'setup.py', 'py2exe' ]
if os.spawnv(os.P_WAIT, args[0], args) != 0:
    raise IOError('Could not run setup.py')

# include Python 2.6 specific DLLs and manifests
if platform.python_version_tuple()[:2] == (2, 6):
    for f in 'msvcm90.dll', 'msvcp90.dll', 'msvcr90.dll':
        copyFile(os.path.join(os.environ['SYSTEMROOT'], 'WinSxS\\x86_Microsoft.VC90.CRT_1fc8b3b9a1e18e3b_9.0.21022.8_x-ww_d08d0375\\' + f), 'dist\\' + f)
    copyFile(os.path.join(os.environ['SYSTEMROOT'], 'WinSxS\\Manifests\\x86_Microsoft.VC90.CRT_1fc8b3b9a1e18e3b_9.0.21022.8_x-ww_d08d0375.manifest'), 'dist\\Microsoft.VC90.CRT.manifest')

# include GTK dependencies
gtk_dir = os.environ['GTK_BASEPATH']
copyDir(os.path.join(gtk_dir, 'lib'), 'dist\\lib')
copyDir(os.path.join(gtk_dir, 'etc'), 'dist\\etc')
mkdir('dist\\share')
copyDir(os.path.join(gtk_dir, 'share\\themes'), 'dist\\share\\themes')

#
# Add all support files.
#

# syntax highlighting support
mkdir('dist\\syntax')
for p in glob.glob('..\\src\\usr\\share\\diffuse\\syntax\\*.syntax'):
    copyFile(p, os.path.join('dist\\syntax', os.path.basename(p)), True)
copyFile('diffuserc', 'dist\\diffuserc')

# application icon
copyFile('diffuse.ico', 'dist\\diffuse.ico')

#
# Add all documentation.
#

# license and other documentation
for p in 'AUTHORS', 'ChangeLog', 'COPYING', 'README':
    copyFile(os.path.join('..', p), os.path.join('dist', p + '.txt'), True)

# convert the manual from DocBook to HTML
cmd = [ 'xsltproc',
        os.path.join(os.environ['DOCBOOK_XSL_HOME'], 'html\\docbook.xsl'),
        '..\\src\\usr\\share\\gnome\\help\\diffuse\\C\\diffuse.xml' ]
info = subprocess.STARTUPINFO()
info.dwFlags |= subprocess.STARTF_USESHOWWINDOW
info.wShowWindow = subprocess.SW_HIDE
proc = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, startupinfo=info)
proc.stdin.close()
proc.stderr.close()
fd = proc.stdout
s = fd.read()
fd.close()
if proc.wait() != 0:
    raise IOError('Could not run xsltproc')
# add link to style sheet
s = s.replace('</head>', '<link rel="stylesheet" href="style.css" type="text/css"/></head>')
# save HTML version of the manual
f = open('dist\\manual.html', 'w')
f.write(s)
f.close()
copyFile('style.css', 'dist\\style.css')

#
# Package everything into a single EXE installer.
#

# build binary installer 
copyFile(os.path.join(os.environ['ADD_PATH_HOME'], 'add_path.exe'), 'dist\\add_path.exe')
if os.system('iscc diffuse.iss /F%s' % (INSTALLER, )) != 0:
    raise IOError('Could not run iscc')

#
# Declare success.
#

print 'Successfully created "%s".' % (INSTALLER, )
