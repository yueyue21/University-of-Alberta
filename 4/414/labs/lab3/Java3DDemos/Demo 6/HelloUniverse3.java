// Adapted from java3d HelloUniverse Demo

/*
 * simply creates a cube an adds it to a universe, also allows the user to rotate the
 *  cube via the mouse 
 */
import java.net.URL;
import java.applet.Applet;
import java.awt.BorderLayout;
import java.awt.event.*;
import java.awt.GraphicsConfiguration;
import com.sun.j3d.utils.applet.MainFrame;
import com.sun.j3d.utils.geometry.ColorCube;
import com.sun.j3d.utils.universe.*;
import com.sun.j3d.utils.image.TextureLoader;
import javax.media.j3d.*;
import javax.vecmath.*;
import com.sun.j3d.utils.behaviors.mouse.MouseRotate;

public class HelloUniverse3 extends Applet {

    private SimpleUniverse u = null;
    //
    // URL stuff
    public String baseProto = "";
    public String baseHost = "";
    public String baseFile = "";
    
    public BranchGroup createSceneGraph() {

        // Create the root of the branch graph
        BranchGroup objRoot = new BranchGroup();
 
        // Create a transform group, so we can manipulate the object
        TransformGroup trans = new TransformGroup();              
        
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

        // Create a new Appearance
        Appearance appearance = new Appearance(); 
//------------------------------------------------------------------------v 

        URL url = null;
        try{
            url = new URL(baseProto, baseHost, baseFile + "image.jpg");
        }catch (java.net.MalformedURLException e){System.exit(-1);}
        
        // use a texture loader to get the texture file.
        Texture tex = new TextureLoader(url, this).getTexture();

        // Specify that we ARE using a texture
        appearance.setTexture(tex);
		
        // Create the polygon attributes to display only the wireframe
        PolygonAttributes pa = new PolygonAttributes();
        pa.setPolygonMode(pa.POLYGON_FILL);
        pa.setCullFace(pa.CULL_BACK);
//------------------------------------------------------------------------^ 
        // set the polygon attributes
        appearance.setPolygonAttributes(pa);
        
        // Create a MyGeom shape with an Appearance; add it to the TransformGroup
        trans.addChild(new MyGeom(0.4f,appearance));

        // add the transform group (and therefore also the cube) to the scene
        objRoot.addChild(trans);
      
        // Have Java 3D perform optimizations on this scene graph.
        objRoot.compile();

        return objRoot;
    }

    public HelloUniverse3() {
    }

    public void init() {
        setupurl();
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
    public void setupurl()
    {
        // set up some variables, so i can use URLs when running as an applet or application
        
        if(this.getCodeBase() == null)
        { // this is running as an application
            baseProto = "file";
            baseHost = "";
            baseFile = System.getProperty("user.dir")+"\\";
        }
        else // this is running a browser
        {
            baseProto = this.getCodeBase().getProtocol();
            baseHost = this.getCodeBase().getHost();
            baseFile = this.getCodeBase().getFile();
        }
        
    }	
}