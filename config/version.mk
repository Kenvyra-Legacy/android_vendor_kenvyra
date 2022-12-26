# Copyright (C) 2016 The Pure Nexus Project
# Copyright (C) 2016 The JDCTeam
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

KENVYRA_MOD_VERSION = v13.0
KENVYRA_BUILD_TYPE := UNOFFICIAL
KENVYRA_BUILD_ZIP_TYPE := VANILLA

ifeq ($(KENVYRA_BETA),true)
    KENVYRA_BUILD_TYPE := BETA
endif

ifeq ($(KENVYRA_GAPPS), true)
    $(call inherit-product, vendor/gapps/common/common-vendor.mk)
    KENVYRA_BUILD_ZIP_TYPE := GAPPS
endif

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)

ifeq ($(KENVYRA_OFFICIAL), true)
    KENVYRA_BUILD_TYPE := OFFICIAL

    PRODUCT_PACKAGES += \
        Updater
endif

ifeq ($(KENVYRA_COMMUNITY), true)
   LIST = $(shell cat infrastructure/devices/arrow-community.devices | awk '$$1 != "#" { print $$2 }')
    ifeq ($(filter $(CURRENT_DEVICE), $(LIST)), $(CURRENT_DEVICE))
      IS_COMMUNITY=true
      KENVYRA_BUILD_TYPE := COMMUNITY
    endif
    ifneq ($(IS_COMMUNITY), true)
       KENVYRA_BUILD_TYPE := UNOFFICIAL
       $(error This isn't a community device "$(CURRENT_DEVICE)")
    endif
endif

KENVYRA_VERSION := Kenvyra-$(KENVYRA_MOD_VERSION)-$(CURRENT_DEVICE)-$(KENVYRA_BUILD_TYPE)-$(shell date -u +%Y%m%d)-$(KENVYRA_BUILD_ZIP_TYPE)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.kenvyra.version=$(KENVYRA_VERSION) \
  ro.kenvyra.releasetype=$(KENVYRA_BUILD_TYPE) \
  ro.kenvyra.ziptype=$(KENVYRA_BUILD_ZIP_TYPE) \
  ro.modversion=$(KENVYRA_MOD_VERSION)

KENVYRA_DISPLAY_VERSION := Kenvyra-$(KENVYRA_MOD_VERSION)-$(KENVYRA_BUILD_TYPE)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.kenvyra.display.version=$(KENVYRA_DISPLAY_VERSION)
