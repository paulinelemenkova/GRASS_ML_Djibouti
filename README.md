# GRASS GIS Scripts — Gradient Boosting Reclassification of Landsat over Djibouti

GRASS GIS shell scripts used to produce the figures in the peer-reviewed article by Polina Lemenkova. The scripts run a full image-analysis workflow on a Landsat 8-9 OLI/TIRS time series (2015, 2019, 2021, 2023) over Djibouti and Lake Assal: import, colour composites, clustering, maximum-likelihood classification, reclassification and gradient boosting machine-learning classification.

**Published in:** *Journal of Imaging* **2025**, *11*(8), 249
**DOI:** https://doi.org/10.3390/jimaging11080249
**Journal (open access):** https://www.mdpi.com/2313-433X/11/8/249
**Zenodo:** https://doi.org/10.5281/zenodo.16362444
**HAL:** https://hal.science/hal-05178165v1
**SSRN:** https://papers.ssrn.com/sol3/papers.cfm?abstract_id=5363001

## Contents
Shell scripts calling GRASS GIS modules for raster import (r.import), colour composites (r.composite), contouring (r.contour) over a GEBCO shaded relief, clustering and classification (i.group, i.cluster k-means, i.maxlik maximum-likelihood), reclassification (r.reclass, r.category), training-sample generation (r.random) and machine-learning classification (r.learn.train, r.learn.predict) with a Gradient Boosting classifier, alongside Support Vector Machine and Multilayer Perceptron comparisons, using Python's Scikit-Learn library. One script per year (2015, 2019, 2021, 2023).

## LaTeX source
The LaTeX source (prose) of this article is in a separate repository: https://github.com/paulinelemenkova/gradient-boosting-reclassification-djibouti

## Citation
Lemenkova, P. Reclassification Scheme for Image Analysis in GRASS GIS Using Gradient Boosting Algorithm: A Case of Djibouti, East Africa. *Journal of Imaging* **2025**, *11*(8), 249. https://doi.org/10.3390/jimaging11080249
