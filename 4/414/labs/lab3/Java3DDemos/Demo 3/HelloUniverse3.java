// Adapted from java3d HelloUniverse Demo

/*
 * simply creates a cube an adds it to a universe, also allows the user to rotate the
 *  cube via the mouse 
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
//------------------------------------------------------------------------v
import com.sun.j3d.utils.behaviors.mouse.MouseRotate;
//------------------------------------------------------------------------^

public class HelloUniverse3 extends Applet {

    private SimpleUniverse u = null;
    
    public BranchGroup createSceneGraph() {

        // Create the root of the branch graph
        BranchGroup objRoot = new BranchGroup();
 
        // Create a transform group, so we can manipulate the object
        TransformGroup trans = new TransformGroup();
//------------------------------------------------------------------------v               
        
        // create a behavior to allow the user to move the object with the mouse
        MouseRotate    mr = new MouseRotate();
        
        // tell the behavior which transform Group it is operating on
        mr.setTransformGroup(trans);
        
        // create the bounds for rotate behavior (centered at the origin) 
        BoundingSphere bounds = new BoundingSphere(new Point3d(0.0,0.0,0.0), 100.0);
        mr.setSchedulingBounds(bounds);
        
        // add the Rotate Behavior to the root.(not the transformGroup
        objRoot.addChild(mr);
        
        // since the transfom in the transformGroup will be changing when we rotate the object
        // we need to explicitly allow the transform to be read, and written.
        trans.setCapability(trans.ALLOW_TRANSFORM_READ);
        trans.setCapability(trans.ALLOW_TRANSFORM_WRITE);

//------------------------------------------------------------------------^           
        
        // Create a simple Shape3D node; add it to the TransformGroup
        trans.addChild(new ColorCube(0.4));
       
        // add the transform group (and therefore also the cube) to the scene
        objRoot.addChild(trans);
      
        // Have Java 3D perform optimizations on this scene graph.
        objRoot.compile();

        return objRoot;
    }

    public HelloUniverse3() {
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
        new MainFrame(new HelloUniverse3(), 256, 256);
    }
}


