Summary: graphical tool for comparing and merging text files
Name: diffuse
Version: 0.2.14
Release: 1
License: GPL
Group: Development/Tools/Version Control
Source: http://prdownloads.sourceforge.net/%{name}/%{name}-%{version}.tar.bz2
BuildArch: noarch
Requires: python >= 2.4, pygtk2 >= 2.10
BuildRoot: %{_tmppath}/%{name}-root

%description
Diffuse is a graphical tool for merging and comparing text files.  Diffuse is
able to compare an arbitrary number of files side-by-side and gives users the
ability to manually adjust line matching and directly edit files.  Diffuse can
also retrieve revisions of files from Bazaar, CVS, Darcs, Git, Mercurial,
Monotone, Subversion, and SVK repositories for comparison and merging.

%prep
%setup -q

%build

%install
mkdir %{buildroot}
cp -a src/* %{buildroot}/
gzip -9 %{buildroot}/usr/share/man/man1/diffuse.1

%clean
rm -rf %{buildroot}

%post
scrollkeeper-update -q
upate-desktop-database

%postun
scrollkeeper-update -q
upate-desktop-database

%files
%defattr(-,root,root)
/usr/bin/diffuse
%config /etc/diffuserc
/usr/share/diffuse/
/usr/share/applications/diffuse.desktop
/usr/share/gnome/help/diffuse/C/diffuse.xml
/usr/share/man/man1/diffuse.1.gz
/usr/share/omf/diffuse/diffuse-C.omf
/usr/share/pixmaps/diffuse.png
%doc AUTHORS ChangeLog COPYING README TODO

%changelog
* Sun Apr 27 2008 Derrick Moser <derrick_moser@yahoo.com>
- created initial diffuse package
