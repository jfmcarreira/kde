# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="KWallet PAM module to not enter password again"
LICENSE="LGPL-2.1"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-libs/libgcrypt:0=
	virtual/pam
"
RDEPEND="${DEPEND}
	net-misc/socat
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_LIBDIR="/$(get_libdir)"
		-DKWALLET4=0
	)
	kde5_src_configure
}

pkg_postinst() {
	check_dm() {
		if [[ -e "${ROOT}${2}" ]] ; then
			if grep -Eq "auth\s+optional\s+pam_kwallet5.so" "${ROOT}${2}" && \
				grep -Eq "session\s+optional\s+pam_kwallet5.so" "${ROOT}${2}" ; then
				elog "    ${1} - ${2} ...GOOD"
			else
				ewarn "    ${1} - ${2} ...BAD"
			fi
		fi
	}
	elog "This package enables auto-unlocking of kde-frameworks/kwallet:5."
	elog "List of things to make it work:"
	elog "1.  Use standard blowfish encryption instead of GPG"
	elog "2.  Use same password for login and kwallet"
	elog "3.  A display manager with support for PAM"
	elog "4.a Have the following lines in the display manager's pam.d file:"
	elog "    -auth        optional        pam_kwallet5.so"
	elog "    -session     optional        pam_kwallet5.so auto_start"
	elog "4.b Checking installed DMs..."
	has_version "x11-misc/sddm" && check_dm "SDDM" "/etc/pam.d/sddm"
	has_version "x11-misc/lightdm" && check_dm "LightDM" "/etc/pam.d/lightdm"
	elog
	elog "See also: https://wiki.gentoo.org/wiki/KDE#KWallet_auto-unlocking"
}
