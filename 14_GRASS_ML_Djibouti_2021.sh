#!/bin/sh

# create new location from raster map (file must contain projection metadata):
# grass -c myraster.tif /home/user/grassdata/mynewlocation
grass
#cd /Users/polinalemenkova/grassdata
#grass -c LC09_L2SP_179073_20220419_20230421_02_T1_SR_B1.tif /Users/polinalemenkova/grassdata/Tibet

# ----IMPORT AND PREPROCESSING-------------------------->
# g.mapset location=Tibet mapset=PERMANENT

# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/Djibouti/LC08_L2SP_166052_20210819_20210827_02_T1_SR_B1.TIF output=L_2021_01 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Djibouti/LC08_L2SP_166052_20210819_20210827_02_T1_SR_B2.TIF output=L_2021_02 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Djibouti/LC08_L2SP_166052_20210819_20210827_02_T1_SR_B3.TIF output=L_2021_03 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Djibouti/LC08_L2SP_166052_20210819_20210827_02_T1_SR_B4.TIF output=L_2021_04 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Djibouti/LC08_L2SP_166052_20210819_20210827_02_T1_SR_B5.TIF output=L_2021_05 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Djibouti/LC08_L2SP_166052_20210819_20210827_02_T1_SR_B6.TIF output=L_2021_06 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/Djibouti/LC08_L2SP_166052_20210819_20210827_02_T1_SR_B7.TIF output=L_2021_07 extent=region resolution=region
#
g.list rast
# shaded relief
r.import input=/Users/polinalemenkova/grassdata/Djibouti/gebco_2023_1.tif output=shaded_relief1 extent=region --overwrite
r.contour shaded_relief1 out=isolines step=200 --overwrite
#
g.list rast
# g.remove -f type=raster name=training_pixels

# color composites
r.composite blue=L_2021_07 green=L_2021_05 red=L_2021_04 output=L_2021_754 --overwrite
d.mon wx0
d.rast L_2021_754
d.out.file output=Tibet_754 format=jpg --overwrite
#
r.composite blue=L_2021_03 green=L_2021_04 red=L_2021_05 output=L_2021_345 --overwrite
d.mon wx0
d.rast L_2021_345
d.out.file output=Tibet_345 format=jpg --overwrite
#
r.composite blue=L_2021_01 green=L_2021_05 red=L_2021_06 output=L_2021_156 --overwrite
d.mon wx0
d.rast L_2021_156
d.out.file output=Tibet_156 format=jpg --overwrite
#
r.composite blue=L_2021_07 green=L_2021_04 red=L_2021_01 output=L_2021_741 --overwrite
d.mon wx0
d.rast L_2021_741
d.out.file output=Tibet_741 format=jpg --overwrite
#
r.composite blue=L_2021_02 green=L_2021_03 red=L_2021_04 output=L_2021_234 --overwrite
d.mon wx0
d.rast L_2021_234
d.out.file output=Tibet_234 format=jpg --overwrite
#
r.composite blue=L_2021_05 green=L_2021_04 red=L_2021_03 output=L_2021_543 --overwrite
d.mon wx0
d.rast L_2021_543
d.out.file output=Tibet_543 format=jpg --overwrite
#
r.composite blue=L_2021_02 green=L_2021_04 red=L_2021_06 output=L_2021_246 --overwrite
d.mon wx0
d.rast L_2021_246
d.out.file output=Tibet_246 format=jpg --overwrite
#
r.composite blue=L_2021_03 green=L_2021_02 red=L_2021_01 output=L_2021_321 --overwrite
d.mon wx0
d.rast L_2021_321
d.out.file output=Tibet_321 format=jpg --overwrite
#
#

# ---CLUSTERING AND CLASSIFICATION------------------->
# grouping data by i.group
# Set computational region to match the scene
g.region raster=L_2021_01 -p
i.group group=L_2021 subgroup=res_30m \
  input=L_2021_01,L_2021_02,L_2021_03,L_2021_04,L_2021_05,L_2021_06,L_2021_07 --overwrite
#
# Clustering: generating signature file and report using k-means clustering algorithm
i.cluster group=L_2021 subgroup=res_30m \
  signaturefile=cluster_L_2021 \
  classes=10 reportfile=rep_clust_L_2021.txt --overwrite

# Classification by i.maxlik module
i.maxlik group=L_2021 subgroup=res_30m \
  signaturefile=cluster_L_2021 \
  output=L_2021_clusters reject=L_2021_cluster_reject --overwrite
#
r.colors L_2021_clusters color=roygbiv
r.colors shaded_relief1 color=grey
#
# Mapping
g.region raster=L_2021_01 -p
d.mon wx0
d.rast shaded_relief
d.vect isolines color='100:93:134' width=0
d.rast L_2021_clusters
d.grid -g size=00:30:00 color=white width=0.1 fontsize=16 text_color=white
d.legend raster=L_2021_clusters title="Clusters 2021" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white
d.legend raster=shaded_relief title="Relief, m" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white -f
d.out.file output=Djibouti_2021 format=jpg --overwrite
#
# Mapping rejection probability
d.mon wx2
g.region raster=L_2021_clusters -p
r.colors L_2021_cluster_reject color=soilmoisture -e
d.rast shaded_relief
d.vect isolines color='100:93:134' width=0
d.rast L_2021_cluster_reject
d.grid -g size=00:30:00 color=white width=0.1 fontsize=16 text_color=white
d.legend raster=L_2021_cluster_reject title="2021" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white
d.legend raster=shaded_relief title="Relief, m" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white -f
d.out.file output=Djibouti_2021_reject format=jpg --overwrite

# ----------------- RENAMING CLASSES ------------------->
echo "
1 = 1 water
2 = 1 water
3 = 2 herbaceous vegetation
4 = 3 shrubland
5 = 4 artificial surface
6 = 5 consolidated land
7 = 6 grassland
8 = 7 sparse vegetation
9 = 8 cropland
10 = 9 mosaic shrubland" > landusereclass.txt

r.reclass input=L_2021_clusters output=L_2021_reclass \
  rules=landusereclass.txt \
  title="LCC 2021"
  
r.category L_2015_reclass

# Mapping reclass
d.mon wx2
g.region raster=L_2021_reclass -p
r.colors L_2021_reclass color=roygbiv -e
d.rast shaded_relief
d.vect isolines color='100:93:134' width=0
d.rast L_2021_reclass
d.grid -g size=00:30:00 color=white width=0.1 fontsize=16 text_color=white
d.legend raster=L_2015_reclass title="Reclass 2021" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white
d.legend raster=shaded_relief title="Relief, m" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white -f
d.out.file output=Djibouti_2021_reclass format=jpg --overwrite
#
#
# --------------------- MACHINE LEARNING ------------------------>
#
# Generating training pixels from an older (1996) land cover classification:
r.random input=L_2015_reclass seed=100 npoints=1000 raster=training_pixels --overwrite
# Then use these training pixels to perform a classification on recent Landsat image:
# 1. RF ------------------------>
# train a RandomForestClassifier model using r.learn.train
r.learn.train group=L_2021 training_map=training_pixels \
    model_name=GradientBoostingClassifier n_estimators=500 save_model=gb_model.gz --overwrite
# perform prediction using r.learn.predict
r.learn.predict group=L_2021 load_model=gb_model.gz output=gb_classification_2021 --overwrite
# check raster categories - they are automatically applied to the classification output
r.category gb_classification_2021
#
# display
r.colors gb_classification_2021 color=bgyr -e
d.mon wx0
d.rast shaded_relief
d.vect isolines color='100:93:134' width=0
d.rast gb_classification_2021
d.grid -g size=00:30:00 color=white width=0.1 fontsize=16 text_color=white
d.legend raster=gb_classification_2021 title="Gradient Boosting 2021" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white
d.legend raster=shaded_relief title="Relief, m" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white -f
d.out.file output=GB_2021 format=jpg --overwrite


# 2. SVM ------------------------>
# train a SVC model using r.learn.train
r.learn.train group=L_2021 training_map=training_pixels \
    model_name=SVC n_estimators=500 save_model=svc_model.gz --overwrite
# perform prediction using r.learn.predict
r.learn.predict group=L_2021 load_model=svc_model.gz output=svc_classification --overwrite
# check raster categories - they are automatically applied to the classification output
r.category svc_classification
# display
#r.colors rf_classification color=soilmoisture -e
r.colors svc_classification color=bcyr -e
#r.colors svc_classification color=plasma -e
d.mon wx1
d.rast shaded_relief1
d.vect isolines color='100:93:134' width=0
d.rast svc_classification
d.grid -g size=00:30:00 color=white width=0.1 fontsize=16 text_color=white
d.legend raster=svc_classification title="SVM 2019" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white
d.legend raster=shaded_relief1 title="Relief, m" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white -f
d.out.file output=SVM_2019 format=jpg --overwrite
# ------------------------<
# 3. MLPClassifier ------------------------>
r.learn.train group=L_2021 training_map=training_pixels \
    model_name=MLPClassifier n_estimators=500 save_model=mlpc_model.gz --overwrite
# perform prediction using r.learn.predict
r.learn.predict group=L_2021 load_model=mlpc_model.gz output=mlpc_classification --overwrite
# check raster categories - they are automatically applied to the classification output
r.category mlpc_classification
# display
r.colors mlpc_classification color=plasma -e
d.mon wx1
d.rast shaded_relief1
d.vect isolines color='100:93:134' width=0
d.rast mlpc_classification
d.grid -g size=00:30:00 color=white width=0.1 fontsize=16 text_color=white
d.legend raster=mlpc_classification title="MLPC 2019" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white
d.legend raster=shaded_relief1 title="Relief, m" title_fontsize=19 font="Helvetica" fontsize=17 bgcolor=white border_color=white -f
d.out.file output=MLPC_2019 format=jpg --overwrite
