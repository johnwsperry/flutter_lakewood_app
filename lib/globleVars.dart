﻿//<editor-fold desc="Map Vars">

//<editor-fold desc="Map Details">
double mapIconWidth = 30;
double mapIconHeight = 30;
double mapIconSize = 30;

double focusZoom = 19;
double refocusZoom = 16;
int focusAnimationDuration = 500; //ms

//focusmap
double focusMapInitZoom = 20;

//Pin Centering(Very Weird)
//Multiply by 0.000001
double latLongMultiplier = 0.000001;
int wideCenterOffset = -900;
int longCenterOffset = -300;

//Widget Centering
double wideUp = 0.5;
double wideRight = 0.4;

double longUp = 0.6;
double longRight = 0.5;

//</editor-fold>
//<editor-fold desc="Map API Information">
String mapApiUrl = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"; //Change based on url here if default url not good enough https://wiki.openstreetmap.org/wiki/Raster_tile_providers
String userPackageName = "com.lakeridge.app"; //May need changing


//</editor-fold>

//</editor-fold>