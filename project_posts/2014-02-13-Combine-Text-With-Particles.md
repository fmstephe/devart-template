# Combined Text With Particles

http://hypno-go-spec.appspot.com/demo4

We now have combined the text, , with the 3D particles, , and added a new visual trick slowing down some paricles while speeding others up. We use the canvas, now hidden, on which we are drawing text to decide whether to slow down or speed up our particles. When a particle moves over a black pixel on the text canvas we slow it down when it passes over a white pixel we speed it up. This has the effect of revealing the hidden text through the paricles.

Additionally we are no longer printing out the Go language specification. We are downloading the client source code for the web app itself and printing that. This idea came from an old article about self printing programs, http://en.wikipedia.org/wiki/Quine_(computing). Although this is not the same kind of self printing it is fun to take a new angle on an old, and seriously geeky, game.
