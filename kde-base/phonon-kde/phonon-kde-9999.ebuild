# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

KMNAME="kdebase-runtime"
KMMODULE="phonon"
inherit kde4-meta

DESCRIPTION="Phonon KDE Integration"
HOMEPAGE="http://phonon.kde.org"

KEYWORDS=""
LICENSE="GPL-2"
IUSE="alsa debug +xine"

DEPEND="
	>=media-sound/phonon-4.3.80[xine?]
	alsa? ( media-libs/alsa-lib )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.4-optional-alsa.patch
)

src_prepare() {
	kde4-meta_src_prepare

	# Don't build tests - they require OpenGL
	sed -e 's/add_subdirectory(tests)//' \
		-i phonon/CMakeLists.txt || die "Failed to disable tests"

}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with xine)
	)

	kde4-meta_src_configure
}
