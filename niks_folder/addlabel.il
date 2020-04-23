; Create labels for nets after PnR
; By Thien Nguyen - 3/5/2011
; Usage: load "AddLabel.il"
; Make sure this file is placed in running directory
; Open the layout that needs to add labels
; Default names of supply rails: vdd, gnd

;Get current cell view
cv = geGetWindowCellView()

;Get all the terminal names 
ter = cv~>terminals~>name

;Add vdd and gnd to list
ter = append(ter '("vdd" "gnd"))

;Find the number of labels
n = length(ter)-1

;Loop to create labels
for( i 0 n

	;Find the net and compute the origin for the label
	Temp=car(dbFindNetByName( cv nth( i ter) )~>figs)~>bBox
	xVal=(xCoord(lowerLeft(Temp))+xCoord(upperRight(Temp)))*0.5
	yVal=(yCoord(lowerLeft(Temp))+yCoord(upperRight(Temp)))*0.5
	org=xVal:yVal
	
	;Find the layer
	lay=car(dbFindNetByName( cv nth( i ter) )~>figs)~>lpp
	
	;Create label
	dbCreateLabel(	
		cv  	
		lay  
		org
 		nth( i ter)
		"centerCenter"
		"R0"
		"stick"
		0.2)
)
