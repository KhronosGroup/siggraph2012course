siggraph2012course
==================

Presentations for SIGGRAPH 2012 course "Graphics Programming on the Web" covering HTML5 technologies (Canvas, CSS, etc.), WebGL and WebCL.

Links to content
----------------

The content is available under:

http://khronosgroup.github.com/siggraph2012course/CanvasCSSAndWebGL/canvas_and_css.html
http://khronosgroup.github.com/siggraph2012course/CanvasCSSAndWebGL/webgl.html
http://khronosgroup.github.com/siggraph2012course/WebCL/WebCL%20Course%20Notes.pdf
http://khronosgroup.github.com/siggraph2012course/WebCL/WebCL%20S12%20web.pptx


Keeping the served content up to date
-------------------------------------

Run the following commands once in your repository upon initial checkout:

git config --add remote.origin.push +refs/heads/master:refs/heads/master
git config --add remote.origin.push +refs/heads/master:refs/heads/gh-pages

Then a "git push" with the master branch checked out will also update the gh-pages branch, which is served by Github.

Thanks to http://stackoverflow.com/questions/5807459/github-mirroring-gh-pages-to-master .
