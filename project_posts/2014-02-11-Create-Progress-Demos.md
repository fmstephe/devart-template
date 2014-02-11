# Created Demo Pages
I have now created two demos running on Google App Engine. Now we are able to see the various stages of development of this project by viewing a working prototype.

## Rendering Text
http://hypno-go-spec.appspot.com/demo1

Here I have demonstrated that we can render a single character onto a canvas. We can see that the characters are well centered, but note that certain characters such as 'g' or 'y' render awkwardly.

## Rendering 10,000 Particles
http://hypno-go-spec.appspot.com/demo2

Here I have demonstrated that we can render 10,000 particles onto a small canvas. On my Linux PC this demo runs at a slow 10 frames per second. Profiling has shown the bottleneck to be in the canvas rendering calls. It should be noted that chrome does not hardware accelerate 2d canvas rendering on Linux and this may run significantly faster on other platforms.
