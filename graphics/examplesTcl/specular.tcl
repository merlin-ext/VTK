# this is a tcl version showing diffs between flat & gouraud
# get the interactor ui
source vtkInt.tcl
# First create the render master
#
vtkRenderMaster rm;

# Now create the RenderWindow, Renderer and both Actors
#
set renWin [rm MakeRenderWindow];
set ren1   [$renWin MakeRenderer];
set iren [$renWin MakeRenderWindowInteractor];

# create a sphere source and actor
#
vtkSphereSource sphere;
sphere SetThetaResolution 30;
sphere SetPhiResolution 30;
vtkPolyMapper   sphereMapper;
    sphereMapper SetInput [sphere GetOutput];
vtkLODActor sphereActor;
    sphereActor SetMapper sphereMapper;

# Add the actors to the renderer, set the background and size
#
$ren1 AddActors sphereActor;
$ren1 SetBackground 0.1 0.2 0.4;
$renWin SetSize 375 375;

# render the image
#
$iren SetUserMethod {wm deiconify .vtkInteract};
set cam1 [$ren1 GetActiveCamera];
$cam1 Zoom 1.4;
$iren Initialize;
$cam1 Azimuth 30;
$cam1 Elevation -50;

set prop [sphereActor GetProperty];
$prop SetDiffuseColor 1.0 0 0;
$prop SetDiffuse 0.6;
$prop SetSpecularPower 5;
$prop SetSpecular 0.5;
$renWin Render;
$renWin SetFileName f1.ppm;
#$renWin SaveImageAsPPM;

$prop SetSpecular 1.0;
$renWin Render;

#$renWin SetFileName specular.tcl.ppm;
#$renWin SaveImageAsPPM;

# prevent the tk window from showing up then start the event loop
wm withdraw .


