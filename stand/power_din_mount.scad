bodyHeight = 19.6;
bodyWidth = 19.5;
bodyDepth = 19;
frontThickness = 1.8;
mountingHoleDiameter=2;

pcbThickness = 1.6;
pcbWidth = 18.5;
pcbDepth = 17.5;

connectorWidth = 9.5;
connectorHeight = 4;

icY = 9.6;
icThickness = 1;
icDiameter = 12;
diodeWidth = 8;

cylinderPrecision=20;
spherePrecision=100;

baseHeight = bodyHeight/2 - pcbThickness/2 - connectorHeight/2;

dentDiameter = 40;
dentThickness = 0.3;

module mountingHoles() {
    xFix = 0.4;
    
    holes = [
     [3.7,1],[13.8,1]
    ,[1.2,10.8] ,[1.2,15.8], [3.8,13.4]
    ,[16.4,10.8],[16.4,15.8],[14,13.4] ];
    xOffset = (bodyWidth - pcbWidth)/2;
    for (i = [ 0 : len(holes) - 1 ]) 
    {
        point=holes[i];
        translate([point[0]+xOffset+xFix,point[1]+frontThickness,0])
        {
            cylinder(d=mountingHoleDiameter,h=bodyHeight, $fn=cylinderPrecision);
        }
    }
}

module bodyBase() {
    difference() {
        cube([bodyWidth, bodyDepth, bodyHeight]);
        translate([0,frontThickness,baseHeight]) { cube([bodyWidth, bodyDepth, bodyHeight]); };
    }
};

module pcb() {
    xOffset = (bodyWidth - pcbWidth)/2;
    yOffset = baseHeight - pcbThickness/2;
    translate([xOffset,frontThickness,yOffset]) { cube([pcbWidth,pcbDepth,pcbThickness]);};
}

module connector() {
    zOffset = baseHeight+pcbThickness/2+connectorHeight/2;// (bodyHeight-pcbThickness)/2;
    translate([bodyWidth/2,frontThickness/2,zOffset]) {
        rotate([90,0,0]) {
            hull() {
                translate([connectorWidth/2 - connectorHeight/2,0,0]) { cylinder(d=connectorHeight,h=frontThickness,$fn=cylinderPrecision,center=true); }
                translate([-(connectorWidth/2 - connectorHeight/2),0,0]) { cylinder(d=connectorHeight,h=frontThickness,$fn=cylinderPrecision,center=true); }
            }
        }
    }
}

module icCutout() {
    translate([bodyWidth/2,bodyHeight/2,baseHeight-icThickness - pcbThickness/2]) {
        cylinder(d=icDiameter,h=icThickness,$fn=cylinderPrecision);
    }
}

module diodeCutout() {
    translate([(bodyWidth - diodeWidth)/2,bodyDepth/2,baseHeight-icThickness - pcbThickness/2]) {
        cube([diodeWidth,bodyDepth/2,icThickness]);
    }
}

module dent() {
    translate([bodyWidth/2, -dentDiameter/2 + frontThickness - dentThickness, bodyHeight/2]) { sphere(d=dentDiameter, $fn=spherePrecision); };
}

difference() {
    bodyBase();
    mountingHoles();
    connector();
    icCutout();
    diodeCutout();
    dent();
    pcb();
}
