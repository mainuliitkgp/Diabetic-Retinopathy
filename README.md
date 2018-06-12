*********************************************************************
*********************************************************************
REQUIREMENTS: MATLAB R2017a -- TESTED (might be able to run on lower 
versions of MATLAB as well.)

MAIN PROJECT FILE:
classifierGUI.m --> GUI for training and testing the neural network 
for DR gradation

NOTE: Follow the link to get the installer for the standalone 
version of this GUI application: 
https://drive.google.com/open?id=1Fl-nm_pCb_t4gyzco-IfSd5ktkc74Q2X

Run installer to install R2017a run-time environment. If unable to 
correctly use the standalone application, run the GUI using 
classifierGUI.m in MATLAB.

*********************************************************************
HELPER FILES USED:
Function descriptions are clearly written in each of the main 
function files, please read them for correct usage and input/output 
arguments.

1) avr.m --> Calculates the AVR of the image
2) bloodvessel.m --> Calculates blood vessel pixel density
3) colorMoment.m --> Calculates color moment of an image
4) exudate.m --> Calculates exudate pixel density
5) featExtract.m --> Extracts all statistical and texture features
6) fuzzysegment.m --> Segments image into a BW image using 'nclus' 
clusters
7) neuralnetscript.m --> Script for training the neural network
8) opticdisc.m --> Extracts the opticdisc and calculates Optic Disc 
to Eye ratio
9) textureExtract.m --> Calculates texture features for the image

*********************************************************************
DATA FILES USED:
1) feat3.mat --> Training set. ***Please check featExtract.m and the 
extractFeatures helper function in classifierGUI.m for the order of 
features in this matrix***
2) neuralnetconfig.mat --> Default neural network configuration
3) nn_targ3.mat --> Targets (in correct format) for training the 
neural network

*********************************************************************
*********************************************************************
ADDITIONAL FILES FOR RANDOM FOREST CLASSIFIER:
1) classifiers.m --> Trains and tests a random forest classifier for 
DR gradation

DATA FILES USED:
1) feat3.mat --> Training set. ***Please check featExtract.m and the 
extractFeatures helper function in classifierGUI.m for the order of 
features in this matrix***
2) targ2.mat --> Targets (in correct format) for training the random 
forest classifier

*********************************************************************
*********************************************************************
ADDITIONAL FILES FOR Fuzzy Support Vector Machine CLASSIFIER:
1) ftsvmtrain.m --> Trains a fuzzy support vector machine for 
DR gradation
2) ftsvmclass.m --> Tests a fuzzy support vector machine for 
DR gradation
3) fuzzy.m --> Compute fuzzy membership
4) rbf_kernel.m --> Radial basis function kernel for SVM functions
5) ftsvmplot.m --> Visualizing
6) L1CD.m --> Dual  coordinate descent  for the ftsvm

DATA FILES USED:
1) feat.mat --> Training set.
2) lbl.mat --> Targets (in correct format) for training the fuzzy 
support vector machine classifier

*********************************************************************
*********************************************************************
TO DOWNLOAD IMAGE DATABASE PLEASE VISIT AND READ THE INFORMATION
PROVIDED AT http://www.adcis.net/en/Download-Third-Party/Messidor.html
