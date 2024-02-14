add wave -position insertpoint  \
sim:/AHB_UVC_top/uvc_if/hresetn \
sim:/AHB_UVC_top/uvc_if/hclk \
sim:/AHB_UVC_top/uvc_if/Htrans \
sim:/AHB_UVC_top/uvc_if/Hburst \
sim:/AHB_UVC_top/uvc_if/Haddr \
sim:/AHB_UVC_top/uvc_if/Hwrite \
sim:/AHB_UVC_top/uvc_if/Hsize \
sim:/AHB_UVC_top/uvc_if/Hwdata \
sim:/AHB_UVC_top/uvc_if/Hrdata \
sim:/AHB_UVC_top/uvc_if/Hprot \
sim:/AHB_UVC_top/uvc_if/Hready_out \
sim:/AHB_UVC_top/uvc_if/Hresp \
sim:/AHB_UVC_top/uvc_if/Hready_in 
run -all
wave zoom full
# {0 ps} {341250 ps}
config wave -signalnamewidth 1
