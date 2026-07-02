ifneq ($(CONFIG_ARCH_QTI_VM), y)
ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)

					lahaina-v2.1.dtb
					lahaina-v2.1.dtb
					lahaina-v2.1.dtb
					lahaina-v2.1.dtb
					lahaina-v2.1.dtb
					lahaina-v2.1.dtb
else
dtb-$(CONFIG_ARCH_LAHAINA) += lahaina-rumi.dtb \
	lahaina-mtp-hsp.dtb \
	lahaina-mtp.dtb \
	lahaina-cdp.dtb \
	lahaina-atp.dtb \
	lahaina-hdk.dtb \
	lahaina-qrd-hsp.dtb \
	lahaina-qrd.dtb \
	lahaina-qrd-module.dtb \
	lahainap-mtp.dtb \
	lahainap-cdp.dtb \
	lahainap-atp.dtb \
	lahainap-qrd.dtb \
	lahaina-v2-mtp.dtb \
	lahaina-v2-cdp.dtb \
	lahaina-v2-atp.dtb \
	lahaina-v2-hdk.dtb \
	lahaina-v2-qrd.dtb \
	lahaina-v2-qrd-module.dtb \
	lahainap-v2-mtp.dtb \
	lahainap-v2-cdp.dtb \
	lahainap-v2-atp.dtb \
	lahainap-v2-qrd.dtb \
	lahaina-cdp-v2.2.dtb \
	lahaina-v2.1-mtp.dtb \
	lahaina-v2.1-cdp.dtb \
	lahaina-v2.1-atp.dtb \
	lahaina-v2.1-hdk.dtb \
	lahaina-v2.1-hhg.dtb \
	lahainap-v2.1-hhg-hsp-pro.dtb \
	lahaina-v2.1-qrd.dtb \
	lahaina-v2.1-qrd-module.dtb \
	lahainap-v2.1-mtp.dtb \
	lahainap-v2.1-cdp.dtb \
	lahainap-v2.1-atp.dtb \
	lahainap-v2.1-qrd.dtb \
	lahaina-mtp-v2.dtb \
	lahaina-mtp-v2.1.dtb \
	lahaina-v2.1-mtp-hsp-pro.dts \
	lahaina-v2.1-cdp-hsp-pro.dts \
	lahaina-v2.1-qrd-hsp-pro.dts
endif

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)


else
dtb-$(CONFIG_ARCH_HOLI) += holi-rumi.dtb \
	holi-mtp.dtb \
	holi-cdp.dtb \
	holi-cdp-lcd.dtb \
	holi-qrd.dtb \
	holi-atp.dtb \
	holi-mtp-usbc.dtb\
	holi-mtp-pm6125.dtb \
	holi-cdp-pm6125.dtb \
	holi-cdp-lcd-pm6125.dtb \
	holi-mtp-usbc-pm6125.dtb \
	holi-mtp-pm6125-nopmi.dtb \
	holi-qrd-pm6125.dtb \
	holi-qrd-pm6125-nopmi.dtb

endif

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)

else
dtb-$(CONFIG_ARCH_BLAIR) += blair-rumi.dtb \
	blair-mtp.dtb \
	blair-cdp.dtb \
	blair-atp.dtb \
	blair-qrd.dtb \
	blair-mtp-usbc.dtb \
	blair-mtp-nopmi.dtb \
	blair-qrd-nopmi.dtb \
	blairp-mtp.dtb \
	blairp-cdp.dtb \
	blairp-atp.dtb \
	blairp-qrd.dtb \
	blairp-mtp-usbc.dtb \
	blairp-mtp-nopmi.dtb \
	blairp-qrd-nopmi.dtb
endif

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)
dtbo-$(CONFIG_ARCH_SHIMA) +=    \

else
dtb-$(CONFIG_ARCH_SHIMA) += shima-rumi.dtb  \
			    shima-idp.dtb   \
			    shima-idp-120fps.dtb  \
			    shima-atp.dtb \
			    shima-qrd.dtb \
			    shima-idps-digital-mics.dtb \
			    shima-idps-digital-mics-120fps.dtb
endif

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)
dtbo-$(CONFIG_ARCH_YUPIK) +=    \


else
dtb-$(CONFIG_ARCH_YUPIK) += yupik-rumi.dtb \
	yupik-idp.dtb \
	yupik-atp.dtb \
	yupik-qrd.dtb \
	yupik-idps-amoled.dtb \
	yupik-idp-pm7250b.dtb \
	yupik-idp-hsp.dtb \
	yupikp-idp.dtb \
	yupikp-atp.dtb \
	yupikp-qrd.dtb \
	yupikp-idps-amoled.dtb \
	yupikp-idp-hsp.dtb \
	yupik-iot-idp.dtb \
	yupik-iot-idp-pm7250b.dtb \
	yupik-iot-qrd.dtb \
	yupik-iot-hsp.dtb \
	yupik-iot-idps-amoled.dtb \
	yupikp-iot-idp.dtb \
	yupikp-iot-idp-pm7250b.dtb \
	yupikp-iot-qrd.dtb \
	yupikp-iot-hsp.dtb \
	yupik-iot-hsp-pm7250b.dtb \
	yupikp-iot-hsp-pm7250b.dtb \
	yupikp-iot-idps-amoled.dtb \
	katmai-idp.dtb \
	katmai-idp-pm7250b.dtb \
	katmai-qrd.dtb \
	katmai-hsp.dtb \
	katmai-idps-amoled.dtb \
	katmaip-idp.dtb \
	katmaip-idp-pm7250b.dtb \
	katmaip-qrd.dtb \
	katmaip-hsp.dtb \
	katmai-hsp-pm7250b.dtb \
	katmaip-hsp-pm7250b.dtb \
	katmaip-idps-amoled.dtb
endif

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)
dtbo-$(CONFIG_ARCH_MONACO) +=    \


else
dtb-$(CONFIG_ARCH_MONACO) += monaco-rumi.dtb \
	monaco-standalone-idp-v1.dtb \
	monaco-standalone-idp-v2.dtb \
	monaco-standalone-idp-v3.dtb \
	monaco-idp-v1.dtb \
	monaco-idp-v2.dtb \
	monaco-idp-v3.dtb \
	monacop-idp-v1.dtb
endif

dtb-$(CONFIG_ARCH_SCUBA) += qrb2210-rb1.dtb

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)
ifeq ($(CONFIG_AUTO_LXC_OVERLAY), y)
	dtbo-$(CONFIG_ARCH_SA8155) += \
else
	dtbo-$(CONFIG_ARCH_SA8155) += \
endif

else
dtb-$(CONFIG_ARCH_SA8155)       += sa8155-adp-star.dtb \
	sa8155p-adp-star.dtb \
	sa8155-v2-adp-star.dtb \
	sa8155p-v2-adp-star.dtb \
	sa8155-v2-adp-air.dtb \
	sa8155p-v2-adp-air.dtb
endif

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)
ifeq ($(CONFIG_AUTO_LXC_OVERLAY), y)
	dtbo-$(CONFIG_ARCH_SA6155) += \
else
	dtbo-$(CONFIG_ARCH_SA6155) += \
endif

else
dtb-$(CONFIG_ARCH_SA6155)       += sa6155-adp-star.dtb \
	sa6155p-adp-star.dtb \
	sa6155p-adp-star-lpass.dtb \
	sa6155-adp-air.dtb \
	sa6155p-adp-air.dtb \
	sa6155p-v2-adp-star.dtb \
	sa6155p-v2-adp-air.dtb \
	sa6155p-v2-adp-air-lpass.dtb
endif

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)
ifeq ($(CONFIG_AUTO_LXC_OVERLAY), y)
	dtbo-$(CONFIG_ARCH_SA8195) += \
else
	dtbo-$(CONFIG_ARCH_SA8195) += \
endif

else
dtb-$(CONFIG_ARCH_SA8195)	+= sa8195p-adp-star.dtb \
	sa8195p-v2-adp-air.dtb
endif

dtb-$(CONFIG_ARCH_SA2150P) += sa2150p-ccard-emmc.dtb
endif

ifeq ($(CONFIG_ARCH_LAHAINA), y)
ifeq ($(CONFIG_ARCH_QTI_VM), y)
dtb-$(CONFIG_ARCH_QTI_VM) += lahaina-vm-mtp.dtb \
	lahaina-vm-cdp.dtb \
	lahaina-vm-qrd.dtb \
	lahaina-vm-mtp-v2.dtb \
	lahaina-vm-mtp-v2.1.dtb
endif
endif

dtb-$(CONFIG_ARCH_SDXLEMUR) += sdxlemur-rumi.dtb \
	sdxlemur-atp.dtb \
	sdxlemur-cdp.dtb \
	sdxlemur-mtp.dtb \
	sdxlemur-mtp-mbb.dtb \
	sdxlemur-mtp-cpe.dtb \
	sdxlemur-mtp-cpe-pine1x.dtb \
	sdxlemur-mtp-cpe-pine2x.dtb \
	sdxlemur-mtp-mbb-emmc.dtb \
	sdxlemur-mtp-mbb-emmc-512mb.dtb \
	sdxlemur-mtp-mbb-ntn3-pcie.dtb \
	sdxlemur-mtp-mbb-pcie-ep.dtb \
	sdxlemur-mtp-mbb-pcie-ep-ipq.dtb \
	sdxlemur-mtp-mbb-pcie-rc-ep.dtb \
	sdxlemur-mtp-mbb-m2-ep.dtb \
	sdxlemur-mtp-mbb-m2-ep-usb.dtb \
	sdxlemur-mtp-mbb.dtb \
	sdxlemur-rcm-pcie-ep.dtb \
	sdxlemur-rcm-rc.dtb \
	sdxlemur-rcm-rc-pine1x.dtb \
	sdxlemur-rcm-rc-pine2x.dtb \
	sdxlemur-v2-cdp.dtb \
	sdxlemur-v2-mtp-mbb.dtb \
	sdxlemur-v2-mtp-cpe.dtb \
	sdxlemur-v2-mtp-mbb-emmc.dtb \
	sdxlemur-v2-mtp-mbb-ntn3-pcie.dtb \
	sdxlemur-v2-mtp-mbb-pcie-ep.dtb \
	sdxlemur-v2-mtp-mbb-pcie-ep-ipq.dtb \
	sdxlemur-v2-mtp-mbb-pcie-rc-ep.dtb \
	sdxlemur-v2-rcm-pcie-ep.dtb \
	sdxlemur-v2-rcm-rc.dtb \
	sdxlemur-v2-atp.dtb \
	sdxlemur-v2-mtp-cpe-pine1x.dtb \
	sdxlemur-v2-mtp-cpe-pine2x.dtb \
	sdxlemur-v2-mtp-mbb-emmc-512mb.dtb \
	sdxlemur-v2-mtp-mbb-m2-ep-usb.dtb \
	sdxlemur-v2-mtp-mbb-m2-ep.dtb \
	sdxlemur-v2-rcm-rc-pine1x.dtb \
	sdxlemur-v2-rcm-rc-pine2x.dtb \
	sdxlemur-v2-m2-ep-fwa.dtb \
	sdxlemur-v2-mtp-cpe-pine2x-5+6.dtb



ifeq ($(CONFIG_ARCH_SHIMA), y)
ifeq ($(CONFIG_ARCH_QTI_VM), y)
dtb-$(CONFIG_ARCH_QTI_VM) += shima-vm-rumi.dtb \
	shima-vm-atp.dtb \
	shima-vm-idp.dtb \
	shima-vm-qrd.dtb
endif
endif

dtb-$(CONFIG_ARCH_SDXNIGHTJAR) += sdxnightjar-mtp.dtb \
	sdxnightjar-cdp.dtb \
	sdxnightjar-qrd.dtb \
	sdxnightjar-dualwifi-mtp.dtb \
	sdxnightjar-512mb-mtp.dtb \
	sdxnightjar-dualwifi-512mb-mtp.dtb

ifeq ($(CONFIG_ARCH_YUPIK), y)
ifeq ($(CONFIG_ARCH_QTI_VM), y)
dtb-$(CONFIG_ARCH_QTI_VM) += yupik-vm-rumi.dtb \
	yupik-vm-atp.dtb \
	yupik-vm-idp.dtb \
	yupik-vm-qrd.dtb
endif
endif

dtb-$(CONFIG_QTI_QUIN_GVM) += sa8155-vm-la.dtb \
	sa8155-vm-lv.dtb \
	sa8155-vm-la-mt.dtb \
	sa8155-vm-lv-mt.dtb \
	sa8195-vm-la.dtb \
	sa8195-vm-lv.dtb \
	sa8195-vm-la-mt.dtb \
	sa8195-vm-lv-mt.dtb \
	sa8195-vm-lv-lxc.dtb \
	sa6155p-vm-la.dtb \
	direwolf-vm-lv.dtb \
	direwolf-vm-la.dtb

ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)

else
dtb-$(CONFIG_ARCH_DIREWOLF) += direwolf-ivi-rumi.dtb \
	direwolf-ivi-adp-star.dtb \
	direwolf-adas-rumi.dtb \
	direwolf-adas-adp-star.dtb
endif

always		:= $(dtb-y)
subdir-y	:= $(dts-dirs)
