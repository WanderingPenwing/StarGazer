A Stellarium game using the game engine Godot (for Optimized rendering of many objects on mpped on a sphere)

Star data from : YaleBrightStarCatalog (Bretton Wade) https://github.com/brettonw/YaleBrightStarCatalog/blob/master/bsc5-short.json (MIT License, Copyright (c) 2016 Bretton Wade)

Constellation data from : Lizard Tail (Isana Kashiwai) https://www.lizard-tail.com/isana/lab/starlitnight/



If you want to take a look at the code to help me out, most of the interesting bits are there : scripts/static/

stars.gd loads the stars from the files and format it
fetch_info.gd has the Partition of stars and has functions to look through it (for stars or constellations
lone_star.gd is a bit of data stored by each star
camera.gd handles the movement of the camera and the display of most things
