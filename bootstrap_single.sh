#!/bin/bash
#
# Copyright (C) 2017-2025 Tactical Computing Laboratories, LLC
# All Rights Reserved
# contact@tactcomplabs.com
#
# See LICENSE in the top level directory for licensing details
#

# Moved BASH flags down for better compatibility
set -euo pipefail

#Check for a user-specified version number
USER_CMDLINE="${1:-}"

print_help() {
  echo "Usage: $0 <version_number|help>"
  echo ""
  echo "Bootstrap SST Core and SST Elements packages for container builds."
  echo ""
  echo "Arguments:"
  echo "  <version_number>   SST version to bootstrap (e.g., 14.1.0, 15.1.2)"
  echo "  help, -h, --help   Show this help message"
  echo ""
  echo "Supported versions:"
  echo "  SST Core    : 11.0.0, 11.1.0, 12.0.1, 12.1.0, 13.0.0, 13.1.0, 14.0.0, 14.1.0, 15.1.2"
  echo "  SST Elements: 11.1.0, 12.0.1, 12.1.0, 13.0.0, 13.1.0, 14.0.0, 14.1.0, 15.1.0"
  echo ""
  echo "Example:"
  echo "  $0 14.1.0"
}

# Default versions (overriden by command line)
SST_VERSION="15.1.2"
SST_EXP_VERSION="15_1_2"
SST_ELEMS_VERSION="15.1.0"
SST_ELEMS_EXP_VERSION="15_1_0"

# Global variables for SST packages and SHA
SST_CORE=""
SST_ELEMS=""
SST_CORE_URL=""
SST_ELEMS_URL=""

#Files, URLs, and hashes to check
SSTCORE_11_0_0="sstcore-11.0.0.tar.gz"
SSTCORE_11_1_0="sstcore-11.1.0.tar.gz"
SSTCORE_12_0_1="sstcore-12.0.1.tar.gz"
SSTCORE_12_1_0="sstcore-12.1.0.tar.gz"
SSTCORE_13_0_0="sstcore-13.0.0.tar.gz"
SSTCORE_13_1_0="sstcore-13.1.0.tar.gz"
SSTCORE_14_0_0="sstcore-14.0.0.tar.gz"
SSTCORE_14_1_0="sstcore-14.1.0.tar.gz"
SSTCORE_15_1_2="sstcore-15.1.2.tar.gz"
SSTELEMENTS_11_1_0="sstelements-11.1.0.tar.gz"
SSTELEMENTS_12_0_1="sstelements-12.0.1.tar.gz"
SSTELEMENTS_12_1_0="sstelements-12.1.0.tar.gz"
SSTELEMENTS_13_0_0="sstelements-13.0.0.tar.gz"
SSTELEMENTS_13_1_0="sstelements-13.1.0.tar.gz"
SSTELEMENTS_14_0_0="sstelements-14.0.0.tar.gz"
SSTELEMENTS_14_1_0="sstelements-14.1.0.tar.gz"
SSTELEMENTS_15_1_0="sstelements-15.1.0.tar.gz"

SSTCORE_11_0_0_URL="https://github.com/sstsimulator/sst-core/releases/download/v11.0.0_Final/sstcore-11.0.0.tar.gz"
SSTCORE_11_1_0_URL="https://github.com/sstsimulator/sst-core/releases/download/v11.1.0_Final/sstcore-11.1.0.tar.gz"
SSTCORE_12_0_1_URL="https://github.com/sstsimulator/sst-core/releases/download/v12.0.1_Final/sstcore-12.0.1.tar.gz"
SSTCORE_12_1_0_URL="https://github.com/sstsimulator/sst-core/releases/download/v12.1.0_Final/sstcore-12.1.0.tar.gz"
SSTCORE_13_0_0_URL="https://github.com/sstsimulator/sst-core/releases/download/v13.0.0_Final/sstcore-13.0.0.tar.gz"
SSTCORE_13_1_0_URL="https://github.com/sstsimulator/sst-core/releases/download/v13.1.0_Final/sstcore-13.1.0.tar.gz"
SSTCORE_14_0_0_URL="https://github.com/sstsimulator/sst-core/releases/download/v14.0.0_Final/sstcore-14.0.0.tar.gz"
SSTCORE_14_1_0_URL="https://github.com/sstsimulator/sst-core/releases/download/v14.1.0_Final/sstcore-14.1.0.tar.gz"
SSTCORE_15_1_2_URL="https://github.com/sstsimulator/sst-core/releases/download/v15.1.2_Final/sstcore-15.1.2.tar.gz"

SSTELEMENTS_11_0_0_URL="https://github.com/sstsimulator/sst-elements/releases/download/v11.0.0_Final/sstelements-11.0.0.tar.gz"
SSTELEMENTS_11_1_0_URL="https://github.com/sstsimulator/sst-elements/releases/download/v11.1.0_Final/sstelements-11.1.0.tar.gz"
SSTELEMENTS_12_0_1_URL="https://github.com/sstsimulator/sst-elements/releases/download/v12.0.1_Final/sstelements-12.0.1.tar.gz"
SSTELEMENTS_12_1_0_URL="https://github.com/sstsimulator/sst-elements/releases/download/v12.1.0_Final/sstelements-12.1.0.tar.gz"
SSTELEMENTS_13_0_0_URL="https://github.com/sstsimulator/sst-elements/releases/download/v13.0.0_Final/sstelements-13.0.0.tar.gz"
SSTELEMENTS_13_1_0_URL="https://github.com/sstsimulator/sst-elements/releases/download/v13.1.0_Final/sstelements-13.1.0.tar.gz"
SSTELEMENTS_14_0_0_URL="https://github.com/sstsimulator/sst-elements/releases/download/v14.0.0_Final/sstelements-14.0.0.tar.gz"
SSTELEMENTS_14_1_0_URL="https://github.com/sstsimulator/sst-elements/releases/download/v14.1.0_Final/sstelements-14.1.0.tar.gz"
SSTELEMENTS_15_1_0_URL="https://github.com/sstsimulator/sst-elements/releases/download/v15.1.0_Final/sstelements-15.1.0.tar.gz"

SSTCORE_11_0_0_SHA1="a1d0dd4f6b0c4216c35589179da0f677bbe5fdf3"
SSTCORE_11_1_0_SHA1="9e2d6efcf94e395555de5ceb6a5c7c19f5684892"
SSTCORE_12_0_1_SHA1="2d601101d88dfca8ad032d71e43a6ce3197ebe81"
SSTCORE_12_1_0_SHA1="e5fd18b59799ae607fc076a941aaedd9731bf33f"
SSTCORE_13_0_0_SHA1="eaa2b06981631232cd2c22f405a61aa3fb0f1a5c"
SSTCORE_13_1_0_SHA1="89430e296f324b040be87200b28acd323f260121"
SSTCORE_14_0_0_SHA1="3c3f51134cc92ac7d659543aefcd8d4fd89fea28"
SSTCORE_14_1_0_SHA1="063edf04008622df11690448161bf3cb874eb835"
SSTCORE_15_1_2_SHA1="b9515b2d448db6bf35b9c2aa3ab979ed91e72af8"
SSTELEMENTS_11_0_0_SHA1="8b9e779a8ace79a2d5767692a65505c63d3c5cd1"
SSTELEMENTS_11_1_0_SHA1="8f2050e907466f32d8e2f81f1622aab1db3011e0"
SSTELEMENTS_12_0_1_SHA1="a3917fdae7bf1c89efa5b7252f2db1527117529c"
SSTELEMENTS_12_1_0_SHA1="456c27e1c5f89d5d0a03c3b766706385f16d88f9"
SSTELEMENTS_13_0_0_SHA1="1245fca5dbecd51a79e7ac330321324d86e4405e"
SSTELEMENTS_13_1_0_SHA1="134dcc32ff117743d2a1cc494f0a2db0b729a082"
SSTELEMENTS_14_0_0_SHA1="9206c915f873221398409c7216edeff58ccbd9cd"
SSTELEMENTS_14_1_0_SHA1="c4db22ae04a2a1ff0b4dcef7814190fad641f399"
SSTELEMENTS_15_1_0_SHA1="b09e6b96d64e74bc0e01b1d759c11f7ac1cdac88"

GETCMD=""
SHA1SUM=""

MY_LN=`which ln`
MY_PWD=`pwd`

setup_get()  {
  if [ -x `which wget` ]
  then
    GETCMD="wget -O"
  elif [ -x `which curl` ]
  then
    GETCMD="curl --output"
  else
    echo "Error: could not find WGET or CURL to download files"
    exit -1
  fi
}

setup_sha1() {
  if [ -x `which sha1sum` ]
  then
    SHA1SUM="sha1sum"
  else
    echo "Error: could not find SHA1SUM command"
    exit -1
  fi
}

check_container_tools() {
  if [ -x `which singularity` ]
  then
    echo "Singularity: FOUND"
  else
    echo "Singularity: MISSING"
  fi

  if [ -x `which docker` ]
  then
    echo "Docker: FOUND"
  else
    echo "Docker: MISSING"
  fi
}

#Check the user-specified version for correct format and 
#expand to the correct variable format
get_version_to_bootstrap(){

	#Assign the commandline to a variable
	SST_VERSION=$USER_CMDLINE

	# Validate the version number format
	if [[ ! $SST_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	  echo "Invalid version number format. Please use the format MAJOR.MINOR.BUGFIX (e.g., 14.1.0)."
	  exit 1
	fi	

	#Create the expected "expanded" version number used for different checks
	SST_EXP_VERSION="${SST_VERSION//./_}"
	echo "Bootstrapping SST Version $SST_VERSION"

	# Map core version to elements version when they differ
	case "$SST_VERSION" in
	  15.1.2) SST_ELEMS_VERSION="15.1.0" ;;
	  *) SST_ELEMS_VERSION="$SST_VERSION" ;;
	esac
	SST_ELEMS_EXP_VERSION="${SST_ELEMS_VERSION//./_}"
}

download_packages(){

  #Use BASH variable indirection to substitute in the right version
  SST_CORE_STR="SSTCORE_${SST_EXP_VERSION}"
  SST_CORE=${!SST_CORE_STR}
  SST_CORE_URL_STR="SSTCORE_${SST_EXP_VERSION}_URL"
  SST_CORE_URL=${!SST_CORE_URL_STR}

  SST_ELEMS_STR="SSTELEMENTS_${SST_ELEMS_EXP_VERSION}"
  SST_ELEMS=${!SST_ELEMS_STR}
  SST_ELEMS_URL_STR="SSTELEMENTS_${SST_ELEMS_EXP_VERSION}_URL"
  SST_ELEMS_URL=${!SST_ELEMS_URL_STR}

  $GETCMD $SST_CORE $SST_CORE_URL >> /dev/null 2>&1
  $GETCMD $SST_ELEMS $SST_ELEMS_URL >> /dev/null 2>&1

  if test -f "$SST_CORE"; then
    echo "Downloaded $SST_CORE"
  else
    echo "Failed to download $SST_CORE"
    exit -1
  fi

  if test -f "$SST_ELEMS"; then
    echo "Downloaded $SST_ELEMS"
  else
    echo "Failed to download $SST_ELEMS"
    exit -1
  fi
}

verify_packages() {
  #-- get the sha1 of the package
  SST_CORE_SHA1=`$SHA1SUM $SST_CORE | awk '{print $1}'`
  SST_ELEMS_SHA1=`$SHA1SUM $SST_ELEMS | awk '{print $1}'`
  
  #-- compare against the standard package
  SST_CORE_SHA1_REF_STR="SSTCORE_${SST_EXP_VERSION}_SHA1"
  SST_CORE_SHA1_REF=${!SST_CORE_SHA1_REF_STR}
  SST_ELEMS_SHA1_REF_STR="SSTELEMENTS_${SST_ELEMS_EXP_VERSION}_SHA1"
  SST_ELEMS_SHA1_REF=${!SST_ELEMS_SHA1_REF_STR}

  if [ "$SST_CORE_SHA1" = "$SST_CORE_SHA1_REF" ]; then
    echo "SSTCORE $SST_VERSION SHA1 VERIFIED!"
  else
    echo "FAILED TO VERIFY SSTCORE $SST_VERSION SHA1 HASH"
    exit -1
  fi

  if [ "$SST_ELEMS_SHA1" = "$SST_ELEMS_SHA1_REF" ]; then
    echo "SSTELEMENTS $SST_VERSION SHA1 VERIFIED!"
  else
    echo "FAILED TO VERIFY SSTELEMENTS $SST_VERSION SHA1 HASH"
    exit -1
  fi

}

setup_symlinks() {
  $MY_LN -fs $MY_PWD/$SST_CORE ./containers/singularity/$SST_CORE
  $MY_LN -fs $MY_PWD/$SST_ELEMS ./containers/singularity/$SST_ELEMS
}

#-- Handle help flag and no user input before anything else
if [[ -z "$USER_CMDLINE" || "$USER_CMDLINE" == "help" || "$USER_CMDLINE" == "-h" || "$USER_CMDLINE" == "--help" ]]; then
  print_help
  exit 0
fi

#-- STAGE0: Check for user specification of version
get_version_to_bootstrap

#-- STAGE1: Setup the download mechanism
setup_get
setup_sha1

#-- STAGE2: Check for container tools
check_container_tools

#-- STAGE3: Download a single version's packages
download_packages

#-- STAGE4: Verify the packages
verify_packages

#-- STAGE5: Setup the symlinks
setup_symlinks

echo "Bootstrapping complete!"

exit 0

# EOF
