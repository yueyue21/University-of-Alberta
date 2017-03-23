// Adapted from java3d HelloUniverse Demo

/*
 * simply creates a cube an adds it to a universe. and rotates it slightly
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

public class HelloUniverse2 extends Applet {

    private SimpleUniverse u = null;
    
    public BranchGroup createSceneGraph() {

        // Create the root of the branch graph
        BranchGroup objRoot = new BranchGroup();
//------------------------------------------------------------------------v        
        // Create a transform group, so we can manipulate the object
        TransformGroup trans = new TransformGroup();
        
        // create a Transform to rotate about 30degrees
        Transform3D transform = new Transform3D();
        transform.rotY(0.52);
        // apply the transform
        trans.setTransform(transform);
        
        
        // Create a simple Shape3D node; add it to the TransformGroup
        trans.addChild(new ColorCube(0.4));
        // add the transform group (and therefore also the cube) to the scene
        objRoot.addChild(trans);

//------------------------------------------------------------------------^        
        // Have Java 3D perform optimizations on this scene graph.
        objRoot.compile();

        return objRoot;
    }

    public HelloUniverse2() {
    }

    public void init() {
        setLayout(new BorderLayout());
        GraphicsConfiguration config =
           SimpleUniverse.getPreferredConfiguration();

        Canvas3D c = new Canvas3D(config);
        add("Center", c);

        // Create a simple scene and attach it to the virtual universe
        BranchGroup scene = createSceneGraph();

        u = new SimpleUniverse(c);

        // This will move the ViewPlatform back a bit so the
        // objects in the scene can be viewed.
        u.getViewingPlatform().setNominalViewingTransform();

        // add the objects to the universe
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
        new MainFrame(new HelloUniverse2(), 256, 256);
    }
}