;*************************************************
; regress_2.ncl
;
; Concepts illustrated:
;   - Calculatitudeing the regression coefficient (slope) at each grid point   
;   - Copying attributes from one variable to another
;   - Drawing color-filled contours over a cylindrical equidistant map
;
;*************************************************
;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
  load "/home/precious/Desktop/kendal/shapefile_utils.ncl"
;========================================================================

shp_filename = "/home/precious/Desktop/kendal/Africa_SHP/Africa.shp"

 print("======================================================================")
   print("Masking data against " + shp_filename)
   optm = True
   optm@keep = True   ; Keep values inside this shape
   ;optm@return_mask = True    ;-- this forces the return of a 0s and 1s mask array

   
begin
;************************************************
; create pointer to file and read in indices
;************************************************

          


   in1h = addfile("jja_chirps2.nc","r")  
   in11h = addfile("jja_bcc.nc","r")
   in2h =addfile("jja_bcc_highres.nc","r") 
   in3h = addfile("jja_gfdl.nc","r")
   in4h  =addfile("jja_gfdl_highres.nc","r") 
   in5h = addfile("jja_hadgem.nc","r")
   in6h = addfile("jja_hadgem_highres.nc","r")
   in7h = addfile("jja_inm.nc","r")
   in8h = addfile("jja_inm_highres.nc","r")
   in9h = addfile("jja_mpi.nc","r")
   in10h = addfile("jja_mpi_highres.nc","r")
    
   
   
   

   tcojan = in1h->pr
   tcojan1 = in11h->pr

   tcofeb = in2h->pr
   tcomar = in3h->pr
   tcoapr = in4h->pr

   tcomay = in5h->pr
   tcojun = in6h->pr
   tcojul = in7h->pr
   
  
   c9 = in8h->pr
   c10 = in9h->pr
   c11 = in10h->pr
   
   
   
   pre1=dim_avg_n_Wrap(tcojan(:,:,:), 0)
   pre2=dim_avg_n_Wrap(tcojan1(:,:,:), 0)
   pre3=dim_avg_n_Wrap(tcofeb(:,:,:), 0)
   pre4=dim_avg_n_Wrap(tcomar(:,:,:), 0)
   pre5=dim_avg_n_Wrap(tcoapr(:,:,:), 0)
   pre6=dim_avg_n_Wrap(tcomay(:,:,:), 0)
   pre7=dim_avg_n_Wrap(tcojun(:,:,:), 0)
   pre8=dim_avg_n_Wrap(tcojul(:,:,:), 0)
   pre9=dim_avg_n_Wrap(c9(:,:,:), 0)
   pre10=dim_avg_n_Wrap(c10(:,:,:), 0)
   pre11=dim_avg_n_Wrap(c11(:,:,:), 0)
   
   
 
  pre1=shapefile_mask_data(pre1,shp_filename,optm)
  pre2=shapefile_mask_data(pre2,shp_filename,optm)
  pre3=shapefile_mask_data(pre3,shp_filename,optm)
  pre4=shapefile_mask_data(pre4,shp_filename,optm)
  pre5=shapefile_mask_data(pre5,shp_filename,optm)
  pre6=shapefile_mask_data(pre6,shp_filename,optm)
  pre7=shapefile_mask_data(pre7,shp_filename,optm)
  pre8=shapefile_mask_data(pre8,shp_filename,optm)
  pre9=shapefile_mask_data(pre9,shp_filename,optm)
  pre10=shapefile_mask_data(pre10,shp_filename,optm)
  pre11=shapefile_mask_data(pre11,shp_filename,optm)
 
  printVarSummary(tcojan) 
  
  


   dimf = dimsizes(tcomar)
   ntim = dimf(0)                ; all years and months
   nlatitude = dimf(1)
   mlongitude = dimf(2)




   
;;;===============================================================================================================
   wks_type                 = "png"                  ;-- plot output type
  wks_type@wkWidth         =  950                 ;-- wk width
  wks_type@wkHeight        =  950                 ;-- wk height
   wks  = gsn_open_wks("png","new_trend")         ; send graphics to PNG file
   
   res                       = True     
   res@gsnFrame              = False
   res@gsnDraw              = False
   res@gsnMaximize           = True             ; make large
   res@gsnAddCyclic          = False
   res@cnFillOn              = True             ; turn on color
   res@cnLinesOn             = False            ; turn off contour lines
   res@cnLineLabelsOn        = False            ; turn off contour line labels
   res@cnConstFLabelOn       = False
   res@cnInfoLabelOn         = False
   
   res@gsnLeftString         = ""
   res@gsnRightString        = ""
  
        ;res@pmTickMarkDisplayMode = "Always"
        ;res@tiMainFont          = 22
        ;res@tiXAxisFont          = 22
        ;res@tiYAxisFont          = 22
        ;res@tmXBLabelFont       = 22
        ;res@tmYLLabelFont       = 22
        ;res@tmYRLabelFont       = 22
;        res@tmXBLabelFontHeightF = 0.03
;        res@tmYLLabelFontHeightF = 0.03
;        res@tmYRLabelFontHeightF = 0.04
        
   ;res@cnLevelSelectionMode  = "ExplicitLevels"   ; set manual contour levels
   res@mpFillOn              = False            ; turn off default background gray
   res@mpOutlineOn           = True
   res@mpOutlineBoundarySets = "National" 
   res@mpMinLonF             = -19.5
   res@mpMaxLonF             = 19.5
   res@mpMinLatF             = 0
   res@mpMaxLatF             = 19.5
   res@lbLabelBarOn          = False
   res@mpDataBaseVersion     = "MediumRes"
   res@cnFillPalette   = "MPL_bwr"
   ;res@vpHeightF = 0.05       ; Changes the aspect ratio
   ;res@vpWidthF  = 0.04
   
   res@vpWidthF              =  0.98                  ;-- width
  res@vpHeightF             =  0.95                  ;-- height
  
  res@tmXBLabelFontHeightF  =  0.03                 ;-- change XB label font size
  res@tmYLLabelFontHeightF  =  0.03                 ;-- change YL label font size
  res@tmXBMajorLengthF      =  0.03                 ;-- change XB the tickmark length
  res@tmYLMajorLengthF      =  0.03  
  res@tiMainFont            = "helvetica"            ;-- title string font
  res@tiMainFontHeightF     =  0.04  
  ;res@tmXBLabelFontHeightF = 0.02
  ;res@tmYLLabelFontHeightF = 0.02
  


  
  
   plot =new(11, graphic) 
   res@tiMainString          = "(a) CHIRPS"    
   plot(0) = gsn_csm_contour_map(wks,pre1,res)    
     
   res@tiMainString          = "(b) BCC-CSM2-MR"    
   plot(1) = gsn_csm_contour_map(wks,pre2,res)    
   res@tiMainString          = "(c) BCC-CSM2-HR"    
   plot(2) = gsn_csm_contour_map(wks,pre3,res) 
      
   res@tiMainString          = "(d) GFDL-CM4"    
   plot(3) = gsn_csm_contour_map(wks,pre4,res)    
   res@tiMainString          = "(e) GFDL-CM4C192"    
   plot(4) = gsn_csm_contour_map(wks,pre5,res)    
   res@tiMainString          = "(f) HadGEM3-GC31-MM"    
   plot(5) = gsn_csm_contour_map(wks,pre6,res)    
   
    
   res@tiMainString          = "(g) HadGEM3-GC31-HH"    
   plot(6) = gsn_csm_contour_map(wks,pre7,res)    
   res@tiMainString          = "(h) INM-CM5-0"    
   plot(7) = gsn_csm_contour_map(wks,pre8,res)  
   
   res@tiMainString          = "(i) INM-CM5-H"    
   plot(8) = gsn_csm_contour_map(wks,pre9,res)    
   res@tiMainString          = "(j) MPI-ESM1-2"    
   plot(9) = gsn_csm_contour_map(wks,pre10,res)    
   
   res@tiMainString          = "(k) MPI-ESM1-2-HR"    
   plot(10) = gsn_csm_contour_map(wks,pre11,res)
       
   
   
    ;;=== Add West Africa shapefile outlines to the plot ====
  lnres                  = True
  lnres@gsLineColor      = "gray25"
  lnres@gsLineThicknessF = 0.5

    id_mask=new(11,graphic)
    id_mask1=new(11,graphic)
do i=0,10
  id_mask(i) = gsn_add_shapefile_polylines(wks,plot(i),shp_filename,lnres)
end do
      

;--Panel res
   pres = True
   pres@gsnPanelRowSpec = True    
   pres@gsnMaximize = True
   pres@gsnPanelLabelBar = True
	pres@lbBoxEndCapStyle = "TriangleBothEnds"
	;pres@lbTitleString="mm/day"
	pres@lbTitleFontHeightF= .014                ; make title smaller
	pres@lbLabelFontHeightF = 0.016
       ; pres@pmLabelBarOrthogonalPosF = -0.1
   pres@gsnPanelMainString = " "
   gsn_panel(wks,plot,(/1,2,2,2,2,2/),pres)
   
   delete(wks)
   cmd = "convert -trim -geometry 950x950 +repage -border 8 -bordercolor white -background white -flatten new_trend.png new_trend.png"
   system(cmd)

  end;*************************************************

