# get the interactor ui
source vtkInt.tcl
source "colors.tcl"
# First create the render master
vtkRenderMaster rm;

# Now create the RenderWindow, Renderer and both Actors
#
set renWin [rm MakeRenderWindow];
set ren1   [$renWin MakeRenderer];
set iren [$renWin MakeRenderWindowInteractor];

# create pipeline
#
vtkPLOT3DReader pl3d;
    pl3d SetXYZFileName "../../data/combxyz.bin"
    pl3d SetQFileName "../../data/combq.bin"
    pl3d SetScalarFunctionNumber 100;
    pl3d SetVectorFunctionNumber 202;
    pl3d Update;
vtkContourFilter iso;
    iso SetInput [pl3d GetOutput];
    iso SetValue 0 .38;
vtkPolyNormals normals;
    normals SetInput [iso GetOutput];
    normals SetFeatureAngle 45;
vtkPolyMapper isoMapper;
    isoMapper SetInput [normals GetOutput];
    isoMapper ScalarsVisibleOff;
vtkActor isoActor;
    isoActor SetMapper isoMapper;
    eval [isoActor GetProperty] SetColor $bisque;

vtkStructuredGridOutlineFilter outline;
    outline SetInput [pl3d GetOutput];
vtkPolyMapper outlineMapper;
    outlineMapper SetInput [outline GetOutput];
vtkActor outlineActor;
    outlineActor SetMapper outlineMapper;

# Add the actors to the renderer, set the background and size
#
$ren1 AddActors outlineActor;
$ren1 AddActors isoActor;
$ren1 SetBackground 1 1 1;
$renWin SetSize 500 500;
$ren1 SetBackground 0.1 0.2 0.4;

set cam1 [$ren1 GetActiveCamera];
$cam1 SetClippingRange 3.95297 50
$cam1 SetFocalPoint 9.71821 0.458166 29.3999
$cam1 SetPosition 2.7439 -37.3196 38.7167
$cam1 CalcViewPlaneNormal;
$cam1 SetViewUp -0.16123 0.264271 0.950876

# render the image
#
$iren SetUserMethod {wm deiconify .vtkInteract};

$renWin Render;
#$renWin SetFileName "combIso.tcl.ppm";
#$renWin SaveImageAsPPM;

# prevent the tk window from showing up then start the event loop
wm withdraw .


