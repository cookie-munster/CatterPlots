#
# CatterPlots
#
# Copyright (c) 2016 David L Gibbs
# email: gibbsdavidl@gmail.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#' Multi-cat!  More cats. More colors.
#'
#' @param xs a vector of numbers
#' @param ys another vector of numbers
#' @param size the size of the cat (0.1 is a good starting point)
#' @param cat a vector of cats
#' @param catcolor a list of modifier vectors to the png matrix (try c(1,0,0,1))
#' @param linecolor color of plotted lines
#' @param type the type of plot ... justcats, or line
#' @param canvas the plotting area
#'
#' @return a cat plot object... to plot more cats.
#' @examples
#' x <- -10:10
#' y <- -x^2 + 10
#' purr <- catplot(xs=x, ys=y, cat=c(1,2,3), catcolor=list(c(1,0,0,1), c(0,1,1,1)))
#' cats(purr, -x, -y, cat=4, catcolor=c(1,0,1,1))'
#' @export
multicat <- function(xs, ys,
					size=0.1, cat=c(1,2),
					catcolor = c(0,0,0,1),
					linecolor=1, type="justcats",
					canvas=c(0,1.1,0,1.1), ...) {
	require(png)
	data(cats)

	args <- list(...)

	plot(x=xs, y=ys, col=0, xaxt="n", yaxt="n", ...)
	par(usr=canvas)

	img <- catdat[[cat[1]]]
	dims<-dim(img)[1:2] #number of x-y pixels for the img (aspect ratio)
	AR<-dims[1]/dims[2]

	scaledData <- scaleData(xs,ys,args)
	xscale <- scaledData$xscale
	yscale <- scaledData$yscale

	xat = seq(min(xscale), max(xscale), length.out=length(xscale))
	yat = seq(min(yscale), max(yscale), length.out=length(yscale))
	xaxtlab = round(seq(min(xs), max(xs),length.out=length(xat)),1)
	yaxtlab = round(seq(min(ys), max(ys),length.out=length(xat)),1)
	axis(side=1, at=xat, labels=xaxtlab)
	axis(side=2, at=yat, labels=yaxtlab)

	if (type == "line") {
		points(x=xscale, y=yscale, col=linecolor, type="l")
	}

	cats <- rep(cat, length(xscale))
	catcolors <- rep(catcolor, length(xscale))
	for (i in 1:length(xscale)) {
		thiscat <- cats[i]
		thiscolor <- catcolors[[i]]
		img <- catdat[[thiscat]]
		# modify the cat image
		imgMod <- colorMod(img, thiscolor)
		rasterImage(imgMod, xscale[i]-(size/2), yscale[i]-(size/2), xscale[i]+(size/2), yscale[i]+(size/2), interpolate=TRUE)
	}

	list(xs=xs, ys=ys, args=args, canvas=canvas)
}


multipoint <- function(xs, ys,
					ptsize=0.1,
					catcolor = c(0,0,0,1),
					linecolor=1,
					canvas=c(0,1.1,0,1.1),
                     ...) {

	args <- list(...)

	plot(x=xs, y=ys, col=0, xaxt="n", yaxt="n", ...)
	par(usr=canvas)

    pointColor <- rgb(catcolor[1], catcolor[2], catcolor[3], maxColorValue=255)

	scaledData <- scaleData(xs,ys,args)
	xscale <- scaledData$xscale
	yscale <- scaledData$yscale

    points(x=xscale, y=yscale, col=pointColor, xaxt="n", yaxt="n", pch=15, cex=ptsize, ...)

	xat = seq(min(xscale), max(xscale), length.out=length(xscale))
	yat = seq(min(yscale), max(yscale), length.out=length(yscale))
	xaxtlab = round(seq(min(xs), max(xs),length.out=length(xat)),1)
	yaxtlab = round(seq(min(ys), max(ys),length.out=length(xat)),1)
	axis(side=1, at=xat, labels=xaxtlab)
	axis(side=2, at=yat, labels=yaxtlab)

	list(xs=xs, ys=ys, args=args, canvas=canvas)
}


#' Plot even more cats! In more colors and shapes!
#'
#' @param obj a catplot object, returned from catplot
#' @param xs a vector of numbers
#' @param ys another vector of numbers
#' @param size the size of the cat (0.1 is a good starting point)
#' @param cat the cat model, 1 through 12
#' @param catcolor a modifier vector to the png matrix (try c(1,0,0,1))
#' @param linecolor color of plotted lines
#' @param type the type of plot ... justcats, or line
#' @param yshift shifts the cat up or down, within the scaled space
#' @param xshift shifts the cat left or right, within the scaled space.
#'
#' @return a cat plot object... to plot more cats.
#' @examples
#' x <- -10:10
#' y <- -x^2 + 10
#' purr <- multicat(xs=x, ys=y, cat=c(1,2,3), catcolor=c(0,1,1,1))
#' cats(purr, -x, -y, cat=4, catcolor=c(1,0,1,1))'
#' @export
morecats <- function(obj=NULL, xs, ys, size=0.1, cat=c(4,5,6), catcolor = list(c(0,0,1,1),c(0,1,0,1)),
										linecolor=1, type="justcats", yshift=0, xshift=0) {
	# needs a plot already up, and the catObj returned from it.
	if(is.null(obj)) {
		print("Please feed the cats!  cat_food <- catplot(...);  cats(cat_food, ...)")
	}

	img <- catdat[[cat[1]]]
	dims<-dim(img)[1:2] #number of x-y pixels for the img (aspect ratio)
	AR<-dims[1]/dims[2]

	scaledData <- catsScaleData(obj,xs,ys)
	xscale <- scaledData$xscale + xshift
	yscale <- scaledData$yscale + yshift

	if (type == "line") {
		points(x=xscale, y=yscale, col=linecolor, type="l")
	}


	cats <- rep(cat, length(xscale))
	catcolors <- rep(catcolor, length(xscale))
	for (i in 1:length(xscale)) {
		thiscat <- cats[i]
		thiscolor <- catcolors[[i]]
		img <- catdat[[thiscat]]
		# modify the cat image
		imgMod <- colorMod(img, thiscolor)
		rasterImage(imgMod, xscale[i]-(size/2), yscale[i]-(size/2), xscale[i]+(size/2), yscale[i]+(size/2), interpolate=TRUE)
        print(paste(xscale[i]-(size/2), "  ",
                    yscale[i]-(size/2), "  ",
                    xscale[i]+(size/2), "  ",
                    yscale[i]+(size/2)))
	}
}


morepoints <- function(obj=NULL, xs, ys, ptsize=0.1, catcolor = c(0,0,1,1), yshift=0, xshift=0) {
	# needs a plot already up, and the catObj returned from it.
	if(is.null(obj)) {
		print("Please feed the cats!  cat_food <- catplot(...);  cats(cat_food, ...)")
	}

	scaledData <- catsScaleData(obj,xs,ys)
	xscale <- scaledData$xscale + xshift
	yscale <- scaledData$yscale + yshift

    pointColor <- rgb(catcolor[1], catcolor[2], catcolor[3], maxColorValue=1)
    print(pointColor)

	points(x=xscale, y=yscale, col=pointColor, xaxt="n", yaxt="n", pch=15, cex=ptsize)
}
