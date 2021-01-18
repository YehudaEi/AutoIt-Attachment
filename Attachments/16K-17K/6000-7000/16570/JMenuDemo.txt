import java.awt.*;
import java.awt.event.*;

import javax.swing.JMenu;
import javax.swing.JMenuItem;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JRadioButtonMenuItem;
import javax.swing.ButtonGroup;
import javax.swing.JMenuBar;
import javax.swing.KeyStroke;
import javax.swing.ImageIcon;

import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;
import javax.swing.JFrame;


//Used Action Listner for JMenuItem & JRadioButtonMenuItem
//Used Item Listner for JCheckBoxMenuItem

public class JMenuDemo implements ActionListener, ItemListener{
    JTextArea jtAreaOutput;
    JScrollPane jspPane;

    public JMenuBar createJMenuBar() {
        JMenuBar mainMenuBar;
        JMenu menu1, menu2, submenu;
        JMenuItem plainTextMenuItem, textIconMenuItem, iconMenuItem, subMenuItem;
        JRadioButtonMenuItem rbMenuItem;
        JCheckBoxMenuItem cbMenuItem;
        ImageIcon icon = createImageIcon("jmenu.jpg");

        mainMenuBar = new JMenuBar();

        menu1 = new JMenu("Menu 1");
        menu1.setMnemonic(KeyEvent.VK_M);
        mainMenuBar.add(menu1);

        //Creating the MenuItems
        plainTextMenuItem = new JMenuItem("Menu item with Plain Text", 
        														KeyEvent.VK_T);
        //can be done either way for assigning shortcuts
        //menuItem.setMnemonic(KeyEvent.VK_T);
        
//        Accelerators, offer keyboard shortcuts to bypass navigating the menu hierarchy.
        plainTextMenuItem.setAccelerator(KeyStroke.getKeyStroke( KeyEvent.VK_1, 
        													ActionEvent.ALT_MASK));
        plainTextMenuItem.addActionListener(this);
        menu1.add(plainTextMenuItem);

        
        textIconMenuItem = new JMenuItem("Menu Item with Text & Image", icon);
        textIconMenuItem.setMnemonic(KeyEvent.VK_B);
        textIconMenuItem.addActionListener(this);
        menu1.add(textIconMenuItem);

        //Menu Item with just an Image
        iconMenuItem = new JMenuItem(icon);
        iconMenuItem.setMnemonic(KeyEvent.VK_D);
        iconMenuItem.addActionListener(this);
        menu1.add(iconMenuItem);

        menu1.addSeparator();
        //Radio Button Menu items follow a seperator
        
        ButtonGroup itemGroup = new ButtonGroup();

        rbMenuItem = new JRadioButtonMenuItem("Menu Item with Radio Button");
        rbMenuItem.setSelected(true);
        rbMenuItem.setMnemonic(KeyEvent.VK_R);
        itemGroup.add(rbMenuItem);
        rbMenuItem.addActionListener(this);
        menu1.add(rbMenuItem);

        rbMenuItem = new JRadioButtonMenuItem("Menu Item 2 with Radio Button");
        itemGroup.add(rbMenuItem);
        rbMenuItem.addActionListener(this);
        menu1.add(rbMenuItem);

        menu1.addSeparator();
        //Radio Button Menu items follow a seperator
        cbMenuItem = new JCheckBoxMenuItem("Menu Item with check box");
        cbMenuItem.setMnemonic(KeyEvent.VK_C);
        cbMenuItem.addItemListener(this);
        menu1.add(cbMenuItem);

        cbMenuItem = new JCheckBoxMenuItem("Menu Item 2 with check box");
        cbMenuItem.addItemListener(this);
        menu1.add(cbMenuItem);

        menu1.addSeparator();
        //Sub Menu follows a seperator
        submenu = new JMenu("Sub Menu");
        submenu.setMnemonic(KeyEvent.VK_S);

        subMenuItem = new JMenuItem("Sub MenuItem 1");
        subMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_2,
        													ActionEvent.CTRL_MASK));
        subMenuItem.addActionListener(this);
        submenu.add(subMenuItem);

        subMenuItem = new JMenuItem("Sub MenuItem 2");
        submenu.add(subMenuItem);
        subMenuItem.addActionListener(this);
        menu1.add(submenu);

        //Build second menu in the menu bar.
        menu2 = new JMenu("Menu 2");
        menu2.setMnemonic(KeyEvent.VK_N);
        mainMenuBar.add(menu2);

        return mainMenuBar;
    }

    public Container createContentPane() {
        //Create the content-pane-to-be.
        JPanel jplContentPane = new JPanel(new BorderLayout());
        jplContentPane.setLayout(new BorderLayout());//Can do it either way to set layout
        jplContentPane.setOpaque(true);

        //Create a scrolled text area.
        jtAreaOutput = new JTextArea(5, 30);
        jtAreaOutput.setEditable(false);
        jspPane = new JScrollPane(jtAreaOutput);

        //Add the text area to the content pane.
        jplContentPane.add(jspPane, BorderLayout.CENTER);

        return jplContentPane;
    }

    /** Returns an ImageIcon, or null if the path was invalid. */
    protected static ImageIcon createImageIcon(String path) {
        java.net.URL imgURL = JMenuDemo.class.getResource(path);
        if (imgURL != null) {
            return new ImageIcon(imgURL);
        } else {
            System.err.println("Couldn't find image file: " + path);
            return null;
        }
    }

    private static void createGUI() {
        JFrame.setDefaultLookAndFeelDecorated(true);

        //Create and set up the window.
        JFrame frame = new JFrame("JMenu Usage Demo");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        JMenuDemo app = new JMenuDemo();
        frame.setJMenuBar(app.createJMenuBar());
        frame.setContentPane(app.createContentPane());

        frame.setSize(500, 300);
        frame.setVisible(true);
    }
    
    public void actionPerformed(ActionEvent e) {
        JMenuItem source = (JMenuItem)(e.getSource());
        String s = "Menu Item source: " + source.getText()
                   + " (an instance of " + getClassName(source) + ")";
        jtAreaOutput.append(s + "\n");
        jtAreaOutput.setCaretPosition(jtAreaOutput.getDocument().getLength());
    }

    public void itemStateChanged(ItemEvent e) {
        JMenuItem source = (JMenuItem)(e.getSource());
        String s = "Menu Item source: " + source.getText()
                   + " (an instance of " + getClassName(source) + ")"
                   + "\n"
                   + "    State of check Box: "
                   + ((e.getStateChange() == ItemEvent.SELECTED) ?
                     "selected":"unselected");
        jtAreaOutput.append(s + "\n");
        jtAreaOutput.setCaretPosition(jtAreaOutput.getDocument().getLength());
    }
    
    // Returns the class name, no package info
    protected String getClassName(Object o) {
        String classString = o.getClass().getName();	
        int dotIndex = classString.lastIndexOf(".");
        return classString.substring(dotIndex+1);	//Returns only Class name
    }

    public static void main(String[] args) {

        javax.swing.SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                createGUI();
            }
        });
    }
    
    
}
