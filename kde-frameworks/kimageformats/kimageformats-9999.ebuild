# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit kde-frameworks

DESCRIPTION="Framework providing additional format plugins for Qt's image I/O system"
LICENSE="LGPL-2+"
KEYWORDS=""
IUSE="eps jpeg2k openexr webp"

RDEPEND="
	dev-qt/qtgui:5
	eps? ( dev-qt/qtprintsupport:5 )
	jpeg2k? ( media-libs/jasper )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr:=
	)
	webp? ( media-libs/libwebp:= )
"
DEPEND="${RDEPEND}"

DOCS=( src/imageformats/AUTHORS )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package eps Qt5PrintSupport)
		$(cmake-utils_use_find_package jpeg2k Jasper)
		$(cmake-utils_use_find_package openexr OpenEXR)
		$(cmake-utils_use_find_package webp WebP)
	)

	kde-frameworks_src_configure
}

src_install() {
	kde-frameworks_src_install

	# collides with kde-base/kimgio
	# part of shared-mime-info upstream at 7612a110f9a42db4730a8c6d1fff6d78c899d53d
	if use webp ; then
		"${D}"/usr/share/mime/packages/{,kimageformats}webp.xml || die "rename failed"
	fi
}
