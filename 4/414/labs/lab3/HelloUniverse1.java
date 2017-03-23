// Adapted from java3d HelloUniverse Demo

/*
 * simply creates a cube an adds it to a universe. 
 *  ---> looks like a square because the default view looks straigt at one side
 */

import java.applet.Applet;
import java.awt.BorderLayout;
import java.awt.event.*;
import java.awt.GraphicsConfiguration;
import com.sun.j3d.utils.applet.MainFrame;
import com.sun.j3d.utils.geometry.ColorCube;
import com.sun.j3d.utils.universe.*;
import javax.media.j3d.*;
import javax.vecmath.*;

public class HelloUniverse1 extends Applet {

    private SimpleUniverse u = null;
    
    public BranchGroup createSceneGraph() {

        // Create the root of the branch graph
        BranchGroup objRoot = new BranchGroup();

        // Create a simple Shape3D node; add it to the scene graph.
        objRoot.addChild(new ColorCube(0.4));

        // Have Java 3D perform optimizations on this scene graph.
        objRoot.compile();

        return objRoot;
    }

    public HelloUniverse1() {
    }

    public void init() {
        setLayout(new BorderLayout());
        // get the preferred graphics configuration to help prevent flicker in the display
        GraphicsConfiguration config = SimpleUniverse.getPreferredConfiguration();

        // create a new canvas3d
        Canvas3D c = new Canvas3D(config);
        add("Center", c);

        // Create a simple scene 
        BranchGroup scene = createSceneGraph();

        // initialize the universe
        u = new SimpleUniverse(c);

        // This will move the ViewPlatform back a bit so the
        // objects in the scene can be viewed.
        u.getViewingPlatform().setNominalViewingTransform();

        // add the objects (scene) to the universe
        u.addBranchGraph(scene);
    }

    public void destroy() {
        u.removeAllLocales();
    }

    //
    // The following allows HelloUniverse to be run as an application
    // as well as an applet
    //
    public static void main(String[] args) {
        new MainFrame(new HelloUniverse1(), 256, 256);
    }
}

